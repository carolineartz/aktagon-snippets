aktagon-snippets
================

Host your own snippets.

Source code for "snippets.aktagon.com":http://snippets.aktagon.com.

Requirements
================

 * Ruby
 * Unicorn (production)

Installation
================

    $ git clone https://github.com/christianhellsten/aktagon-snippets.git
    $ bundle
    $ mysql -u root -e "create database mysql_development;"
    $ rake db:migrate
    $ thin start
    
Production deployment
================

Create .production.env:

    SESSION_SECRET=<Generate one with SecureRandom.hex(128)>
    DISQUS_SHORTNAME=<Your Disqus short name>
    GA_ID=<Google Analytics ID>
    GA_HOST=<Domain, e.g. aktagon.com>

Create .deployment.env:

    DEPLOY_DOMAIN=xyz.com
    DEPLOY_SSH_PORT=22
    DEPLOY_GIT_REPO=/var/git/repositories/snippets.git
    DEPLOY_DIRECTORY=/var/www/snippets

Deploy

    $ mina setup
    $ mina deploy
