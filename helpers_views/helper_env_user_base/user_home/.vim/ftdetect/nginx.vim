" Set filetype to nginx if folder is under /etc/nginx/
au BufRead,BufNewFile /etc/nginx/* if &ft == '' | setfiletype nginx | endif  
