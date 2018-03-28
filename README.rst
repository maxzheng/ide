IDE
================================================================================

Everything needed to setup a Linux OS via Docker for software development.

This contains customized packages and setups for the author's software
development needs, such as using Vim to write Python programs, but sharing it
so others may find it useful and it should be fairly easy to fork and customize
to your own setup.

This reduces the effort required to setup a full development environment as it
encapsulates all the software needed along with their configurations. Any
persisted data (e.g. workspace) are mapped using host volumes, so the container
can be rebuilt anytime to make changes. Due to the use of host volumes,
there is a `performance penality when accesing those mapped files`__.
For better performance, I will likely switch to a Docker volume soon.

__ https://forums.docker.com/t/file-access-in-mounted-volumes-extremely-slow-cpu-bound/8076

Build the image as specified by `Dockerfile <Dockerfile>`_::

    ./build.sh

Run the container in detached mode with volume mappings (and stops existing if any)::

    ./run.sh

Start a shell via exec::

    ./shell.sh

Or better yet, SSH into the container::

    # Add the following to your .ssh/config first:
    # Host ide
    #   HostName localhost
    #   Port 2222

    ssh ide
