## Introduction
Stuff Sharing: The system allows people to borrow or lend stuff that they own (tools, appliances, furniture or books) either free or for a fee. Users advertise stuff available (what stuff, where to pick up and return, when it is available, etc.) or can browse the available stuff and bid to borrow some stuff. The stuff owner or the system (your choice) chooses the successful bid. Each user has an account. Administrators can create, modify and delete all entries.

## Demo
https://stuffshare.herokuapp.com

## Stack Used

Bitnami:
https://bitnami.com/tag/postgresql
- Frontend: HTML/CSS/JS
- Backend: PHP
- DB: Postgres

## Getting Started

1. Browse to directory: `/apache2/htdocs/`.
2. Run `git clone https://github.com/CS2102-T11/stuffshare.git` in the `/htdocs` directory. The `stuffshare` folder should be present in the directory.
3. Launch Bitnami Stack Manager and start both Apache Web Server and Postgres.
4. Browse to this URL: `localhost:<your-port-number>/stuffshare`. Replace `<your-port-number>` with the port number you start your Apache Web Server. You can find that out by clicking `Configure` for the Apache Web Server in your Bitnami Stack Manager.
5. Login to your postgres server with the credentials you entered during installation. Click `SQL` on the top left corner. Copy all the contents from `schema.sql` and paste it into the window and click `Execute`. This will create the neccessary tables for this website.
5. You can now access this website via this URL: `localhost:<your-port-number>/stuffshare`.

## Deploying to Heroku
1. Register for a Heroku account and install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
2. Login to heroku: `heroku login`
3. Create heroku project: `heroku create`
4. Go to your Heroku Dashboard and add Heroku Postgres under `Add-ons`
5. Connection settings to Heroku Postgres are located in `config.php`
6. Upload database records: `heroku pg:psql --app YOUR_APP_NAME_HERE < backup.sql`
7. Deploy app: `git push heroku master`

## Contributors
- Marlene Koh 
- Zachary Tang 
- Eldric Lim 
- Chan Jian Hui 
