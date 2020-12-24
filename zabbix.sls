# generating PSK
Generate_PSK:
  cmd.run:
    - name: openssl rand -hex 32 > /etc/zabbix/default.psk

# giving right permissions to default.psk file
Permission_psk:
  file.managed:
    - name: /etc/zabbix/default.psk
    - user: root
    - group: zabbix
    - mode: 640

# managing zabbix_agentd.conf file explicitly
zabbix_agent_config:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://zabbix_agentd.conf
    - template: jinja

# restarting zabbix agent
Restart_zabbix_agent:
  service.running:
    - name: zabbix-agent
    - reload: True