## Introduction
Stuff Sharing: The system allows people to borrow or lend stuff that they own (tools, appliances, furniture or books) either free or for a fee. Users advertise stuff available (what stuff, where to pick up and return, when it is available, etc.) or can browse the available stuff and bid to borrow some stuff. The stuff owner or the system (your choice) chooses the successful bid. Each user has an account. Administrators can create, modify and delete all entries.

## Stack Used

Bitnami:
https://bitnami.com/tag/postgresql


## Getting Started

1. Browse to directory: `/apache2/htdocs/`.
2. Pull the code from this repo (stuffshare) into the `/htdocs` directory. The `stuffshare` folder should be present in the directory.
3. Launch Bitnami Stack Manager and start both Apache Web Server and Postgres.
4. Browse to this URL: `localhost:<your-port-number>/stuffshare`. Replace `<your-port-number>` with the port number you start your Apache Web Server. You can find that out by clicking `Configure` for the Apache Web Server in your Bitnami Stack Manager.
5. Login to your postgres server with the credentials you entered during installation. Click `SQL` on the top left corner. Copy all the contents from `schema.sql` and paste it into the window and click `Execute`. This will create the neccessary tables for this website.
5. You can now access this website via this URL: `localhost:<your-port-number>/stuffshare`.

## Contributors
- Marlene Koh 
- Zachary Tang 
- Eldric Lim 
- Chan Jian Hui 
