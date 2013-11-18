#!/bin/bash
#
# Copyright (C) 2012 FOSS-Group
#                    Germany
#                    http://www.foss-group.de
#                    support@foss-group.de
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
# https://joinup.ec.europa.eu/software/page/eupl
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
# /usr/local/bin/makeOpenLDAPmasterBackup.sh
###################################################################################################
# Description:
#  This script makes a backup of the running OpenLDAP master.
###################################################################################################

# Get the current date and store in the variable CURRENT_DATE in the form of "2007-10-15".
CURRENT_DATE=`date +%Y-%m-%d`

# Get the fully qualified domain name (FQDN) and store it in the variable FQDN int the form of <hostname>.<domain>.tld
FQDN=`hostname --fqdn`

# Some variable definitions
BACKUP_DIRECTORY="/var/backup/ldap/${FQDN}"

# Make sure the backup directory exists
if [ -d $BACKUP_DIRECTORY ]; then
  echo ""
  echo "Backup directory $BACKUP_DIRECTORY exists"
  echo "###################################################################################################"
else
  echo "Backup directory $BACKUP_DIRECTORY does not exist, creating it ..."
  echo "###################################################################################################"
  echo "mkdir -p $BACKUP_DIRECTORY"
  mkdir -p $BACKUP_DIRECTORY
fi

# Remove backups older than 15 days.
echo ""
echo "Removing backups older than 15 days ..."
echo "###################################################################################################"
echo "find ${BACKUP_DIRECTORY} -type f -ctime +15 -exec rm {} \; >/dev/null"
find ${BACKUP_DIRECTORY} -type f -ctime +15 -exec rm {} \; >/dev/null

echo ""
echo "Backup Started"
echo "###################################################################################################"

# Create the Backup File.
echo ""
echo "Executing touch ${BACKUP_DIRECTORY}/OpenLDAPmasterBackup.ldif.${CURRENT_DATE}"
echo "###################################################################################################"
touch ${BACKUP_DIRECTORY}/OpenLDAPmasterBackup.ldif.${CURRENT_DATE}

# Set the proper permissions on the backup file.
echo ""
echo "Executing chmod 600 ${BACKUP_DIRECTORY}/OpenLDAPmasterBackup.ldif.${CURRENT_DATE}"
echo "###################################################################################################"
chmod 600 ${BACKUP_DIRECTORY}/OpenLDAPmasterBackup.ldif.${CURRENT_DATE}

# -l ldif-file: Write LDIF to specified file instead of standard output.
echo ""
echo "Executing /usr/sbin/slapcat -l ${BACKUP_DIRECTORY}/OpenLDAPmasterBackup.ldif.${CURRENT_DATE}"
echo "###################################################################################################"
/usr/sbin/slapcat -l ${BACKUP_DIRECTORY}/OpenLDAPmasterBackup.ldif.${CURRENT_DATE}

echo ""
echo "Backup Finished"
echo "###################################################################################################"

echo ""
echo "You can look at the backup file with:"
echo "vi ${BACKUP_DIRECTORY}/OpenLDAPmasterBackup.ldif.${CURRENT_DATE}"
