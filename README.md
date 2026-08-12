# Central de Campanhas

Código HTML para gerar a planilha de pagamentos.

Painel estático (`index.html`) que mostra o saldo pendente/pago por colaborador, lendo os dados direto do Supabase. Não há mais importação de planilha por aqui: outro processo (ou você, pelo Table Editor do Supabase) é quem alimenta a tabela. A tela atualiza sozinha via Supabase Realtime assim que os dados mudam. Hospedado no Vercel: https://central-campanhas-ten.vercel.app

## 1. Configurar o Supabase

1. No SQL Editor do seu projeto Supabase, rode [`supabase-schema.sql`](supabase-schema.sql). Isso cria a tabela `campanhas` (uma linha por CPF + campanha + mês), a política de RLS que só libera leitura para usuários autenticados, e habilita o Realtime nessa tabela.
2. Em **Authentication → Providers**, deixe só *Email* habilitado e **desative "Allow new users to sign up"** — os usuários são criados manualmente, não por autocadastro.
3. Em **Authentication → Users**, clique em **Invite user** para cada pessoa que vai acessar o painel.
4. Em **Project Settings → API**, copie a **Project URL** e a **anon public key**.

## 2. Preencher as credenciais no `index.html`

Edite as constantes no início do `<script>`:

```js
const SUPABASE_URL = "https://SEU-PROJETO.supabase.co";
const SUPABASE_ANON_KEY = "SUA_ANON_KEY_AQUI";
```

## 3. Alimentando os dados

Este app é **somente leitura**. Para os dados aparecerem no painel, insira/atualize linhas na tabela `campanhas` por fora dele — pelo Table Editor do Supabase, por um script, ou por qualquer outro processo que tenha acesso ao banco (idealmente usando a `service_role key`, que ignora as políticas de RLS). Colunas esperadas:

`cpf, nome, cargo, filial, regional, re, status_filial, status_colaborador, campanha, mes, premiacao, status_premiacao`

A chave primária é `(cpf, campanha, mes)` — inserir uma linha com essa combinação já existente deve ser feito como `update` (ou `upsert`) para atualizar o registro.

## 4. Deploy no Vercel

Site 100% estático (sem build, sem backend próprio). Qualquer push no branch `main` do repositório [`gabrielsviotto/central_campanhas`](https://github.com/gabrielsviotto/central_campanhas) já reflete automaticamente no deploy do Vercel.

## Uso

Login com a conta cadastrada, busque por nome/CPF/RE, filtre por status/mês/campanha (abas fixas no topo), expanda um colaborador para ver o detalhe por campanha, e exporte um `.xlsx` consolidado com o que está na tela.
