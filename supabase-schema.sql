-- Central de Campanhas — schema Supabase
-- Execute este script no SQL Editor do seu projeto Supabase.

create table if not exists app_state (
  id int primary key default 1,
  data jsonb not null default '{"records":{},"log":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Garante que só existe (e sempre existirá) a linha id=1.
insert into app_state (id, data)
values (1, '{"records":{},"log":[]}'::jsonb)
on conflict (id) do nothing;

alter table app_state enable row level security;

-- Sem tela de login no app: a chave usada no navegador é a "anon key",
-- então as políticas abaixo liberam leitura/escrita para o papel "anon".
-- Isso significa que qualquer pessoa com a URL da página (e a anon key,
-- que fica visível no código-fonte) pode ler e alterar os dados. Se isso
-- não for aceitável dado que a planilha tem CPF e valores de premiação,
-- vale reconsiderar algum controle de acesso mais adiante.
drop policy if exists "anon can read app_state" on app_state;
create policy "anon can read app_state"
on app_state for select
to anon
using (true);

drop policy if exists "anon can insert app_state" on app_state;
create policy "anon can insert app_state"
on app_state for insert
to anon
with check (true);

drop policy if exists "anon can update app_state" on app_state;
create policy "anon can update app_state"
on app_state for update
to anon
using (true)
with check (true);
