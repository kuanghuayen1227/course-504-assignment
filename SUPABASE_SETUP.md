# Shared poll results setup

The page uses Supabase to store shared vote totals. The SQL creates the table and an atomic vote-submission function.

1. Create a Supabase project.
2. In the Supabase SQL Editor, run `supabase.sql`.
3. Copy the project URL and the public publishable key (or legacy anon key) into `supabase-config.js`.
4. Serve the page over HTTP or HTTPS. A `file://` URL cannot reliably call the Supabase API.

The public key is intended for browser use; never put a `service_role` key in this project. Row-level security lets visitors read totals and submit votes only through the validated database function.

The form remains available after each successful vote. The chart updates immediately and refreshes every 15 seconds while the page is visible so other visitors' votes appear too. Anyone can submit repeatedly; this is not a one-person poll or an abuse-prevention mechanism. The poll starts with zero database votes; local-only totals from the old version are not imported.
