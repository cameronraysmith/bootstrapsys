#!/bin/bash -e
#
# Copyright (C) 2013 edX <info@edx.org>
#
# Authors: Xavier Antoviaque <xavier@antoviaque.org>
#          David Baumgold <david@davidbaumgold.com>
#          Yarko Tymciurak <yarkot1@gmail.com>
#
# This software's license gives you freedom; you can copy, convey,
# propagate, redistribute and/or modify this program under the terms of
# the GNU Affero General Public License (AGPL) as published by the Free
# Software Foundation (FSF), either version 3 of the License, or (at your
# option) any later version of the AGPL published by the FSF.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero
# General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program in a file in the toplevel directory called
# "AGPLv3".  If not, see <http://www.gnu.org/licenses/>.


###############################################################################

# vagrant-provisioning.sh:
#
# Script to setup base environment on Vagrant, based on `precise64` image
# Runs ./scripts/create-dev-env.sh for the actual setup
#
# This script is run by `$ vagrant up`, see the README for further detail

on_create()
{
    # APT - Packages ##############################################################

    apt-get update
    apt-get install -y python-software-properties vim


    # Curl - No progress bar ######################################################

    [[ -f ~vagrant/.curlrc ]] || echo "silent show-error" > ~vagrant/.curlrc
    chown vagrant.vagrant ~vagrant/.curlrc


    # # SSH - Known hosts ###########################################################

    # # bootstrapsys - Development environment ###############################################

    mkdir -p /opt/bootstrapsys
    sudo -u vagrant -i bash -c "cd /opt/bootstrapsys && PROJECT_HOME=/opt/bootstrapsys ./scripts/create-dev-env.sh -ynq"

    # # Load .bashrc ################################################################

    # # Virtualenv - Always load ####################################################

    # ([[ -f ~vagrant/.bash_profile ]] && grep "edx-platform/bin/activate" ~vagrant/.bash_profile) || {
    #     echo ". /home/vagrant/.virtualenvs/edx-platform/bin/activate" >> ~vagrant/.bash_profile
    # }

    # # Directory ###################################################################

    # grep "cd /opt/edx/edx-platform" ~vagrant/.bash_profile || {
    #     echo "cd /opt/edx/edx-platform" >> ~vagrant/.bash_profile
    # }

    # Permissions
    #chown vagrant.vagrant ~vagrant/.bash_profile

    cat << EOF
==============================================================================
Success - Created your development environment!
==============================================================================

EOF
}    # End on_create() ########################################################

## only initialize / setup the development environment once:
#   we create node_modules, so that's a good test:
[[ -d $HOME/.rvm ]] || on_create
#on_create

# grab what the Vagrantfile spec'd our IP to be:
#  expecting:
#  - relevant ip on eth1;
#  - line of interest to look like:
#    inet 192.168.20.40/24 brd 192.168.20.255 scope global eth1
MY_IP=$(ip addr show dev eth1 | sed -n '/inet /{s/.*[ ]\(.*\)\/.*/\1/;p}')

cat << EOF
Connect to your virtual machine with "vagrant ssh".
Some examples you can use from your virtual machine:

See the README for more.

EOF
