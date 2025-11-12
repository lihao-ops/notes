blog.conf

```bash
#http
server {
    
    listen 80;
   
    server_name lhblog.top;
    
    location / {
        root /accomplish/software/nginx/html/blog;
        index index.html index.php;
    }
    #添加有关php程序的解析
    location ~ .*\.(php|php5)?$ {
        root /accomplish/software/nginx/html/blog;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi.conf;
    }

}

#https
server {

    listen 443 ssl default_server;

    server_name lhblog.top www.lhblog.top;

    # SSL 证书和密钥
    ssl_certificate "/accomplish/software/nginx/conf/ssl/www.lhblog.top.pem";
    ssl_certificate_key "/accomplish/software/nginx/conf/ssl/www.lhblog.top.key";

    # 启用 SSL/TLS(由于ssl指定会自动启动,故此无需此配置)
    #ssl on;

    # 启用 SSL/TLS
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';

    # HTTPS 配置项
    location / {
        root /accomplish/software/nginx/html/blog;
        index index.html index.php;
    }
    #添加有关php程序的解析
    location ~ .*\.(php|php5)?$ {
        root /accomplish/software/nginx/html/blog;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi.conf;
    }
}
```

