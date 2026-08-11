# Central de Campanhas

Código HTML para gerar a planilha de pagamentos.

App estático (`index.html`) para importar planilhas de apuração de campanhas e acompanhar o saldo pendente/pago por colaborador. Hospedado no Vercel: https://central-campanhas-ten.vercel.app

## Persistência

Por enquanto os dados ficam salvos no `localStorage` do navegador (por dispositivo/navegador, sem backend) — equivalente ao `window.storage` da versão original em artifact. Isso significa:

- Os dados só existem no navegador de quem importou a planilha; abrir a página em outro computador ou navegador não mostra os mesmos dados.
- Limpar o histórico/dados do navegador apaga os dados salvos.
- Para consolidar tudo em um só lugar (múltiplos usuários vendo os mesmos dados), a persistência pode ser trocada depois por um backend real (ex.: Supabase).

## Deploy no Vercel

Site 100% estático (sem build, sem backend). Qualquer push no branch `main` do repositório [`gabrielsviotto/central_campanhas`](https://github.com/gabrielsviotto/central_campanhas) já reflete automaticamente no deploy do Vercel.

## Uso

Arraste planilhas `.xlsx`/`.csv`, importe de uma aba do Google Sheets (pública ou colando os dados), acompanhe o saldo por colaborador e exporte um `.xlsx` consolidado.
