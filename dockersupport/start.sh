#!/bin/sh
echo 'INFO: starting nginx'
echo 'INFO: starting node'
supervisord  -n -c $SUPERVISOR_CONF_FILE
echo 'INFO: Nothing to see here, move along'