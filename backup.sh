#! /bin/bash

# REQUIRED
serverId=123456 # your server ID goes here
backupId=54321 # your backup ID goes here
apiKey="your_API_key_goes_here"

# OPTIONAL
timeout=10 # default timout 10 minutes

url="https://forge.laravel.com/api/v1/servers/$serverId/backup-configs/$backupId"
oldBackup=$((curl $url -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $apiKey" | jq '.backup.backups | last | .uuid') 2> /dev/null)

echo -n "Starting backup"
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $apiKey" $url 2> /dev/null
echo ". done"

echo -n "Waiting for backup to complete"
i=0
while (( $i <= 6*$timeout )); do
    sleep 10
    newBackup=$((curl $url -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $apiKey" | jq '.backup.backups | last | .uuid') 2> /dev/null)
    if [[ $oldBackup != $newBackup ]]; then
        echo " done"
        i=$(( 6 * $timeout + 1 )) # End the loop
    else
        echo -n "."
        (( i+=1 ))
    fi
done

if [[ $oldBackup == $newBackup ]]; then
    echo -e "\nWaited $timeout minutes but the backup didn't finish.\n"
    
    # uncomment these lines if you want the script to exit on failure
    # echo -e "\nExiting."
    # exit 1
fi
