#Installation of openjdk-11-jdk
Install_java:
  pkgrepo.managed:
    - name: ppa:openjdk-r/ppa

  pkg.installed:
    - name: openjdk-11-jdk

Install_wget:
  pkg.installed:
    - name: wget

#Adding a user "searchblox" for searchblox files execution
Adding_user_Searchblox:
  user.present:
    - name: searchblox
    - shell: /bin/bash
    - home: /home/searchblox

SearchBlox_debain_package:
  cmd.run:
    - name: |
        cd /opt
        sudo wget https://d2fco3ozzrfhhd.cloudfront.net/v9.2.1/searchblox_9.2.1-0_all.deb
    - creates: /opt/searchblox_9.2.1-0_all.deb


#Install the downloaded debian package of searchblox
Install_the_debian_package:
  cmd.run:
    - name: sudo dpkg -i searchblox_9.2.1-0_all.deb
    - unless: dpkg -l | grep searchblox
    - require:
      - cmd: SearchBlox_debain_package

#change permission of searchblox directory for user "searchblox" to execute the configuration files
Change_user_for_Directory:
  file.directory:
    - name: /opt/searchblox/
    - user: searchblox
    - group: searchblox
    - recurse:
      - user
      - group
    - require:
      - user: Adding_user_Searchblox
Change_permission_for_directories:
  file.directory:
    - names:
      - /opt/searchblox/logs
      - /opt/searchblox/elasticsearch/logs
      - /opt/searchblox/bin
      - /opt/searchblox/analytics/node/bin
    - dir_mode: 755
    - file_mode: 755
    - recurse:
      - mode

#Manage configuration files(start.ini, jvm.options) for low_memory consumption (edit these files on master and push to the minion in it's respective directory

Manage_configuration_files:
  file.managed:
    - name: /opt/searchblox/start.ini
    - source: salt://searchblox/start.ini

Manage_configuration_files_/opt/searchelasticsearch/config/jvm.options:
  file.managed:
    - name: /opt/searchblox/elasticsearch/config/jvm.options
    - source: salt://searchblox/jvm.options

#start the elasticsearch and searchblox service
Start_Elasticsearch_service:
  service.running:
    - name: sbelastic
    - enable: True
Start_SearchBlox_service:
  service.running:
    - name: searchblox
    - enable: True

#Download sbanalytics.service file into /etc/systemd/system
change_directory_/etc/systemd/system:
  cmd.run:
    - name: |
        cd /etc/systemd/system
        wget https://d2bs75lu2qxj7h.cloudfront.net/9.2/analytics/sbanalytics.service
        systemctl daemon-reload
    - creates: /etc/systemd/system/sbanalytics.service

Start_sbanalics_service:
  service.running:
    - name: sbanalytics
    - enable: True