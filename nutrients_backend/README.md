# Laravel full stack environment

This environment is for full-stack development of a PHP/Laravel application. It consists of:
- application server (nginx)
- database server (MySQL)
- graphical user interface for working with database (PHPMyAdmin)
- PHP compiler (PHP 8), including composer
- PHP package manager (Composer)
- node.js and node package manager (NPM)
- Laravel CLI (artisan)

# TL;DR: Invoking containers (after installing and deploying environments)
In development of Laravel application, you will frequently need to call composer, npm and artisan. Use following code.
```
    docker-compose run --rm php composer ...
    docker-compose run --rm npm ...
    docker-compose run --rm artisan ...
```

Replace the dots with the command you wish to call. For example:
```
    docker-compose run --rm php composer install # installs PHP packages
    docker-compose run --rm npm install # installs node.js/javascript packages
    docker-compose run --rm artisan migrate # run migration scripts for database modifications
```

# Pre-installation steps
These instructions are written for a Debian-based Linux distribution or Windows/WSL2, such as Debian or Ubuntu.

**Important:** If this is your first time using git, you need to disable certificate verification. You will only need to do it once. In the Linux terminal, enter:
```
    git config --global http.sslverify false
```
You will also need to generate Gitlab keys.

It is highly recommended to keep all your projects in a dedicated directory. For the purposes of these instructions, we assume the directory is `~/projects`.

Navigate to the dedicated directory, i.e. `cd ~/projects`.

Also, keep in mind that you should never keep a default subdirectory `~/projects/environment-laravel-full-stack`. Whenever you will clone this repository, it will be cloned into `~/projects/environment-laravel-full-stack`. In case you will have a `~/projects/environment-laravel-full-stack` directory
before cloning this repository, your existing `~/projects/environment-laravel-full-stack` directory will be overwritten and you may loose important work!

# Setting up the environemnt
This section describes how you clone this repository to your local machine and set up an environment.

## Cloning this repository to your local machine
Navigate to `~/projects` and clone this repository.
```
    git clone https://gitlab.lan.kclj.si/43262/environment-laravel-full-stack.git
```

Rename `~/projects/environment-laravel-full-stack` directory to something describing your project. In these instructions, we assume that the name of your project is `my-app`.
```
    mv ~/projects/environment-laravel-full-stack ~/projects/my-app
```
## Preparing environment file
Now, you need to copy or move the default `env.env` file to an `.env` file. The .env file is used by Docker to properly set up your environment, without you having the need to modify a more complicated `docker-compose.yml` file.

Navigate to your project environemnt directory and rename `env.env` file `.env`.
```
    cd ~/projects/my-app
    mv env.env .env
```

Now, you need to configure your environment settings.

## Configuring environment for your project
First, open Visual Studio Code. While being in  `~/projects/my-app`, simply type:
```
    code .
```

In Visual Studio Code, open file `.env` and configure the following tags:
- `APP_NAME`
- `APP_PORT`
- `PHPMYADMIN_PORT`
- `DB_PORT`
- `PHP_PORT`
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `NETWORK`
- `MYSQL_PASSWORD`
- `MYSQL_ROOT_PASSWORD`

`APP_NAME` is a short project/application name. In this example, we choose `my-app`.

`APP_PORT` is a port at which your application will be accessible from your local machine. After spinning up the environment, you will be able to access your app through browser on that port. For example, if you set `APP_PORT=9010`, your app will be reachable at `http://localhost:9010`.

`PHPMYADMIN_PORT` is a port at which the PHPMyAdmin application wil be accessible from your local machine. PHPMyAdmin is a great tool to easily work with your database through a graphic user interface. After spinning up the environment, you will be able to access PHPMyAdmin through browser on that port. For example, if you set `PHPMYADMIN_PORT=9011`, your app will be reachable at `http://localhost:9011`.

`DB_PORT` is a port at which the database server application will be accessible from your local machine. Since you have PHPMyAdmin, you will normally not need to directly connect to the database. However, if you ever required such direct connection, the database would be reachable on that port.

`PHP_PORT` is a port at which the PHP compiler will be accessible from your local machine. In practice, you will never require to connect directly to that service.

`MYSQL_DATABASE` is the name of the database. We recommend you choose the same name as of the app. In our example, we would choose `my-app`.

`MYSQL_USER` is database username. From your application, you will connect to the database with this username. We recommend you choose the same name as of the app. In our example, we would choose `my-app`.

`NETWORK` is internal Docker environment network name. We recommend you choose the same name as of the app. In our example, we would choose `my-app`. IMPORTANT: In a later step, you will also need to enter that name directly into the `docker-compose.yml` file.

`MYSQL_PASSWORD` is the password of the database user. From your application, you will connect to the database with this password.

`MYSQL_ROOT_PASSWORD` is the root database user password. In your local environment, it can be the same as `MYSQL_PASSWORD`. You will rarely need to connect to your database using root credentials.

Save your `.env` file and proceed to the next step.

## Setting up Docker Compose file
Open `docker-compose.yml` and change the name of the network which you have set up in the `.env` file previously. If your network name is `my-app`, you need to find the `networks` field and set a new network name.

```
version: '3.7'

networks:
    template:

volumes:
    db:

services:
...
```

into
```
version: '3.7'

networks:
    my-app:

volumes:
    db:

services:
...
```

## Spin up environment
To run all the containers and make environment available, run:
```
    docker-compose up -d
```
Note: running containers for the first time may take some time, as images need to be built.

## Post installation steps
After running up the environment, the services will be available through browser at respective ports.
- application: http://localhost:${APP_PORT}
- PHPMyAdmin: http://localhost:${PHPMYADMIN_PORT}

Furthermore, a `./src` directory will be created. Use this directory for development.

All the files created by Composer, NPM and Artisan containers inside `./src` will be owned by root. You need to change the ownership. You will often need to run the following command:
```
    sudo chown -R $USER:$USER ./src
```

You will find further insctructions for setting up Laravel application on [Nov Laravel projekt v Dockerju](https://gitlab.lan.kclj.si/-/snippets/1).
