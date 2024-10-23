#! /bin/bash

# NOTE: for this script to work you need to have jq installed:
#    sudo apt install jq -y

serverId= # your server ID goes here
backupId= # your backup ID goes here
apiKey="" # your API key goes here
url="https://forge.laravel.com/api/v1/servers/$serverId/backup-configs/$backupId"

timeout=10 # default timout 10 minutes
oldBackup=$((curl $url -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $apiKey" | jq '.backup.backups | last | .uuid') 2> /dev/null)

echo -n "Starting backup"
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $apiKey" $url 2> /dev/null
echo ". done"

echo -n "Waiting for backup to complete"
i=0
while [[ $i -le (6 * $timout) ]]; do
    sleep 10
    newBackup=$((curl $url -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $apiKey" | jq '.backup.backups | last | .uuid') 2> /dev/null)
    if [[ $oldBackup != $newBackup ]]; then
        echo " done"
        exit 0
    else
        echo -n "."
        ((i+=1))
    fi
done

echo -e "\nWaited $timeout minutes but the backup didn't finish.\n\nExiting."
exit 1
