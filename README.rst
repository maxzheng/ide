IDE
================================================================================

Everything needed to setup a Linux OS via Docker for software development. It is
using `Docker Compose <https://docs.docker.com/compose/overview>`_ to help build
the image and start the OS along with MySQL.

This contains customized packages and setups for the author's software
development needs, such as using Vim to write Python programs. It should be fairly
easy to fork and customize to your own setup.

This reduces the effort required to setup a full development environment as it
encapsulates all the software needed along with their configurations. Any
persisted data (e.g. workspace) are mapped using host or Docker volumes, so the
containers can be rebuilt anytime to make changes. `~/workspace` directory is using
Docker volume for best performance as host volume mapping isn't performant
(therefore not ideal for checkouts that have large amount of data). Credentials
are mapped from the host via host volume.

Build the image (`Dockerfile <Dockerfile>`_) and start the OS and MySQL containers per `docker-compose.yml <docker-compose.yml>`_::

    $ git clone git@github.com:maxzheng/ide.git && cd ide
    $ ./up.sh

    Building os
    Step 1/21 : FROM ubuntu:rolling
    ...
    Successfully built 777754a93b49
    Successfully tagged ide_os:latest

    Creating mysql ... done
    Creating ide   ... done

There are 3 containers started by Docker Compose::

    $ docker ps

    CONTAINER ID    IMAGE       ...    PORTS                                           NAMES
    88f0c5bdadcf    ide_os      ...    0.0.0.0:5000->5000/tcp, 0.0.0.0:2222->22/tcp    ide
    3e9bd829cb04    mysql       ...    3306/tcp                                        mysql

* ide: The IDE that contains everything for doing software development (Vim, Python, etc).
* mysql: MySQL database that is accessible from `ide` using the hostname `mysql` for testing.

Start a shell into the `ide` container via exec::

    $ ./shell.sh

Or better yet, SSH into the container::

    # Add the following to your .ssh/config first:
    # Host ide
    #   HostName localhost
    #   Port 2222

    $ ssh ide

    Welcome to Ubuntu 17.10 (GNU/Linux 4.9.87-linuxkit-aufs x86_64)

     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage

    Last login: Fri Mar 30 21:25:00 2018 from 172.19.0.1

    [~]$ cd workspace/
    [workspace]$ ls
    aiohttp-requests  python-examples  workspace-tools
