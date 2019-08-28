# Docker container for running node proxied via nginx

Simple docker container running node proxied via nginx. Both managed using supervisord.

Using this image would require
  - Copying content in /var/www (root entry for node)
  - Changing supervisord.conf
  - Magic

