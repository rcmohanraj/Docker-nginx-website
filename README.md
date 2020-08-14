### Docker

#### Docker Image:  
Image is template for creating an environment of your choice and its basically a snapshot(versions).It contains everything the application needs. OS, Software, Application code.

#### Containers:  
Its a running instance of an image.  

#### Docker Hub:  
Its registry of docker images.  

#### Docker Commands:  

##### Docker version:
> docker --version  
Docker version 19.03.12, build 48a66213fe

##### Download the image from dockerhub:
> docker pull nginx  
Using default tag: latest
latest: Pulling from library/nginx
Status: Downloaded newer image for nginx:latest

##### List the available images:
> docker images  
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE  
nginx               latest              08393e824c32        5 days ago          132MB  

##### Run the image with the specified tag:
> docker run nginx:latest
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Configuration complete; ready for start up

##### View the running containers:
> docker container ls  
(or)  
> docker ps  
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES  
ce6890ef1a51        nginx:latest        "/docker-entrypoint.…"   4 minutes ago       Up 4 minutes        80/tcp              nifty_taussig  

##### Run the image in the detached mode:
> docker run -d nginx:latest  
ae5e9f294e3b420bd7e025502f3a429886f3772db68edc9ab5894643ea26e3bf

##### View running containers:
> docker ps  
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
ae5e9f294e3b        nginx:latest        "/docker-entrypoint.…"   5 seconds ago       Up 3 seconds        80/tcp              charming_wescoff
ce6890ef1a51        nginx:latest        "/docker-entrypoint.…"   13 minutes ago      Up 13 minutes       80/tcp              nifty_taussig

##### Stop the running container:
> docker stop ce6890ef1a51  
ce6890ef1a51

##### View running containers:
> docker ps  
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES  
ae5e9f294e3b        nginx:latest        "/docker-entrypoint.…"   5 seconds ago       Up 3 seconds        80/tcp              charming_wescoff  

#### Expose Ports With Docker:
PORTS 80/tcp is meaning the container is running exposed in the port 80. We can map our local port to the container port to access the container instance.  
For mapping we can use -p fromport:conainerport  

> docker run -d -p 8080:80 nginx:latest  
c82db3541c4e5e08df1a0e8f30fa2607f9433424f8526c04904b76ebde1059b2  

> docker ps  
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES  
c82db3541c4e        nginx:latest        "/docker-entrypoint.…"   32 seconds ago      Up 30 seconds       0.0.0.0:8080->80/tcp   awesome_grothendieck  

We can also map multiple port to the same container instance port.

> docker run -d -p 8080:80 -p 3000:80 nginx:latest  

> docker ps  
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                        NAMES
1ad836d78cfe        nginx:latest        "/docker-entrypoint.…"   14 seconds ago      Up 12 seconds       0.0.0.0:3000->80/tcp, 0.0.0.0:8080->80/tcp   goofy_kowalevski

Now we can able to access the nginx from localhost:8080 as well as localhost:3000.
We can also use the names of the image to start and stop the container. 

##### To view the all the available containers (either running ot stopped):
> docker ps -a  
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
1ad836d78cfe        nginx:latest        "/docker-entrypoint.…"   4 minutes ago       Exited (0) 4 minutes ago                        goofy_kowalevski
c82db3541c4e        nginx:latest        "/docker-entrypoint.…"   9 minutes ago       Exited (0) 7 minutes ago                        awesome_grothendieck
ae5e9f294e3b        nginx:latest        "/docker-entrypoint.…"   37 minutes ago      Exited (0) 10 minutes ago                       charming_wescoff
ce6890ef1a51        nginx:latest        "/docker-entrypoint.…"   51 minutes ago      Exited (0) 37 minutes ago                       nifty_taussig

##### Display only numeric id of containers:
> docker ps -aq
1ad836d78cfe
c82db3541c4e
ae5e9f294e3b
ce6890ef1a51

##### Remove Containers:
> docker rm 1ad836d78cfe

##### Remove All Containers:(this will not remove the running container instance) not working in windows
> docker rm $(docker ps -aq)

##### Removing Running Container:  
> docker rm 9178d8d258c7
Error response from daemon: You cannot remove a running container 9178d8d258c78c162468f70adf6c57b509cfc30888e8e4e0fce0adc68ada6255. Stop the container before attempting removal or force remove

