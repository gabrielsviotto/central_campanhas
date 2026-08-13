# Central de Campanhas

Painel para a equipe da Novo Mundo acompanhar o saldo pendente/pago por colaborador em campanhas comerciais.

- **App**: `index.html` — página estática (sem build), lê os dados direto do Supabase e atualiza sozinha via Realtime.
- **No ar**: https://central-campanhas-ten.vercel.app (deploy automático a cada push no branch `main` deste repo).
- **Banco**: projeto Supabase `gabrielsviotto's Project` (`https://mptpyvgigepvsmylnnqu.supabase.co`), tabela `campanhas`.
- **Origem dos dados**: planilha Google Sheets "Campanhas Julho" → script do Google Apps Script ("Sync Campanhas Sheets -> Supabase") → upsert na tabela `campanhas`, a cada 5 minutos automaticamente.

## Acesso

Login obrigatório (Supabase Auth, e-mail/senha). Autocadastro está desativado — para dar acesso a alguém:

1. Supabase → **Authentication → Users → Add user → Send invitation** (só pede o e-mail da pessoa).
2. A pessoa recebe o link, entra automaticamente (sem senha ainda).
3. Ela deve clicar em **"Definir senha"** (ao lado do botão "Sair", no topo do site) para conseguir logar de novo depois.

## Estrutura do painel

- Colunas: Filial, Regional, RE, Colaborador, Cargo, CPF, Pendente, Pago, Campanhas Pendentes — todas ordenáveis clicando no cabeçalho.
- Filtros de Status, Mês, Filial, Regional e Cargo: seleção múltipla (checkboxes), só aplicam ao clicar em **"Aplicar"**. Busca por nome/CPF/RE é ao vivo. **"Limpar filtros"** reseta tudo, incluindo a busca.
- Filtro de Campanha: abas de seleção única (estilo antigo), aplica na hora.
- Duas datas no topo do painel: quando a tela foi atualizada (lado do navegador) e quando os dados mudaram pela última vez no banco (`atualizado_em` mais recente).
- Botão "Baixar XLSX" exporta um `.xlsx` com o que está na tela (aba "Saldo por Colaborador" + aba "Detalhe Campanhas").

## Reconfigurar do zero (se precisar recriar o projeto Supabase)

1. Rode [`supabase-schema.sql`](supabase-schema.sql) no SQL Editor — cria a tabela `campanhas`, a política de RLS (só `authenticated` lê) e habilita o Realtime.
2. Em **Authentication → Providers**, deixe só *Email* habilitado e desative "Allow new users to sign up".
3. Em **Project Settings → API Keys**, copie a **Project URL** e a **anon/publishable key**, e cole nas constantes `SUPABASE_URL`/`SUPABASE_ANON_KEY` no topo do `<script>` do `index.html`.
4. Configure a sincronização da planilha (veja abaixo).

## Sincronização da planilha (Google Apps Script)

O script vive dentro do Google Apps Script, associado à planilha via `SPREADSHEET_ID` (não é um script "container-bound"). Ele:

- Lê a aba `Página1` da planilha, casando pelos cabeçalhos: `Filial, Regional, RE, Nome, Cargo, CPF, Status Filial, Status Colaborador, Premiação, Mês, Descrição Campanha, Status Premiação`.
- **Consolida campanhas semanais**: se o mesmo CPF + campanha + mês aparecer em várias linhas (ex.: lançamento semanal), soma os valores de premiação numa única linha e só marca "Pago" se **todas** as ocorrências já estiverem pagas.
- Faz upsert na tabela `campanhas` usando a `service_role key` **legada** (formato JWT, começa com `eyJ`) — a chave nova (`sb_secret_...`) é bloqueada pela própria Supabase para chamadas fora do SDK oficial deles ("Forbidden use of secret API key in browser").
- Roda sozinho a cada 5 minutos (gatilho criado por `configurarGatilho()`), e também pode ser disparado manualmente (`syncToSupabase()`).
- A chave fica em **Configurações do projeto → Propriedades do script**, propriedade `SUPABASE_SECRET_KEY` (nunca no código-fonte).

## Observações

- `Arquivos_Teste/` (planilhas reais de exemplo) e `.claude/` ficam fora do controle de versão (`.gitignore`).
- Sem controle de acesso por linha: qualquer usuário autenticado vê todos os dados da tabela `campanhas` (não há RLS por filial/regional).
