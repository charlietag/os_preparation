## Environment
  * CentOS 7

## Warning
  * Please do this in fresh install OS

## Usage

  ```bash
  yum install -y
  git clone https://github.com/charlietag/os_preparation.git
  ```

  ```bash
  ./start.sh -h
  usage: start.sh
    -a                   ,  run all functions
    -i func1 func2 func3 ,  run specified functions
  ```

## Packages
  * PHP7 (Ref.https://webtatic.com/packages/php70)
  * MariaDB 10.1 (equal to MySQL 5.7)
  * nodejs (latest version - 6)

## Ruby gem config
* gem install without making document
  * Deprecated

    ~~`no-ri, no-rdoc`~~

  * Config

    ```bash
    echo "gem: --no-document" > ~/.gemrc
    ```

## Built-in vim colorscheme
* /usr/share/vim/vim72/colors

  ```bash
  colorscheme desert
  colorscheme elflord
  colorscheme koehler
  colorscheme ron
  colorscheme torte <--- Most proper
  colorscheme 256-jungle
  colorscheme lucid
  colorscheme motus
  ```

## Optional
  * VSFTPD

    ```bash
    yum install -y vsftpd
    sed -i s/^root/'#root'/g /etc/vsftpd/ftpusers
    sed -i s/^root/'#root'/g /etc/vsftpd/user_list
    ```

