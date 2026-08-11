# Central de Campanhas

Código HTML para gerar a planilha de pagamentos.

App estático (`index.html`) para importar planilhas de apuração de campanhas e acompanhar o saldo pendente/pago por colaborador. Dados e histórico de importação ficam no Supabase; a página é hospedada no Vercel.

## 1. Configurar o Supabase

No seu projeto Supabase, abra **SQL Editor** e rode o conteúdo de [`supabase-schema.sql`](supabase-schema.sql). Isso cria a tabela `app_state` (guarda todos os registros e o histórico de importação em uma única linha JSON) e libera leitura/escrita para a chave pública (`anon`).

Em **Project Settings → API**, copie:
- **Project URL**
- **anon public key**

## 2. Preencher as credenciais no `index.html`

Abra `index.html` e edite as duas constantes no início do `<script>` principal:

```js
const SUPABASE_URL = "https://SEU-PROJETO.supabase.co";
const SUPABASE_ANON_KEY = "SUA_ANON_KEY_AQUI";
```

## 3. Deploy no Vercel

Como é um site 100% estático (sem build, sem backend próprio), basta:

```bash
npx vercel --prod
```

rodando na pasta do projeto, ou conectar o repositório pelo painel do Vercel e usar o preset **Other** (sem comando de build, diretório de saída = raiz). O Vercel serve o `index.html` diretamente.

## 4. Uso

Igual ao original: arraste planilhas `.xlsx`/`.csv`, importe de uma aba do Google Sheets (pública ou colando os dados), acompanhe o saldo por colaborador e exporte um `.xlsx` consolidado. Todo o estado (registros + histórico de importações) fica salvo em uma única linha da tabela `app_state` no Supabase.

## Observações

- **Sem controle de acesso**: a página não tem login. Qualquer pessoa com a URL (e a anon key, que fica visível no código-fonte) consegue ler e alterar os dados — incluindo CPF e valores de premiação. Se isso for um problema, dá para adicionar depois uma proteção (Supabase Auth, senha do Vercel, etc.).
- **Estado em blob único**: como tudo fica em uma única linha JSON, duas pessoas importando planilhas ao mesmo tempo podem sobrescrever uma a outra (last write wins).
