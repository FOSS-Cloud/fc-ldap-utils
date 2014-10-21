#!/bin/bash
#
# Copyright (C) 2006 - 2014 FOSS-Group
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
# /usr/local/scripts/ldap/bin/createDirectoryStructureDIT.sh
###################################################################################################
# Description:
#  This scripts checks the different *.conf files for the necessary directories and creates them
#  if they don't exist. It also sets the correct permissions.
###################################################################################################

echo ""
echo "If the hdb-backend directory doesn't exist, create it and set the correct permissions."
echo "###################################################################################################"
if [ ! -e `grep ^directory /etc/openldap/slapd.conf | sed -e "s/^directory\s*//g"` ]
then
  echo "Creating `grep ^directory /etc/openldap/slapd.conf | sed -e "s/^directory\s*//g"` with the command:"
  echo "mkdir -p `grep ^directory /etc/openldap/slapd.conf | sed -e "s/^directory\s*//g"`"
  mkdir -p `grep ^directory /etc/openldap/slapd.conf | sed -e "s/^directory\s*//g"`
  echo "Changing the ownership of the database subdirectories in the directory /var/lib/openldap-hdb/ ..."
  echo "chown -R 439:439 /var/lib/openldap-hdb/"
  chown -R 439:439 /var/lib/openldap-hdb/
  echo "Changing the permissions of the database subdirectories in the directory /var/lib/openldap-hdb/ ..."
  echo "chmod -R 700 /var/lib/openldap-hdb/"
  chmod -R 700 /var/lib/openldap-hdb/
else
  echo "The directory `grep ^directory /etc/openldap/slapd.conf | sed -e "s/^directory\s*//g"` exists, doing nothing!"
fi
