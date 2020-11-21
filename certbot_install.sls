#Installing Certbot for ssl certificate generation
Install_certbot:
  pkg.installed:
    - name: python3-certbot-nginx

#Generating ssl for the domain
Certbot_ssl:
  acme.cert:
    - name: giittest13.xyz
    - email: adubey@matrixgroup.net
    - webroot: True
    - test_cert: True
    - renew: True
    - certname: giittest13.xyz