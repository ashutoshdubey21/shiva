# Installing nginx
Install_nginx:
  pkg.installed:
    - name: nginx

# Run service and enable
Service_nginx:
  service.running:
    - name: nginx
    - enable: True

# Manage configuration file on nginx for searchblox
Manage_file:
  file.managed:
    - name: /etc/nginx/conf.d/nginx-sb.conf
    - source: salt://searchblox/nginx-sb.conf
    - require:
        - pkg: Install_nginx

# restarting nginx
Restart_nginx:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
        - pkg: nginx