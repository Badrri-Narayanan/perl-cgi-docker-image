# Perl CGI scripts Docker Image

This is an amateur attempt to create an immutable deployment environment for legacy Perl CGI scripts. You can customize the Dockerfile based on your requirements.

## Quick Start

You need docker installed for this and that's all!

Run the below command to start the container

```sh
docker-compose up --build
```

To destroy the container, run

```sh
docker-compose down
```

If you modify the apache httpd server config, then you need to re-build the docker image for the changes to take effect.

## User Guide

Once you start the container, I have given some sample perl scripts to get yourselves familiarized with Perl CGI scripting

You can access the webpage using [this link](http://localhost:8080/)

### Note:

This project uses Apache httpd server and mod_perl for running the Perl CGI scripts.

Also, please help me in improving and maintaining this project.
