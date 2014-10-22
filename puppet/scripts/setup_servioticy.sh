#!/bin/bash
. /opt/servioticy_scripts/env.sh

# Only should be invoked at the end of the startAll.sh script
# Must be run as root

if [ ! -f /var/log/servioticy_initialized ];
then
	echo **********************************************
	echo ***** FIRST TIME THAT YOU RUN SERVIOTICY *****
	echo *****      INTIALIZING COMPONENTS        *****
	echo **********************************************
	cd $SCRIPTS
	/bin/sh create_buckets.sh
	/bin/sh create_index.sh
	/bin/sh create_xdcr.sh
	/bin/sh create_soupdates.sh
	/bin/sh create_subscriptions.sh
	/bin/sh create_database.sh
	touch /var/log/servioticy_initialized
fi