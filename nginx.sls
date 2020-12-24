C8C023AD # gcp searchblox admin password
{% set path = salt.grains.get('id') %}
# Run service and enable
Service_nginx:
  service.running:
    - name: nginx
    - enable: True

# Manage configuration file on nginx for searchblox only after cert is acquired and searchblox installed
Manage_file:
  file.managed:
    - name: /etc/nginx/conf.d/nginx-sb.conf
    - require:
        - pkg: Install_nginx
        - acme: Certbot_ssl
        - file: Manage_configuration_files
    - content: |
        server {
            if ($host = $hostname) {
                return 301 https://$host$request_uri;
            } # managed by Certbot


            listen 80;
            listen [::]:80;
            server_name $hostname;
            return 404; # managed by Certbot

        }

        server {

            server_name $hostname;

            location / {
                deny    all;
            }

            location /searchblox {
                allow    all;
                proxy_pass      http://127.0.0.1:8080;

            }

            location /logs {
                allow   136.232.138.26;
                allow   144.121.140.46;
                deny    all;
                alias   /opt/searchblox/webapps/searchblox/logs;
                default_type    text/plain;
                autoindex       on;

            }

            listen [::]:443 ssl ipv6only=on; # managed by Certbot
            listen 443 ssl; # managed by Certbot
            ssl_certificate /etc/letsencrypt/live/{{ path }}/fullchain.pem; # managed by Certbot
            ssl_certificate_key /etc/letsencrypt/live/{{ path }}/privkey.pem; # managed by Certbot

        }


# restarting nginx
Restart_nginx:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
        - file: /etc/nginx/conf.d/nginx-sb.conf