We cannot remove running containers using rm command. We need to use the force remove command.
> docker rm -f 9178d8d258c7
9178d8d258c7

#### Naming the Container:  

> docker run --name myowncontainer -d -p 8080:80 nginx:latest  
030629fd77eaa16901143f6b43dc83628eb9a7315d4736542896f39ffb4c1cc1  

> docker ps  
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES  
030629fd77ea        nginx:latest        "/docker-entrypoint.…"   5 seconds ago       Up 2 seconds        0.0.0.0:8080->80/tcp   myowncontainer  

We can use the name for stopping and starting and removing instead of using the container id.

#### Format the docker ps result:  
> docker ps --format="ID\t{{.ID}}\nNAME\t{{.Names}}\nIMAGE\t{{.Image}}\nPORTS\t{{.Ports}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.CreatedAt}}\nSTATUS\t{{.Status}}\n"
ID      030629fd77ea
NAME    myowncontainer
IMAGE   nginx:latest
PORTS   0.0.0.0:8080->80/tcp
COMMAND "/docker-entrypoint.…"
CREATED 2020-08-11 08:04:05 +0530 IST
STATUS  Up 17 minutes

#### Volumes:
Allow sharing data, files and folders between Host and Container and between Containers as well. We have to create a volume inside the container and if any files added to the Host it will also appear in the Container volume. If files added to the volume it will appear in the Host as well.

> docker run --name homepage -v F:\MyWorks\frontend\docker-nginx-homepage:/usr/share/nginx/html:ro -d -p 8080:80 nginx:latest
04fe3be0edee0d46b6d8c4327fa6c231fefbd350dc7214df2fc39c360637013a

We have changed the acutal home page of the nginx to our custom html using volumes.  
##### To display files inside a container in our command line: (go inside the container)
> docker exec -it homepage bash
root@04fe3be0edee:/#
root@04fe3be0edee:/# cd /usr/share/nginx/html/website
root@04fe3be0edee:/usr/share/nginx/html/website# ls
index.html
root@04fe3be0edee:/usr/share/nginx/html/website# touch about.html
touch: cannot touch 'about.html': Read-only file system
root@04fe3be0edee:/usr/share/nginx/html/website#

Because we have given only readonly permission while starting the container. -it means interactive mode. We can use control+d to exit from the container bash. 

To give write permission to the container we need to stop and remove the homepage container and use the below command.  
> docker run --name homepage -v F:\MyWorks\frontend\docker-nginx-homepage:/usr/share/nginx/html -d -p 8080:80 nginx:latest
f9c9333f60918afa0482ffdd8568df97331e7d1d5ea75baed0af826a54f067ea

Now we can able to create files inside the mounted container and the created file will also be reflected in the Host file system.  
root@f9c9333f6091:/# cd /usr/share/nginx/html/website/
root@f9c9333f6091:/usr/share/nginx/html/website# touch about.html
root@f9c9333f6091:/usr/share/nginx/html/website# ls
about.html  index.html
root@f9c9333f6091:/usr/share/nginx/html/website#

#### Share Volumes Between Containers:
> docker run --name homepage-copy --volumes-from homepage -d -p 8081:80 nginx:latest
53d42115ecdea35560a3e387324d42bcdb1c91832209a85070a4d6db1d2c8218

Here homepage is the already running container name. fetching volume from homepage to homepage-copy.

> docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
53d42115ecde        nginx:latest        "/docker-entrypoint.…"   17 seconds ago      Up 14 seconds       0.0.0.0:8081->80/tcp   homepage-copy
f9c9333f6091        nginx:latest        "/docker-entrypoint.…"   38 minutes ago      Up 38 minutes       0.0.0.0:8080->80/tcp   homepage

Now we can able to access the homepage from both the URLs (localhost:8080/website and localhost:8081/website).

### Building Image:
Docker File => Docker Image => Docker Container

> docker build --tag homepage:latest .                                                                                                      
Sending build context to Docker daemon  464.9kB
Step 1/2 : FROM nginx:latest
 ---> 08393e824c32
Step 2/2 : ADD . /usr/share/nginx/html
 ---> d739485344f5
Successfully built d739485344f5
Successfully tagged homepage:latest
SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.

> docker images  
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
homepage            latest              d739485344f5        39 seconds ago      133MB
nginx               latest              08393e824c32        7 days ago          132MB

