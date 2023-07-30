# System Requirements

1. Ubuntu 20.04 with docker install and openssl (apt install docker-ce && apt install openssl)
2. Docker in swarm mod (Swarm init)
3. sudoer user

# Installation

1. download images from xxxxx storage to your `setupfolder`:
    * server - xxxxxx
    * path - /xxxxx/xxxxx/gitlab-files
    * files to download:
        * artifactory.tar
        * gitlab.tar
        * httpd.tar
2. cd to directory where you wish to store the data in
3. untar jfrog.tar.gz to jfrog (`tar -xzf jfrog.tar.gz`)
4. replace <host> in paramater RequestHeader with your host within setupfolder/httpd.conf
5. replace OU and, CN and DNS in install.sh with your host and DNS
6. run the following command:
    * `sudo ./install-jfrog.sh <server>` (replace server with host name, for example *example.local*)
7. wait 5 minutes until jfrog is up
8. check that artifactroy is working by going to `https://<server>` 
    * default user: admin 
    * default password: password
9. check that gitlab is working by going to https://<server>:8443 
    * default user: root 
    * password: NotSecurePassword123! 

## Post-installation

1. Create a new docker repo named `docker-local` (set port as 4000)
2. In UI, go to Administration->JFrog Container Registry->General->HTTP Settings->Choose Port in 'Docker Access Method'
3. changing certificates: 
    * obtain key and cert issued by your CA for the server.
    * In gitlab change the content of the files ./gitlab/config/ssl/<server>.key with key and ./gitlab/config/ssl/<server>.crt
    * change the content of the files `./jcr/<server>.key with key and ./jcr/<server>.cert
4. restart the docker stack by "docker stack rm xxxx" and "docker stack deploy -c docker-compose.yml xxx"  
3. restart the docker stack by "docker stack rm xxxx" and "docker stack deploy -c docker-compose.yml xxx" 
