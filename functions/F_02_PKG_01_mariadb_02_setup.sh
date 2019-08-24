# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# Setup bind-address
echo "==============================="
echo "  Setup mariadb config"
echo "==============================="
sed -e '/^bind-address/ s/^#*/#/' -i /etc/my.cnf.d/server.cnf
sed -e "/^\[mysqld\]/a bind-address = ${mariadb_listen_address}" -i /etc/my.cnf.d/server.cnf

systemctl restart mariadb

# -------------------------------------------
# For MariaDB 10.4 extra setting
# -------------------------------------------
# Make sure password for root is set to '' in MariaDB 10.4 (MariaDB 10.3 , default is '')
mysqladmin -u root password ''


# -------------------------------------------
# For MariaDB 10.4 extra note
# -------------------------------------------
# Started from MariaDB 10.4
# * Insecure password is disabled
#   * Logining with password empty is disabled (password '' is replaced with invalid).
#     * Ref. mariadb 10.4 (https://mariadb.com/kb/en/library/authentication-from-mariadb-104/)
#     * CREATE USER root@localhost IDENTIFIED VIA unix_socket OR mysql_native_password USING 'invalid'
#     * CREATE USER mysql@localhost IDENTIFIED VIA unix_socket OR mysql_native_password USING 'invalid'

#       After mysqladmin -u root password '' --->

#         MariaDB [(none)]> select host,user,password,plugin from mysql.user;
#         +-----------+-------+----------+-----------------------+
#         | Host      | User  | Password | plugin                |
#         +-----------+-------+----------+-----------------------+
#         | localhost | root  |          | mysql_native_password |
#         | localhost | mysql | invalid  | mysql_native_password |
#         +-----------+-------+----------+-----------------------+

# * unix_socket enabled by default (not useful, if only one user 'root' in db)
#   * For instance.
#     * userA@localhost $ whoami  # userA
#     * userA@localhost $ mysql -u userA  #This will login successfully without password required, no matter if password is set!
#                                         (And of course userA can only view DB:test only)
 
#       Login via unix socket --->
#         MariaDB [(none)]> status
#         --------------
#         mysql  Ver 15.1 Distrib 10.4.7-MariaDB, for Linux (x86_64) using readline 5.1
         
#         Connection id:          8
#         Current database:
#         Current user:           root@localhost
#         SSL:                    Not in use
#         Current pager:          stdout
#         Using outfile:          ''
#         Using delimiter:        ;
#         Server:                 MariaDB
#         Server version:         10.4.7-MariaDB MariaDB Server
#         Protocol version:       10
#         Connection:             Localhost via UNIX socket
#         Server characterset:    latin1
#         Db     characterset:    latin1
#         Client characterset:    utf8
#         Conn.  characterset:    utf8
#         UNIX socket:            /var/lib/mysql/mysql.sock
#         Uptime:                 22 min 45 sec
