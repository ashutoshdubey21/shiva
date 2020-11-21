# What does it do?

* This workflow is to allow developers and managers with access to change and deploy the mapping.json file of a production searchblox server.

 * Everything else can be managed by the admin GUI web interface except the mapping.json file.

# Must have components for the Searchblox CI/CD Pipeline

**NOTE: Each component must be configured and the whole must be integrated in order to have a successful CI/CD deployment of the mapping.json file**

* The searchblox server
* The gitlab.com project
* The gitlab-runner server
* The .gitlab-ci.yml file
* The copyandreload.sh file
* The mapping.json file

# Setup the local dev

### 1. Set up the new searchblox server. In addition to the standard Linux server setup, also do these steps:

* Edit sudoers using EDITOR=emacs (or EDITOR=vim) visudo 'prodjenkins ALL=(ALL) NOPASSWD: /home/prodjenkins/copyandreload.sh' to the sudoers file
* Make sure the security group "webserver rules" is attached to the new instance
* when adding server to saltmaster, make sure to apply the state users_global. This will add the gitlab-runner key to the prodjenkins user authorized_keys to the searchblox server
* Add 'internal IP FQDN' to /etc/hosts (e.g. 10.25.52.166 abcsearch301.aws.mtxgp.net)

### 2. Set up new Git project

* In gitlab.com/matrixgroup, go to the folder for the relevant client and create a new project under that folder named $client-searchblox (e.g. iacp-searchblox)
* check the box for INITIALIZE REPO and create README
* Add gitlab-runner.aws.mtxgp.net server as a CI/CD runner for the new project:
    * In the new project go to Settings --> CI/CD --> Expand Variables
    * Add a variable name SERVER_HOSTNAME with the value FQDN of new searchblox server (e.g. iacpsearch302.aws.mtxgp.net) and check the box for the flag PROTECT VARIABLE
    * Go Settings --> CI/CD --> Runners
    * Under Shared Runners, click 'Disable shared runners'
    * Confirm that 'gitlab-runner.aws.mtxgp.net' is listed under 'Available group Runners'
* Add .gitlab-ci.yml and mapping.json to the repo
    * Download .gitlab-ci.yml from here https://drive.google.com/open?id=1V2iTzrEtQ86MabSLhxJnjVILtYRU4m3b (or copy from another searchblox repo
    * Copy the mapping.json file from the searchblox installed on the new server
    * Make sure the .gitlab-ci.yml file has the "." at the beginning of the file name
    * Commit and push both files to the master branch of the new searchblox project repository
    * The project CI/CD pipeline will instantly launch after the .gitlab-ci.yml is pushed to the master branch; monitor the progress of the build at CI/CD --> Jobs

# Configurations info

* Gitlab Runner: Instance: i-0a4a2a89d35d2ea1f gitlab-runner.aws.mtxgp.net
* SSH keys: There additional key for prodjenkins. This key does NOT have a passphrase because the gitlab.com CI/DC system does not work with keys that have passphrase.
* The key secret: https://matrixgroup.secretservercloud.com/app/#/secret/8833/general
* The IP address of gitlab-runner.aws.mtxgp.net is added as allowed SSH incoming on the 'web server rules' security group. This allows the gitlab-runner to connect and do CI/CD tasks.
* The copyandreload.sh script is located in the home directory of the gitlab-runner user on gitlab-runner.aws.mtxgp.net server

# Jira
[JIRA page](https://matrix-group.atlassian.net/browse/ITGEN-80)

# WIKI
[WIKI page](https://wiki.matrixgroup.net/index.php/Searchblox_CI/CD_in_gitlab.com)

is there anything unusual about it?
how do you build it?
how do you run the tests?
how is it deployed?
what does it assume or depend on? eg. "If such and such changes this needs to be changed like so".
where's the WR, Prj Milestone, or Jira or wiki page?