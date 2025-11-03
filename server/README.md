# Server: PocketBase (development)

This folder contains a local PocketBase binary and a small helper script to start it for development.

Quick start (Windows PowerShell):

1. Open PowerShell and change directory to the pocketbase folder:

   cd server\pocketbase

2. Run the helper script:

   .\start-pocketbase.ps1

   The script will create a `pb_data/` directory (if missing) and start PocketBase on http://localhost:8090.

Direct command (no script):

  .\pocketbase.exe serve --dir .\pb_data

Notes:
- Android emulator (default AVD) should use http://10.0.2.2:8090 to reach PocketBase running on the host machine.
- If PocketBase cannot bind to 8090 or is blocked, check Windows Firewall or another process using that port.
- `pb_data/` stores the runtime DB and uploaded files — it is gitignored by default to avoid committing runtime data.
- For reproducible setups or CI, consider using Docker with the official PocketBase image.

If you want, I can also add a Docker Compose example or create a small script to open the admin page after start. 
