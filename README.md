aktagon-snippets
================

[Host your own snippets](http://snippets.aktagon.com).

Requirements
================

 * Ruby
 * Unicorn (production)

Installation
================

Clone repo:

    $ git clone https://github.com/christianhellsten/aktagon-snippets.git
    
Install Ruby gems:

    $ cd aktagon-snippets
    $ bundle
    

Create .development.env:

    SESSION_SECRET=<Generated with SecureRandom.hex(128)>
    DISQUS_SHORTNAME=<Your Disqus short name>

Create database:

    $ mysql -u root -e "create database mysql_development;"
    
Create config/database.yml:

    development:
      adapter:  mysql2
      database: snippets_development
      username: xyz
      password: xyz
      encoding: utf8

Run database migrations:

    $ rake db:migrate
    
Start server:

    $ thin start

Production Deployment
================

Create .deployment.env:

    DEPLOY_DOMAIN=xyz.com
    DEPLOY_SSH_PORT=22
    DEPLOY_GIT_REPO=https://github.com/christianhellsten/aktagon-snippets.git
    DEPLOY_DIRECTORY=/var/www/snippets
    
Setup directories

    $ mina setup
    
Create /var/www/snippets/shared/.production.env:

    SESSION_SECRET=<Generated with SecureRandom.hex(128)>
    DISQUS_SHORTNAME=<Your Disqus short name>
    GA_ID=<Google Analytics ID>
    GA_HOST=<Domain, e.g. aktagon.com>

Create /var/www/snippets/shared/config/database.yml:

    production:
      adapter:  mysql2
      database: snippets_production
      username: xyz
      password: xyz
      encoding: utf8

Add all users to db/migrate/003_users.rb.

Deploy

    $ mina deploy
