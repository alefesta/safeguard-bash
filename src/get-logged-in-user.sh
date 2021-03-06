#!/bin/bash

print_usage()
{
    cat <<EOF
USAGE: get-logged-in-user.sh [-h]
       get-logged-in-user.sh [-v version]
       get-logged-in-user.sh [-a appliance] [-t accesstoken] [-v version]

  -h  Show help and exit
  -a  Network address of the appliance
  -t  Safeguard access token
  -v  Web API Version: 2 is default

Get the Me for information about this user via the Web API.

NOTE: Install jq to get pretty-printed JSON output.

EOF
    exit 0
}

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


Appliance=
AccessToken=
Version=2
LicenseFile=

. "$ScriptDir/utils/loginfile.sh"

require_args()
{
    require_login_args
}

while getopts ":t:a:v:h" opt; do
    case $opt in
    t)
        AccessToken=$OPTARG
        ;;
    a)
        Appliance=$OPTARG
        ;;
    v)
        Version=$OPTARG
        ;;
    h)
        print_usage
        ;;
    esac
done

require_args

$ScriptDir/invoke-safeguard-method.sh -a "$Appliance" -t "$AccessToken" -v $Version -s core -m GET -U "Me" -N