> docker run --name website -d -p 8080:80 homepage:latest                                                                                   7793383ded08b0fc9d1df3f4e0b974051086ee49d53259c61d95e0d8cf0fb31a
> docker ps  
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
7793383ded08        homepage:latest     "/docker-entrypoint.…"   6 seconds ago       Up 2 seconds        0.0.0.0:8080->80/tcp   website

We didn't create any volumes but we have copied our source code to the container html folder and can able to access our application localhost:8080

#### Express JS Service: Dockerfile  
FROM node:latest		==> taking the base latest node js image
WORKDIR /app			==>	Creating working directory /app inside the container. now the below subsequent commands are executed from this working directory /app
ADD . .					==> Adding all the files from current(specified by period .) local path to the current(specified by period .)
RUN npm install			==> Running npm install to install the dependencies
CMD node index.js		==> Execute this command when the images is started.

Docker uses caching technique to generate docker image based on the docker file. If the source code changed and if we run the docker build, docker will use cache for WORKDIR command, but ADD command is the one where sources changed, so after that it will not use cache, it will run all the commands as like no cache. 

To use cache for npm install when there is no change we need to modify the dockerfile little.

FROM node:latest		==> taking the base latest node js image
WORKDIR /app			==>	Creating working directory /app inside the container. now the below subsequent commands are executed from this working directory /app
ADD package*.json ./	==> Copy only package.json from local system current path to the container current path
RUN npm install			==> Running npm install to install the dependencies. first time it will do the install for the next time if there is no change in package.json it will use cache
ADD . .					==> Adding all the files from current(specified by period .) local path to the current(specified by period .)
CMD node index.js		==> Execute this command when the images is started.

In this way if there is any change to the package json, docker will not use cache, otherwise it will use cache for npm install.

```
> docker build -t user-service-api:latest .                                                                                        
Sending build context to Docker daemon  19.97kB
Step 1/6 : FROM node:latest
 ---> 002df0b34ccb
Step 2/6 : WORKDIR /app
 ---> Using cache
 ---> 8857f60ff03d
Step 3/6 : ADD package*.json ./
 ---> 55f54e6429a4
Step 4/6 : RUN npm install
 ---> Running in 77936b16321a
npm WARN user-service-api@1.0.0 No description
npm WARN user-service-api@1.0.0 No repository field.

added 50 packages from 37 contributors and audited 50 packages in 4.989s
found 0 vulnerabilities

Removing intermediate container 77936b16321a
 ---> 64e3f44d49bf
Step 5/6 : ADD . .
 ---> a866311b309e
Step 6/6 : CMD node index.js
 ---> Running in 347baaae7900
Removing intermediate container 347baaae7900
 ---> 1263a4924629
Successfully built 1263a4924629
Successfully tagged user-service-api:latest
```
```
> docker ps -a                                                                                                                     
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                    NAMES
ab8f249db572        user-service-api:latest   "docker-entrypoint.s…"   9 seconds ago       Up 7 seconds        0.0.0.0:3000->3000/tcp   user-api
0625b83a0ddb        homepage:latest           "/docker-entrypoint.…"   2 hours ago         Up 2 hours          0.0.0.0:8080->80/tcp     website
```

Now we are changing the source by adding another email to the response. (index.js), we need to rebuild the docker file to create the new image.

```
> docker build -t user-api:latest .                                                                                                
Sending build context to Docker daemon  19.97kB
Step 1/6 : FROM node:latest
 ---> 002df0b34ccb
Step 2/6 : WORKDIR /app
 ---> Using cache
 ---> 8857f60ff03d
Step 3/6 : ADD package*.json ./
 ---> Using cache
 ---> 55f54e6429a4
Step 4/6 : RUN npm install
 ---> Using cache
 ---> 64e3f44d49bf
Step 5/6 : ADD . .
 ---> d5e95e355995
Step 6/6 : CMD node index.js
 ---> Running in c8ba1a3b8fdf
Removing intermediate container c8ba1a3b8fdf
 ---> adf025e76a66
Successfully built adf025e76a66
Successfully tagged user-api:latest
```

From the above build steps we can identify, docker using cache for npm install as there is no change in the package.json file even though the source is changed.

Reducing the final image size:  
We can use the alpine linux distribution version for nginx or node or all other images, to reduce the size of the total image.

FROM node:alpine
WORKDIR /app
ADD package*.json ./
RUN npm install
ADD . .
CMD node index.js

