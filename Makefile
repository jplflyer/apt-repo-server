# On some systems, I get a weird version of docker -- no idea where it comes
# from. Using this seems to fix it.
DOCKER := $(shell which docker)

#
# Create the container image.
#
image:
		${DOCKER} image build  -t jplflyer/apt-repo-server:latest .

#
# Start the continer. Change the -v command to fit the location of your data dir.
#
up:
		${DOCKER} run -d --name repo -e DISTS="bionic,focal" -v ${PWD}/data:/data -p 10000:80 jplflyer/apt-repo-server

#
# Stop the container.
#
down:
		${DOCKER} stop repo
		${DOCKER} rm repo

#
# Attach to the container to see how it's doing.
#
attach:
		${DOCKER} exec -it repo /bin/bash
