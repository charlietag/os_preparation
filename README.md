# CentOS Linux Server OS Preparation
You can initialize your linux server by your own script. Or just leverage my centos 7 server environment settings here.

## Environment
  * CentOS 7

## Warning
  * Please do this in fresh install OS

## Usage

  ```bash
  yum install -y git
  git clone https://github.com/charlietag/os_preparation.git
  ```

  ```bash
  ./start.sh -h
  usage: start.sh
    -a                   ,  run all functions
    -i func1 func2 func3 ,  run specified functions
  ```

## Full Installation
I'm a lazy person.  I want to install all and give me default configurations running **Nginx, MariaDB, php-fpm, passenger**.  And help me to create default projects about "Rails" and "Laravel"

* Full install command

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
  <192.168.x.x> myrails.xxx.com
  <192.168.x.x> mylaravel.xxx.com
  ```

* Browse URL

  ```bash
  http://myrails.xxx.com
  http://mylaravel.xxx.com
  ```

## Customize your own function
### Folder
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

### Predefined variables

```bash
CURRENT_SCRIPT : /<PATH>/os_preparation/start.sh
CURRENT_FOLDER : /<PATH>/os_preparation

TMP            : /<PATH>/os_preparation/tmp
CONFIG_FOLDER  : /<PATH>/os_preparation/templates/<FUNCTION_NAME>
```

## Note

### Installed Packages
  * PHP7 (Ref.https://webtatic.com/packages/php70)
  * PHP-FPM (Ref.https://webtatic.com/packages/php70)
  * MariaDB 10.1 (equal to MySQL 5.7)
  * nodejs (latest version - 6)
  * Nginx (latest version - via passenger)

### Nginx related
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
    
### Folder privilege
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

  ```bash
  rails new <rails_project> -d mysql
  ```

  ```bash
  composer create-project --prefer-dist laravel/laravel <laravel_project>
  ```

### Ruby gem config
* gem install without making document
  * Deprecated

    ~~`no-ri, no-rdoc`~~

  * Config

    ```bash
    echo "gem: --no-document" > ~/.gemrc
    ```

### Databasse configuration for Production
* Remove test database and setup root password
(After doing this, still need some tweak, try to manage database with https://www.adminer.org/ )

```bash
mysql_secure_installation
```