> docker image ls                                                                                                                           
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
website             latest              e151f2956324        8 seconds ago       22MB
user-service-api    latest              035160e49278        4 minutes ago       119MB
homepage            latest              0ca452bcf0ec        3 hours ago         133MB
node                latest              002df0b34ccb        6 days ago          943MB
nginx               latest              08393e824c32        7 days ago          132MB
node                alpine              0d8a3475dbc3        12 days ago         117MB
nginx               alpine              ecd67fe340f9        4 weeks ago         21.6MB

If we use alpine distribution the total image size is very small. (node from 943MB to 117MB)

#### Tags and Version:
Allows to control the image version and avoid breaking changes. Instead of using the latest tag, giving the stable release version of node alpine version. 

FROM node:12.18.3-alpine
WORKDIR /app
ADD package*.json ./
RUN npm install
ADD . .
CMD node index.js

##### Tagging our own images:
Converting existing latest image to new version.
> docker tag confessions-website:latest confessions-website:1  
building the docker image with new content and this will have tag as latest and will do the docker tag with version as confessions-website:2.

> docker run --name website-1 -d -p 8080:80 confessions-website:1
83950bf4b5d163741c028148218814734dfb0bf6cfd26bae7da87ae9dec316d6
> docker run --name website-2 -d -p 8081:80 confessions-website:2 
1a1585f0772a83fdd395431c6d5beb571ab46ec2ea843d362fe0ffb390713226
> docker run --name website-latest -d -p 8082:80 confessions-website:latest                                                                         ea9c760f6612ba12c31eacc93ed808c547673cfd991e979e08d7ad264e3de87c
> docker ps                                                                                                                                         
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                  NAMES
ea9c760f6612        confessions-website:latest   "/docker-entrypoint.…"   4 seconds ago       Up 2 seconds        0.0.0.0:8082->80/tcp   website-latest
1a1585f0772a        confessions-website:2        "/docker-entrypoint.…"   20 seconds ago      Up 18 seconds       0.0.0.0:8081->80/tcp   website-2
83950bf4b5d1        confessions-website:1        "/docker-entrypoint.…"   33 seconds ago      Up 31 seconds       0.0.0.0:8080->80/tcp   website-1

Now we are having 3 instance of our website running where 8080 is having old website and 8081 and 8082 will have website 2 and latest respectively. Always version latest points out latest version of the tag. (in the example website-2 and website-latest have same content)

#### Docker Registry:
Docker Registry is a server side application which will store the images, It will also have CI/CD pipeline support as well as running our application.

To push our new image we need to use the command  
docker push rcmohanraj/website:1

To delete an image:  
```
> docker push rcmohanraj/user-service-api
The push refers to repository [docker.io/rcmohanraj/user-service-api]
17ad8e3c03af: Pushed                                                                                                                                                                            1a45c7646a71: Pushed                                                                                                                                                                            28f78af2c50e: Pushed                                                                                                                                                                            0176e5418b19: Pushed                                                                                                                                                                            aedafbecb0b3: Mounted from library/node                                                                                                                                                         
db809908a198: Mounted from library/node                                                                                                                                                         
1b235e8e7bda: Mounted from library/node                                                                                                                                                         
3e207b409db3: Mounted from rcmohanraj/website                                                                                                                                                   
1: digest: sha256:d6e9cf7a34314c55d2551f43c9494fe7531c63734b2fba4b0639ba69387d8538 size: 1992
17ad8e3c03af: Layer already exists                                                                                                                                                              
1a45c7646a71: Layer already exists                                                                                                                                                              
28f78af2c50e: Layer already exists                                                                                                                                                              
0176e5418b19: Layer already exists                                                                                                                                                              
aedafbecb0b3: Layer already exists                                                                                                                                                              
db809908a198: Layer already exists                                                                                                                                                              
1b235e8e7bda: Layer already exists                                                                                                                                                              
3e207b409db3: Layer already exists                                                                                                                                                              
latest: digest: sha256:d6e9cf7a34314c55d2551f43c9494fe7531c63734b2fba4b0639ba69387d8538 size: 1992
```

#### Inspect Docker Container:
docker inspect imageid or name  
docker inspect 7c0e48470b06

#### View Container Logs:

docker logs 7c0e48470b06 ==> to view the logs
docker logs -f 7c0e48470b06	==> to follow or tail the logs

#### Inside Container:
docker exec -it 84cb47123645 sh