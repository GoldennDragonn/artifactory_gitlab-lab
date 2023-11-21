# System Requirements

1. Ubuntu 20.04 with docker install and openssl (apt install docker-ce && apt install openssl)
2. Docker in swarm mod (Swarm init)
3. sudoer user

# Installation

1. download images your `setupfolder`:
    * files to download:
        * artifactory.tar
        * gitlab.tar
        * httpd.tar
2. cd to directory where you wish to store the data in
3. replace `<host>` in paramater RequestHeader with your host within setupfolder/httpd.conf - for example 
4. replace OU and, CN and DNS in install.sh with your host and DNS
5. run the following command:
    * `sudo ./install.sh <server>` (for example *artifactorygitlab*) # it will be used for docker compose
6. wait 5 minutes until jfrog is up
7. check that artifactroy is working by going to `https://<host>` 
    * default user: admin 
    * default password: password
8. check that gitlab is working by going to `https://<host>:8443` 
    * default user: root 
    * password: NotSecurePassword123! 

## Post-installation

1. Create a new docker repo named `docker-local` (set port as 4000)
2. In UI, go to Administration->JFrog Container Registry->General->HTTP Settings->Choose Port in 'Docker Access Method'
3. changing certificates: 
    * obtain key and cert issued by your CA for the server.
    * In gitlab change the content of the files `./gitlab/config/ssl/<server>.key` and `./gitlab/config/ssl/<server>.crt`
    * change the content of the files `./jcr/<server>.key` with key and `./jcr/<server>.cert`
4. restart the docker stack by `docker stack rm <server>` and `docker stack deploy -c docker-compose.yml <server>`  
