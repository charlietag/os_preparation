# CentOS Linux Server OS Preparation
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

### Nginx related
  * To be distinguish between passenger_install , yum install nginx (nginx yum repo)
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

### Packages
  * PHP7 (Ref.https://webtatic.com/packages/php70)
  * MariaDB 10.1 (equal to MySQL 5.7)
  * nodejs (latest version - 6)
  * Nginx (via passenger)

### Ruby gem config
* gem install without making document
  * Deprecated

    ~~`no-ri, no-rdoc`~~

  * Config

    ```bash
    echo "gem: --no-document" > ~/.gemrc
    ```

