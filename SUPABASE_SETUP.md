# Shared poll results setup

The page uses Supabase to store shared vote totals. The SQL creates the table and an atomic vote-submission function.

1. Create a Supabase project.
2. In the Supabase SQL Editor, run `supabase.sql`.
3. Copy the project URL and the public publishable key (or legacy anon key) into `supabase-config.js`.
4. Serve the page over HTTP or HTTPS. A `file://` URL cannot reliably call the Supabase API.

The public key is intended for browser use; never put a `service_role` key in this project. Row-level security lets visitors read totals and submit votes only through the validated database function.

The browser remembers that it has voted using local storage. This prevents repeat voting in the same browser profile, but is not a strong identity or abuse-prevention mechanism. The poll starts with zero database votes; local-only totals from the old version are not imported.
