#Installation of openjdk-11-jdk
Install_java:
  pkgrepo.managed:
    - name: ppa:openjdk-r/ppa

  pkg.installed:
    - name: openjdk-11-jdk

update_apt:
  cmd.run:
    - name: apt-get update -y

Install_wget:
  pkg.installed:
    - name: wget

#Adding a user "searchblox" for searchblox files execution
Adding_user_Searchblox:
  user.present:
    - name: searchblox
    - shell: /bin/bash
    - home: /home/searchblox

#change directory to /opt and Download Searchblox debain package
change_directory:
  cmd.run:
    - name: cd /opt

SearchBlox_debain_package:
  cmd.run:
    - name: sudo wget https://d2fco3ozzrfhhd.cloudfront.net/v9.2.1/searchblox_9.2.1-0_all.deb

#Install the downloaded debian package of searchblox
Install_the_debian_package:
  cmd.run:
    - name: sudo dpkg -i searchblox_9.2.1-0_all.deb

#change permission of searchblox directory for user "searchblox" to execute the configuration files
Change_Permission_for_Directory:
  cmd.run:
    - name: |
        sudo chown -R searchblox:searchblox /opt/searchblox
        sudo chmod -R 755 /opt/searchblox/logs
        sudo chmod -R 755 /opt/searchblox/elasticsearch/logs
        sudo chmod -R 755 /opt/searchblox/bin
        sudo chmod -R 755 /opt/searchblox/analytics/node/bin

#Manage configuration files(start.ini, jvm.options) for low_memory consumption (edit these files on master and push to the minion in it's respective directory
Manage_configuration_files:
  file.managed:
    - name: /opt/searchblox/start.ini
    - source: salt://start.ini

Manage_configuration_files_/opt/searchelasticsearch/config/jvm.options:
  file.managed:
    - name: /opt/searchblox/elasticsearch/config/jvm.options
    - source: salt://jvm.options

#start the elasticsearch and searchblox service
Start_Elasticsearch_and_SearchBlox_services:
  cmd.run:
    - name: |
        systemctl start sbelastic
        systemctl start searchblox

#Download sbanalytics.service file into /etc/systemd/system and start sbanalytics
change_directory_/etc/systemd/system:
  cmd.run:
    - name: |
        cd /etc/systemd/system
        wget https://d2bs75lu2qxj7h.cloudfront.net/9.2/analytics/sbanalytics.service
        systemctl daemon-reload
        systemctl start sbanalytics
