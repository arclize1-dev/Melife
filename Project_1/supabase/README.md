# Supabase setup

The app connects directly to the configured Supabase project using its URL and a publishable key. The publishable key is intended for browser use; never place a secret/service-role key in `index.html`, client-side storage, or a public repository. If a secret key has been shared or exposed, rotate it in Supabase.

## Database

Run `schema.sql` in the Supabase SQL Editor. It creates `calendar_events` and `expenses`, grants table access to authenticated users, and enables row-level security so each user can only access rows with their own `user_id`. Re-run it after app updates; it includes safe `add column if not exists` migrations such as `expenses.skipped_dates` for deleting one recurring occurrence without deleting the series.

## Authentication

The app supports email/password sign-in and account creation through Supabase Auth. Configure the project's email confirmation and Auth URL settings in Supabase. For local testing, serve this folder from a local HTTP server and add that origin to the allowed redirect URLs; avoid relying on `file://` for email-confirmation redirects.

The sign-in panel's **ลืมรหัสผ่าน?** action sends a Supabase password recovery email. Add the exact local or deployed HTTP(S) URL to Supabase Auth's allowed redirect URLs. The recovery link returns to the app, where the user can set and confirm a new password (minimum six characters). Password recovery cannot be requested from a `file://` URL. Email delivery and recovery-link expiry are controlled by Supabase Auth.

After signing in:

- Existing browser-local data is imported if the corresponding Supabase table is empty and the local cache is not owned by another signed-in account.
- If Supabase already contains rows, those rows become the active data and refresh the browser cache.
- Changes are saved to the local cache and synchronized to Supabase. Sync failures appear in the account bar with a retry button.

The app never needs the secret/service-role key. Keep it server-side only; this standalone frontend uses RLS and the signed-in user's session.
