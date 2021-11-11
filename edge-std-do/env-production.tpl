LETSENCRYPT_EMAIL=${ webmaster_email }
ERPNEXT_VERSION=edge
FRAPPE_VERSION=edge
MARIADB_HOST=mariadb
MYSQL_ROOT_PASSWORD=${ database_password }
SITE_NAME=${ server_name }
SITES=`${ server_name }`
DB_ROOT_USER=root
ADMIN_PASSWORD=${ admin_password }
INSTALL_APPS=erpnext
ENTRYPOINT_LABEL=traefik.http.routers.erpnext-nginx.entrypoints=websecure
CERT_RESOLVER_LABEL=traefik.http.routers.erpnext-nginx.tls.certresolver=myresolver
HTTPS_REDIRECT_RULE_LABEL=traefik.http.routers.http-catchall.rule=hostregexp(`{host:.+}`)
HTTPS_REDIRECT_ENTRYPOINT_LABEL=traefik.http.routers.http-catchall.entrypoints=web
HTTPS_REDIRECT_MIDDLEWARE_LABEL=traefik.http.routers.http-catchall.middlewares=redirect-to-https
HTTPS_USE_REDIRECT_MIDDLEWARE_LABEL=traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https
SKIP_NGINX_TEMPLATE_GENERATION=0
WORKER_CLASS=gthread