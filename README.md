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
  * [Folder privilege](#folder-privilege)
  * [Ruby gem config](#ruby-gem-config)
  * [Database configuration for production](#database-configuration-for-production)
  * [Extra functions](#extra-functions)
- [CHANGELOG](#changelog)

# CentOS Linux Server OS Preparation
You want initialize your linux server by your own script.  But you **DO NOT** want to use **PUPPET , CHEF , Ansible**.  You can just leverage my initialization project here.

This is a small light bash project.  Suit small companies which have only few servers to maintain.  **GIVE IT A TRY!!**

  (centos 7 server environment settings)

* This is useful when
  * You have less than 5 CentOS7 servers to maintain.
  * You are deploying monolithic architecture app.

* This repo is TOTALLY transfer from passenger to puma for rails.
  * **NGINX(official) + PUMA + PHP-FPM + MariaDB + Rails + Laravel + Redmine**

* If you prefer **passenger** + nginx (**passenger-install-nginx-module**)

  please switch to git tag named "before_passenger_to_puma"

  ```bash
  git clone --depth 1 --branch before_passenger_to_puma https://github.com/charlietag/os_preparation.git
  ```

# Environment
  * CentOS 7 (7.x)

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

  * Mostly used configuration :
    * **DEV** use (server in **Local** / server in **Cloud**) && **Production** use (server in **Local** / server in **Cloud**)

      ```bash
      databag/
      ├── F_01_ENV_02_os.cfg
      ├── F_01_ENV_04_ssh_config.cfg
      └── _gitconfig.cfg
      ```

  * PHP 7.0 for old project
    * Modify yum packages in script `functions/F_02_PKG_05_php_01_install_php7.sh`

      ```bash
      yum install -y php70w php70w-opcache php70w-fpm php70w-opcache php70w-mbstring php70w-mcrypt php70w-mysql php70w-pdo php70w-pdo_dblib php70w-gd php70w-common php70w-xml
      ```

  * Verify config files (with syntax color).

    ```bash
    cd databag

    echo ; \
    ls *.cfg | xargs -i bash -c " \
    echo -e '\e[0;33m'; \
    echo ---------------------------; \
    echo {}; \
    echo ---------------------------; \
    echo -n -e '\033[00m' ; \
    echo -n -e '\e[0;32m'; \
    cat {} | grep -vE '^\s*#' |sed '/^\s*$/d'; \
    echo -e '\033[00m' ; \
    echo "
    ```

  * Verify **ONLY modified** config files (with syntax color).

    ```bash
    cd databag

    echo ; \
    ls *.cfg | xargs -i bash -c " \
    echo -e '\e[0;33m'; \
    echo ---------------------------; \
    echo {}; \
    echo ---------------------------; \
    echo -n -e '\033[00m' ; \
    echo -n -e '\e[0;32m'; \
    cat {} | grep -v 'plugin_load_databag.sh' | grep -vE '^\s*#' |sed '/^\s*$/d'; \
    echo -e '\033[00m' ; \
    echo "
    ```

# Easy Installation
I'm a lazy person.  I want to install **ALL** and give me default configurations running **Nginx (official), MariaDB, php-fpm, puma (rails)**.  And help me to create default projects about "Rails" and "Laravel"

* Command

  ```bash
  ./start -a
  reboot
  ```

* Default project path
  * DEFAULT user for rails/laravel developer is not ssh allowed
    * /etc/ssh/sshd

      ```bash
      DenyGroups no-ssh-group
      ```

  * group "no-ssh-group" add to default dev user
    * phpuser (this name can be modified)
    * rubyuser (this name can be modified)

  * rails
    * default user: rubyuser (can be changed)

  ```bash
  /home/${current_user}/rails_sites/myrails/
  --->
  /home/rubyuser/rails_sites/myrails/
  ```

  * Redmine
    * default user: rubyuser (can be changed)

  ```bash
  /home/${current_user}/rails_sites/redmine/
  --->
  /home/rubyuser/rails_sites/redmine/
  ```

  * laravel
    * default user: phpuser (can be changed)

  ```bash
  /home/${current_user}/laravel_sites/myrails/
  --->
  /home/phpuser/laravel_sites/myrails/
  ```

* Config your own hosts file (/etc/hosts)

  ```bash
  <192.168.x.x> myrails.centos7.localdomain
  <192.168.x.x> redmine.centos7.localdomain
  <192.168.x.x> mylaravel.centos7.localdomain
  ```

* Browse URL

  ```bash
  http://myrails.centos7.localdomain
  http://redmine.centos7.localdomain (default account: admin/admin)
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
  * functions/
    * Write your own script here, **file** named start with **F_[0-9][0-9]_YourOwnFuntionName.sh**
    * Run command 
    
      ```bash
      ./start.sh -i YourOwnFuntionName
      ```

  * templates/
    * Put your own templates here, **folder** named the same as **YourOwnFuntionName**

  * databag/
    * Put your special config variables here, **file** named the same as **YourOwnFuntionName**
    * How to use
      * In databag/YourOwnFunctionName
        * local your_vars_here
      * In templates/YourOwnFunctionName/yourowntemplate_file
        * You can use ${your_vars_here}
      * In **YourOwnFuntionName** , you can call

        ```bash
        # Method : eval "echo \"$variable\""
        # Might have escape issue, if template is complicated
        RENDER_CP ${$CONFIG_FOLDER}/yourowntemplate_file /SomeWhere/somewhere
        ```

        ```bash
        # Method : cat template | sed 's/\{\{var\}\}/$var/g'
        # BETTER method for rendering template
        RENDER_CP_SED ${$CONFIG_FOLDER}/yourowntemplate_file /SomeWhere/somewhere
        ```


        instead of
        
        ```bash
        cp ${$CONFIG_FOLDER}/yourowntemplate_file /SomeWhere/somewhere
        ```

      * In **YourOwnFuntionName** , you just want to **LOAD VARIABLES ONLY** from databag, try add a comment into your function script

        ```bash
        # For Load Variables Only Usage, add the following single comment line with keyword DATABAG_CFG:enable
        # DATABAG_CFG:enable
        ```

  * helpers/
    * Write your own script here, **file** named start with **helper_YourOwnHelperName.sh**
    * Works with helpers_views

  * helpers_views/
    * Put your own templates for ONLY **helper USE** here, **folder** named the same as **YourOwnHelperName**

  * tasks/
    * Write your own script here, **file** named start with **task_YourOwnTaskName.sh** , **_task_YourOwnTaskName.sh**
    * Scripts here will automatically transfer to function, just like scripts under "functions/"
    * But this is for global use for os_preparation , os_security.  So it's been moved to os_preparation_lib

  * plugins/
    * Only scripts which can be called everywhere like, ${HELPERS}/plugins_scripts.sh
    * Use this as a script, not function

## Predefined variables

```bash
(root)# ./start.sh -i F_00_debug
==============================
        F_00_debug
==============================
-----------lib use only--------
CURRENT_SCRIPT : /root/os_preparation/start.sh
CURRENT_FOLDER : /root/os_preparation
FUNCTIONS      : /root/os_preparation/functions
LIB            : /root/os_preparation/../os_preparation_lib/lib
TEMPLATES      : /root/os_preparation/templates
TASKS          : /root/os_preparation/../os_preparation_lib/tasks
HELPERS        : /root/os_preparation/helpers
HELPERS_VIEWS  : /root/os_preparation/helpers_views

-----------lib use only - predefined vars--------
FIRST_ARGV     : -i
ALL_ARGVS      : F_00_debug

-----------function use only--------
PLUGINS            : /root/os_preparation/plugins
TMP                : /root/os_preparation/tmp
CONFIG_FOLDER      : /root/os_preparation/templates/F_00_debug
HELPER_VIEW_FOLDER : /root/os_preparation/helpers_views/helper_env_user_base
DATABAG            : /root/os_preparation/databag

-----------helper use only--------
HELPER_VIEW_FOLDER : /root/os_preparation/helpers_views/helper_env_user_base



================= Testing ===============
----------Helper Debug Use-------->>>
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
        helper_debug
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

----------Task Debug Use-------->>>
______________________________
        task_debug
______________________________
```

# Note

## Installed Packages
  * PHP7.2 (Ref. https://webtatic.com/packages)
  * PHP-FPM (Ref. https://webtatic.com/packages)
  * Laravel 6.0 (Ref. https://laravel.com/)
  * MariaDB 10.4 (equal to MySQL 5.7)
  * nodejs (stable version - 12)
  * Nginx (latest version - via Nginx Official Repo)
  * Ruby 2.6.3
  * Rails 6.0
    * puma (systemd, puma-mgr)
  * Redmine 4.0.5
    * ruby 2.6.3
    * rails 5.2
  * Docker
    * docker-ce
    * docker-compose
  * Useful tools
    * Enhanced tail
      * multitail
        * multitail /var/log/nginx/*.access.log
    * Enhanced grep
      * ack
        * ls | ack keyword
        * ack -i keyword *
          * default options (-r, -R, --recurse             Recurse into subdirectories (default: on))

## Folder privilege
After this installation repo, the server will setup with "Nginx + Puma (socket)" , "Nginx + PHP-FPM (socket)" , so your RoR, Laravel, can run on the same server.  The following is something you have to keep an eye on it.

1. **folder privilege**

  * Rails Project
    
    ```bash
    rails new <rails_project> -d mysql
    cd <rails_project>
    chown -R ${current_user}.${current_user} log tmp
    ```

  * Laravel Project
    
    ```bash
    composer create-project --prefer-dist laravel/laravel <laravel_project>
    cd <laravel_project>
    chown -R ${current_user}.${current_user} storage
    chown -R ${current_user}.${current_user} bootstrap/cache
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
* After **mysql_secure_installation**
  * MariaDB 10.4 auth method will just like MariaDB 10.3

* Database tools - Adminer
  * Easy to manage database
    * [adminer.php](https://www.adminer.org/)
  * **Stronger than scaffold, and any other admin panel. For quick CRUD**
    * [Adminer-editor.php](https://www.adminer.org/en/editor/)

## Extra functions
* RENDER_CP
  * Render template using eval
  * Sample

    ```bash
    # Method : eval "echo \"$variable\""
    # Might have escape issue, if template is complicated
    RENDER_CP ${$CONFIG_FOLDER}/yourowntemplate_file /SomeWhere/somewhere
    ```

* RENDER_CP_SED
  * Render template using sed
  * Sample

    ```bash
    # Method : cat template | sed 's/\{\{var\}\}/$var/g'
    # BETTER method for rendering template
    RENDER_CP_SED ${$CONFIG_FOLDER}/yourowntemplate_file /SomeWhere/somewhere
    ```

* SAFE_DELETE
  * Check file names and path before rm any dangerous files, preventing from destoying whole server
    * check for the following dangerous key words

      ```bash
      .
      ..
      *
      /
      .*
      *.*
      ```

      ```bash
      "$(echo "$(find / -maxdepth 1 ;  readlink -m /* )" | sort -n | uniq)"
      ```

  * Sample

    ```bash
    # --- Should be failed ---
    DELETE_FILE="/root/delete_me/.*"
    # --- safe delete command usage ---
    SAFE_DELETE "${DELETE_FILE}"
    ```

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
* 2018/06/22
  * MariaDB 10.3
* 2018/07/18
  * Important changes
    * Feature
      * Totally migrate rails ap server from passenger to puma
        * This means nginx is installed through Nginx repo, not passenger-install-nginx-module anymore!
        * Nginx config default config is moving from /opt/nginx/ back to default /etc/nginx/
        * User **root** will no longer be used as a php(laravel) / ruby(rails) developer
      * Totally use socket files instead of tcp socket, for monolithic server structure
        * php-fpm sock file (Instead of tcp 9000)
        * puma sock file
    * Files
      * {rails_app}/config/puma/production.rb
      * puma-mgr command added
      * systemd -> puma.service -> puma-mgr
      * logrotate for all rails / laravel projects
    * Developer user accound
      * phpuser
        * composer installed (for laravel)
      * rubyuser
        * rvm installed (for rails)
* 2018/07/27
  * Install Docker
    * docker-ce
      * Disable docker daemon onboot by default (systemd-docker disabled)
    * docker-compose
* 2018/07/28
  * Install Redmine 3.4.6(ruby 2.4.1, rails 4.2)
    * Redmine plugins: redmine_agile, redmine_lightbox2
* 2019/01/05
  * Update NodeJS from 8.x LTS to 10.x LTS
* 2018/12/12
  * Some changes for nginx Nginx WAF
* 2019/02/27
  * Laravel 5.8
  * Redmine - add 3.4.9 , 4.0.2 version
* 2019/03/12
  * Ruby 2.5.3
* 2019/04/07
  * Enhanced tail - multitail
  * Enhanced grep - ack
* 2019/04/26
  * Redmine - 4.0.2 ---> 4.0.3
* 2019/06/01
  * RVM - 1.29.6 ---> 1.29.8
  * Ruby - 2.5.3 ---> 2.6.3
* 2019/08/03
  * MariaDB 10.4
    * Important effect
      * The unix_socket authentication plugin is now default
        * Login using password is not nesseccary
      * Insecure default empty password '' is disabled
        * the open-for-everyone all-powerful root account is finally gone
  * RVM - 1.29.8 ---> 1.29.9
  * Redmine - 4.0.3 ---> 4.0.4
  * For Rails 6+ use
    * Preview - Video
      * ffmpeg
      * ffmpeg-devel
    * Preview - PDF
      * poppler
      * poppler-devel
      * muPDF (not installed - payment required)
    * Generate - PDF files
      * wkhtmltopdf
      * wkhtmltopdf-devel
* 2019/08/20
  * Ruby on Rails 6.0
* 2019/08/26
  * php 7.2
  * Laravel 6.0
* 2019/11/15
  * Add tmux installation & configuration setup
* 2019/11/27
  * Update NodeJS from 10.x LTS to 12.x LTS
  * Redmine - 4.0.4 ---> 4.0.5
* 2019/12/06
  * tag: v0.1.0
* 2019/12/07
  * tag: v0.1.1
    * changelog: https://github.com/charlietag/os_preparation/compare/v0.1.0...v0.1.1
* 2019/12/08
  * tag: v0.1.2
    * changelog: https://github.com/charlietag/os_preparation/compare/v0.1.1...v0.1.2
* 2019/12/08
  * tag: v0.1.3
    * changelog: https://github.com/charlietag/os_preparation/compare/v0.1.2...v0.1.3
* 2019/12/09
  * tag: v0.1.4
    * changelog: https://github.com/charlietag/os_preparation/compare/v0.1.3...v0.1.4
