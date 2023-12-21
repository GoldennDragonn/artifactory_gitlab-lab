# System Requirements and Prerequsites 

1. Ubuntu 20.04 and highier 

Recommended deploying the Artifactory and Gitlab on secondary partition ( for example /dev/sdb1), to separate it from root for future disk growth ( if will be needed)

2. Docker and OpenSSl Installed 
```
sudo apt install docker-ce && sudo apt install openssl
```
3. Docker in swarm mod 
```
docker swarm init

```
4. User with sudo permissions

# Installation

1. Pull and save images for artifactory, gitlab and httpd as tar files : artifactory.tar, gitlab.tar, httpd.tar
```
docker pull releases-docker.jfrog.io/jfrog/artifactory-jcr:7.71.4
docker save -o artifactory.tar releases-docker.jfrog.io/jfrog/artifactory-jcr:7.71.4

docker pull gitlab/gitlab-ce:15.2.2-ce.0
docker save -o gitlab.tar gitlab/gitlab-ce:15.2.2-ce.0

docker pull httpd:2.4.58
docker save -o httpd.tar httpd:2.4.58

```
2. Copy / Move images tar files to setupfolder.
3. Navigate to setupfolder and perform the following changes:

    3.1. Replace `<host>` in paramater RequestHeader with your host within setupfolder/httpd.conf - for example artifactory.yb.local
    3.2  Replace 'https://replaceHost:8443'  within setupfolder/gitlab.rb with you URL. - for example: https://gitlab.yb.local:8443
4. Adjust the OU, CN, SAN and DNS in install.sh with your host and DNS in lines 9,10,11
5. Run the following command:
    * `sudo ./install.sh <swarm_stack_name>` (for example *artifactory_gitlab*) # it will be used for docker compose
    ```
    sudo ./install.sh artifactory_gitlab
    ```
6. Wait approximately 5 minutes until Jfrog artifactory and Gitlab is up
   In order to track the progess use the following command:
   ```
   watch docker service ls
   ``` 

7. Verify that artifactory is deployed by navigating to `https://<host>` - for example: https://artifactory.yb.local or https://<ipaddres>
    * default user: admin 
    * default password: password

8. Verify that gitlab is deployed by navigating to `https://<host>:8443` - for example: https://gitlab.yb.local:8443 or https://<ipaddress>:8443
    * default user: root 
    * password: NotSecurePassword123! 

## Artifactory Post-installation Setup

Navigate to you Arifactory URL and perform the following steps: 
1. Create a New docker repo named `docker-local` (set port as 4000) (if not created during initial setup process)
2. In UI, go to Administration->JFrog Container Registry->General->HTTP Settings->Choose Port in 'Docker Access Method'
3. In UI, go to Administration->JFrog Container Registry->Backups and disable all Backups.

** If you would like to keep the Backup,provided with JCR Artfactory, make sure you provide the neccessary storage at least x2 from the original sizing. **

## Replacing certificates

1. Obtain private key and cert issued by your CA for the server.
2. For Gitlab, navigate to your installation folder and replace the files: ./gitlab/config/ssl/<swarm_stack_name>.key` and `./gitlab/config/ssl/<swarm_stack_name>.crt`
3. For Artifactory navigate to your installation folder and replace the files ./jcr/<swarm_stack_name>.key` with key and `./jcr/<swarm_stack_name>.cert`

** Important Please keep the same file names **

4. Restart the docker stack by using the following commands: 

```
docker stack rm <swarm_stack_name>

docker stack deploy -c docker-compose.yml <swarm_stack_name>

```

5. Verify the all service re-deployed correctly 

```
docker service ls

```

6. Navigate in browser to Artifactory and Gitlab URL and verify that URL is secured and certificate is correct