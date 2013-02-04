#!/bin/bash
#
# Copyright (C) 2012 stepping stone GmbH
#                    Switzerland
#                    http://www.stepping-stone.ch
#                    info@stepping-stone.ch
#
# Authors:
#  Michael Eichenberger <michael.eichenberger@stepping-stone.ch>
#  
# Licensed under the EUPL, Version 1.1
# You may not use this work except in compliance with the
# Licence.
# You may obtain a copy of the Licence at:
#
# http://www.osor.eu/eupl
#
# Unless required by applicable law or agreed to in
# writing, software distributed under the Licence is
# distributed on an "AS IS" basis,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied.
# See the Licence for the specific language governing
# permissions and limitations under the Licence.
#
# 
#
#
###################################################################################################
# /usr/local/scripts/ldap/bin/restoreOpenLDAPmaster.sh
###################################################################################################
# Description:
#  This script restores the OpenLDAP master from the backup.ldif file, which was created with
#  the script /usr/local/scripts/ldap/makeOpenLDAPmasterBackup.sh.
#
#  USE WITH CARE!
#
###################################################################################################

# Some variable definitions
BACKUP_DIRECTORY="/var/backup/ldap"

# List all machines that have an openldap backup
echo ""
echo "The following machines have an existing OpenLDAP backup:"
echo "###################################################################################################"
ls -al $BACKUP_DIRECTORY

# Some cli comments
echo ""
echo "Please enter the machine from which you want to restore from: " 
read FQDN

BACKUP_DIRECTORY="/var/backup/ldap/${FQDN}"

# List the current backups
echo ""
echo "The following OpenLDAP backups exist:"
echo "###################################################################################################"
ls -al $BACKUP_DIRECTORY

# Some cli comments
echo ""
echo "Please enter the date of the backup to restore in the form of YYYY-DD-MM (for example: 2007-10-15):" 
read BACKUP_DATE

# Check if the backup file exists and is readable
if [ ! -r $BACKUP_DIRECTORY/OpenLDAPmasterBackup.ldif.${BACKUP_DATE} ]
then
  echo ""
  echo "Oooop, the backup file $BACKUP_DIRECTORY/OpenLDAPmasterBackup.ldif.${BACKUP_DATE} does not exist. Quitting."
  exit
fi


# Before removing als hdb-backend related directories, we need to sure, that slapd is not running.
if [ -z "$(pgrep slapd)" ]
  then
    echo ""
    echo "slapd is not running, doing nothing."
    echo "###################################################################################################"
  else
    echo ""
    echo "slapd is running, trying to stop the daemon."
    echo "###################################################################################################"
    /etc/init.d/slapd stop
    /etc/init.d/slapd zap
    if [ -z "$(pgrep slapd)" ]
      then
        echo "slapd was successfully stopped."
      else
        echo ""
        echo "slapd is still running, trying to kill all remaining processes."
        killall -9 /usr/lib64/openldap/slapd
    fi
fi

echo ""
echo "Wait for five seconds ..."
echo "###################################################################################################"
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
echo "."

echo ""
echo "Removing all the OpenLDAP database subdirectories in the directory /var/lib/openldap-hdb/ ..."
echo "###################################################################################################"
echo "rm -rf /var/lib/openldap-hdb/*"
rm -rf /var/lib/openldap-hdb/*

# Create the necessary directories and set the proper permissions.
/usr/local/bin/createDirectoryStructureDIT.sh

echo ""
echo "Trying to restore the OpenLDAP server ..."
echo "###################################################################################################"
/usr/sbin/slapadd -l ${BACKUP_DIRECTORY}/OpenLDAPmasterBackup.ldif.${BACKUP_DATE}

echo ""
echo "Recreating the indices on the OpenLDAP server ..."
echo "###################################################################################################"
/usr/sbin/slapindex 

echo ""
echo "Changing the ownership of the database subdirectories in the directory /var/lib/openldap-hdb/ ..."
echo "###################################################################################################"
chown -R ldap:ldap /var/lib/openldap-hdb/

echo ""
echo "Changing the permissions of the database subdirectories in the directory /var/lib/openldap-hdb/ ..."
echo "###################################################################################################"
chmod -R 700 /var/lib/openldap-hdb/

echo ""
echo "Trying to restart the OpenLDAP server ..."
echo "###################################################################################################"
/etc/init.d/slapd start

echo ""
echo "Wait for five seconds ..."
echo "###################################################################################################"
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
echo -n "."
sleep 1
echo "."
