create table if not exists public.poll_votes (
  poll_option text primary key check (poll_option in ('TUV Nord', 'TUV Rheinland', 'TUV Sud')),
  vote_count bigint not null default 0 check (vote_count >= 0)
);

insert into public.poll_votes (poll_option)
values ('TUV Nord'), ('TUV Rheinland'), ('TUV Sud')
on conflict (poll_option) do nothing;

alter table public.poll_votes enable row level security;

drop policy if exists "Anyone can read poll totals" on public.poll_votes;
create policy "Anyone can read poll totals"
  on public.poll_votes
  for select
  to anon, authenticated
  using (true);

revoke all on table public.poll_votes from anon, authenticated;
grant select on table public.poll_votes to anon, authenticated;

create or replace function public.submit_poll_vote(p_option text)
returns table (poll_option text, vote_count bigint)
language plpgsql
security definer
set search_path = ''
as $function$
begin
  if p_option is null or p_option not in ('TUV Nord', 'TUV Rheinland', 'TUV Sud') then
    raise exception using message = 'Invalid poll option';
  end if;

  update public.poll_votes as pv
  set vote_count = pv.vote_count + 1
  where pv.poll_option = p_option;

  return query
  select pv.poll_option, pv.vote_count
  from public.poll_votes as pv
  order by pv.poll_option;
end;
$function$;

revoke all on function public.submit_poll_vote(text) from public, anon, authenticated;
grant execute on function public.submit_poll_vote(text) to anon, authenticated;
