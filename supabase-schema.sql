-- Central de Campanhas — schema Supabase
-- Execute este script no SQL Editor do seu projeto Supabase.
--
-- Este app NÃO importa planilhas: ele só LÊ esta tabela. Outro processo
-- (ou você, direto pelo Table Editor do Supabase) é quem insere/atualiza os
-- dados aqui. Assim que uma linha muda, o Realtime avisa o app e a tela
-- atualiza sozinha, sem precisar recarregar a página.

create table if not exists campanhas (
  cpf text not null,
  nome text,
  cargo text,
  filial text,
  regional text,
  re text,
  status_filial text,
  status_colaborador text,
  campanha text not null,
  mes text not null,
  premiacao numeric not null default 0,
  status_premiacao text not null default 'Pendente',
  atualizado_em timestamptz not null default now(),
  primary key (cpf, campanha, mes)
);

-- Mantém atualizado_em correto automaticamente a cada UPDATE.
create or replace function set_atualizado_em()
returns trigger as $$
begin
  new.atualizado_em = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_campanhas_atualizado_em on campanhas;
create trigger trg_campanhas_atualizado_em
before update on campanhas
for each row execute function set_atualizado_em();

-- RLS: só usuários autenticados (login feito pela tela do app) podem ler.
-- Não há política de insert/update/delete para anon/authenticated — quem
-- alimenta a tabela usa a service_role key (que ignora RLS) ou o próprio
-- Table Editor do Supabase.
alter table campanhas enable row level security;

drop policy if exists "authenticated can read campanhas" on campanhas;
create policy "authenticated can read campanhas"
on campanhas for select
to authenticated
using (true);

-- Habilita o Realtime (replicação de mudanças) para esta tabela.
alter publication supabase_realtime add table campanhas;
