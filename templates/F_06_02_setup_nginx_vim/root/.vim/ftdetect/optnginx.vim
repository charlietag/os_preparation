" Set filetype to optngin if folder is under /opt/nginx/
au BufRead,BufNewFile /opt/nginx/* if &ft == '' | setfiletype optnginx | endif  
