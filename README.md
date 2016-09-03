* Environment
  * CentOS 7
* Packages
  * PHP7 (Ref.https://webtatic.com/packages/php70)
  * MariaDB 10.1 (equal to MySQL 5.7)
  * nodejs (latest version - 6)
* Ruby gem config
<pre>
# for ruby gem install without making document (no-ri, no-rdoc are deprecated)
# echo "gem: --no-document" > ~/.gemrc
</pre>
* Vim colorscheme tested
  <pre>
    /usr/share/vim/vim72/colors
    ++++++++++++
    colorscheme desert
    colorscheme elflord
    colorscheme koehler
    colorscheme ron
    colorscheme torte <--- Most proper
    colorscheme 256-jungle
    colorscheme lucid
    colorscheme motus
    ++++++++++++
  </pre>
* Optional
  * VSFTPD
    <pre>
yum install -y vsftpd
sed -i s/^root/'#root'/g /etc/vsftpd/ftpusers
sed -i s/^root/'#root'/g /etc/vsftpd/user_list
    </pre>
