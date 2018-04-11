Table of Contents
=================
- [CentOS Linux Server OS Preparation](#centos-linux-server-os-preparation)
- [Environment](#environment)
- [Warning](#warning)
- [Configuration](#configuration)
- [Easy Installation](#easy-installation)
- [Advanced Installation](#advanced-installation)
- [Customize your own function](#customize-your-own-function)
  * [Folder](#folder)
  * [Predefined variables](#predefined-variables)
- [Note](#note)
  * [Installed Packages](#installed-packages)
  * [Nginx related](#nginx-related)
  * [Folder privilege](#folder-privilege)
  * [Ruby gem config](#ruby-gem-config)
  * [Database configuration for production](#database-configuration-for-production)
- [CHANGELOG](#changelog)

# CentOS Linux Server OS Preparation
You want initialize your linux server by your own script.  But you **DO NOT** want to use **PUPPET , CHEF**.  You can just leverage my initialization project here.

This is a small light bash project.  Suit small companies which have only few servers to maintain.  **GIVE IT A TRY!!**

  (centos 7 server environment settings)

* This is useful if you have less than 5 CentOS7 servers to maintain.

# Environment
  * CentOS 7

# Warning
  * Please do this in fresh install OS
  * What does this not cover, DO the following manually
    * Login user
      * Change password of root
      * Add GENERAL USER and setup password of GENERAL USER
    * /etc/ssh/sshd_config
      * PermitRootLogin no
      * PasswordAuthentication yes
    * RAM
      * mkswap if Ram is insufficient to start MariaDB

      ```bash
      mkdir /swap
      dd if=/dev/zero of=/swap/swapfile bs=1M count=2048
      mkswap /swap/swapfile
      chmod 0600 /swap/swapfile
      /sbin/swapon /swap/swapfile
      ```

      ```bash
      chmod 755 /etc/rc.d/rc.local
      echo "/sbin/swapon /swap/swapfile" >> /etc/rc.d/rc.local
      ```

# Configuration
  * Before installation

    ```bash
    yum clean all
    yum install -y git
    git clone https://github.com/charlietag/os_preparation.git
    ```

  * Make sure config files exists , you can copy from sample to **modify**.

    ```bash
    cd databag
    ls |xargs -i bash -c "cp {} \$(echo {}|sed 's/\.sample//g')"
    ```

  * Verify **modified** config files.

    ```bash
    cd databag

    echo ; \
    ls *.cfg | xargs -i bash -c " \
    echo ---------------------------; \
    echo {}; \
    echo ---------------------------; \
    cat {} | grep -v '#' |sed '/^\s*$/d'; \
    echo "
    ```

  * Config files copied as follow

    ```bash
    databag/
    ├── F_00_environment.cfg
    ├── F_01_install_mariadb.cfg
    ├── F_05_setup_nginx.cfg
    └── F_09_toggle_service.cfg
    ...
    ```

# Easy Installation
I'm a lazy person.  I want to install **ALL** and give me default configurations running **Nginx, MariaDB, php-fpm, passenger**.  And help me to create default projects about "Rails" and "Laravel"

* Command

  ```bash
  ./start -a
  reboot
  ```

* Default project path

  ```bash
  /home/myrails/
  /home/mylaravel/
  ```

* Config your own hosts file (/etc/hosts)

  ```bash
  <192.168.x.x> myrails.centos7.localdomain
  <192.168.x.x> mylaravel.centos7.localdomain
  ```

* Browse URL

  ```bash
  http://myrails.centos7.localdomain
  http://mylaravel.centos7.localdomain
  ```

# Advanced Installation
I want to choose specific part to install.
* Command

  ```bash
  ./start.sh -h
  usage: start.sh
    -a                   ,  run all functions
    -i func1 func2 func3 ,  run specified functions
  ```

# Customize your own function
## Folder
  * functions/*
    * Write your own script here, **file** named start with **F_[0-9][0-9]_YourOwnFuntionName.sh**
    * Run command 
    
      ```bash
      ./start.sh -i YourOwnFuntionName
      ```

  * templates/*
    * Put your own templates here, **folder** named the same as **YourOwnFuntionName**
  * databag/*
    * Put your special config variables here, **file** named the same as **YourOwnFuntionName**
    * How to use
      * In databag/YourOwnFunctionName
        * local your_vars_here
      * In templates/YourOwnFunctionName/yourowntemplate_file
        * You can use ${your_vars_here}
      * In **YourOwnFuntionName** , you can call

        ```bash
        RENDER_CP ${$CONFIG_FOLDER}/yourowntemplate_file /SomeWhere/somewhere
        ```

        instead of
        
        ```bash
        cp ${$CONFIG_FOLDER}/yourowntemplate_file /SomeWhere/somewhere
        ```

      * In **YourOwnFuntionName** , you just want to **LOAD VARIABLES ONLY** from databag, try add a comment into your function script

        ```bash
        # For Load Variables Only Usage, add the following single comment line with keyword RENDER_CP
        # RENDER_CP
        ```


## Predefined variables

```bash
CURRENT_SCRIPT : /<PATH>/os_preparation/start.sh
CURRENT_FOLDER : /<PATH>/os_preparation

TMP            : /<PATH>/os_preparation/tmp
CONFIG_FOLDER  : /<PATH>/os_preparation/templates/<FUNCTION_NAME>
```

# Note

## Installed Packages
  * PHP7.1 (Ref. https://webtatic.com/packages)
  * PHP-FPM (Ref. https://webtatic.com/packages)
  * Laravel 5.6 (Ref. https://laravel.com/)
  * MariaDB 10.2 (equal to MySQL 5.7)
  * nodejs (stable version - 8)
  * Nginx (latest version - via passenger)
  * Ruby 2.5.1
  * Rails 5.2

## Nginx related
  * To be distinguish between "passenger-install-nginx-module", "yum install nginx (nginx yum repo)"
  * There are some differences here.
    * Nginx config folder

      ```
      /opt/nginx/
      ```

    * Running user
    
      ```
      optnginx
      optpass
      ```

    * Start process (**optnginx**)
    
      ```
      systemctl start optnginx
      ```

    * Config folder tree

      ```
      F_05_setup_nginx/
      ├── etc
      │   └── logrotate.d
      │       └── optnginx
      ├── opt
      │   └── nginx
      │       └── conf
      │           ├── conf.d
      │           │   ├── default.conf
      │           │   ├── laravel.conf
      │           │   └── rails.conf
      │           ├── default.d
      │           ├── nginx.conf
      │           └── passenger.conf
      └── usr
          └── lib
              ├── systemd
              │   └── system
              │       └── optnginx.service
              └── tmpfiles.d
                  └── passenger.conf

      12 directories, 8 files

      ```
    
## Folder privilege
After this installation repo, the server will setup with "passenger-install-nginx-module" , "Nginx + PHP-FPM" , so your RoR, Laravel, can run on the same server.  The following is something you have to keep an eye on it.

1. **folder privilege**

  * Rails Project
    
    ```bash
    rails new <rails_project> -d mysql
    cd <rails_project>
    chown -R optpass.optpass log tmp
    ```

  * Laravel Project
    
    ```bash
    composer create-project --prefer-dist laravel/laravel <laravel_project>
    cd <laravel_project>
    chown -R apache.apache storage
    chown -R apache.apache bootstrap/cache
    ```

2. **Command**

  * Rails

    ```bash
    rails new <rails_project> -d mysql
    ```

  * Rails 5.1 has dropped dependency on jQuery, you might want it back via yarn

    1. Add npm of jquery using Yarn

        ```bash
        cd <rails_project>
        yarn add jquery
        ```

    2. Setup jquery npm for asset pipeline

        ```bash
        vi <rails_project>/app/assets/javascripts/application.js
        ```

        ```bash
        //= require rails-ujs
        //= require turbolinks
        //= require jquery/dist/jquery
        //= require bootstrap/dist/js/bootstrap
        //= require_tree .
        ```

    3. Yarn works with rails 5.1 asset pipeline as below
      * Usage for default path:  <rails_project>/node_modules/{pkg_name}/dist/{pkgname}.{js,css}

        ```bash
        //= require jquery
        ```

      * If package is different from this rule, ex: bootstrap.  You might specify explicitly **(better)**

        ```bash
        //= require jquery
        ```

        ```bash
        //= require jquery/dist/jquery
        //= require bootstrap/dist/js/bootstrap
        ```



  * Laravel

    ```bash
    composer create-project --prefer-dist laravel/laravel <laravel_project>
    ```

## Ruby gem config
* gem install without making document
  * Deprecated

    ~~`no-ri, no-rdoc`~~

  * Config

    ```bash
    echo "gem: --no-document" > ~/.gemrc
    ```

## Database configuration for production
* Remove test database and setup root password
(After doing this, still need some tweak, try to manage database with https://www.adminer.org/ )

  ```bash
  mysql_secure_installation
  ```

* Database tools - Adminer
  * Easy to manage database
    * [adminer.php](https://www.adminer.org/)
  * **Stronger than scaffold, and any other admin panel. For quick CRUD**
    * [Adminer-editor.php](https://www.adminer.org/en/editor/)

# CHANGELOG
* 2017/03/02
  * Add Nginx req limit to avoid DDOS.
* 2017/05/25
  * Update MariaDB to 10.2
* 2017/05/26
  * Due to compatibility issue of ruby gem mysql2 - 0.4.6
  * Change default version of MariaDB to 10.1
  * Move MariaDB YUM baseurl to databag config file for easy install configuration
* 2017/07/29
  * For Rails 5.1 support.  Install yarn for default npm packages management
* 2017/09/15
  * Add bash prompt for git detail information into bashrc (Some symbol format might not fit on all terminals)
* 2018/01/07
  * Laravel 5.3
  * MariaDB 10.1
  * Update NodeJS from 6 to 8
* 2018/03/22
  * Laravel 5.6
  * MariaDB 10.2
  * Ruby 2.5.0
* 2018/04/11
  * Ruby 2.5.1
  * Ruby on Rails 5.2
