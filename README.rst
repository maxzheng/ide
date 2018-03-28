IDE
================================================================================

Everything needed to setup a Linux OS using Docker for software development.

Mostly it contains customized packages and setups for the author's software
development needs, such as using Vim to write Python programs, but sharing it
so others may find it useful and it should be fairly easy to fork and customize
to your own setup.

Build the image::

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
