docker-sphinxsearch
===================

The purpose of this project is to provide an image with a configured and running sphinxsearch server.

## Sphinxsearch

Sphinx is an open source full text search server, designed from the ground up with performance, relevance (aka search quality), and integration simplicity in mind. It's written in C++ and works on Linux (RedHat, Ubuntu, etc), Windows, MacOS, Solaris, FreeBSD, and a few other systems.

## Building docker-sphinxsearch

Running this will build a docker image with sphinxsearch 2.1.8.
It has been configured with options: `--with-mysql --without-pgsql --with-libstemmer --with-libexpat --with-iconv --with-unixodbc`.

    git clone https://github.com/srounet/docker-sphinxsearch
    cd docker-sphinxsearch
    docker build -t YOU/sphinxsearch .

## Running docker-sphinxsearch

This image expose three ports 22 for ssh and 9306 9312 for sphinxsearch.

    sudo docker run -d -P -t --name sphinxsearch YOU/sphinxsearch
    
## Image active users

The root password is `toor`, you also have a sudoer additonnal user called `sphinx` with `sphinx` as password.

## Start searchd

Find the local bound port for your sphinxsearch running image (`docker ps -a` should help), then:

    ssh root@localhost -p BOUND PORT
    searchd
    
You can check that searchd has started successfully using: `ps aux | grep searchd` if you see a process called searchd, that means it's running and you are ready to go.

### Notes on the run command

 + `srounet/docker-sphinxsearch` is simply what I called my docker build of this image
 + `-d=true` allows this to run cleanly as a daemon, remove for debugging
 + `--name` the name you see when you execute `docker ps`
 + `-t` allocate a pseudo-tty
 + `-P` binds the three ports to 0.0.0.0 on your host, so you can access it from where you want.

### Side note on dummy.xml

To be abble to start searchd, you need to have at least one configured index. I created one for you that does nothing, so you can start searchd just after building the image to see if everything is ok.
