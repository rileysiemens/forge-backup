# Forge Backup

## Description
A script to trigger a DB backup in Forge. Use this is deploy scripts to back up every time you deploy. **Note:** I am not affiliated in any way with Laravel or Forge. 

## Requirements
1. A [Laravel Forge](https://forge.laravel.com/) account, with a valid [API key](https://forge.laravel.com/api-documentation#authentication)
2. A Forge managed server with `jq` and `curl` installed (if you created the server through Forge recently, it probably has both installed already.)

## How to use
Copy the contents of [backup.sh](backup.sh) to the deploy script section of Forge (also works in Envoyer). The three required variables are the server ID, the backup ID, and your [API key](https://forge.laravel.com/user-profile/api). You may optionally increase or decrease the time before this script will timeout (default is 10 minutes).

### Server ID
You can find the server ID in the upper right corner the server home page.
![image](https://github.com/user-attachments/assets/1a715eb2-b81e-49ea-a313-090a7c2eb002)

### Backup ID
After creating a DB backup in Forge, you can find its ID in parenthesis in the backup name.
![image](https://github.com/user-attachments/assets/2df62d64-668d-4791-9ec9-a70baccc9fe6)

## How it works
The script initially gets the UUID of the most recent backup file before triggering a new backup job. Then it begins polling via API calls every 10 seconds to check the UUID of the latest backup file. Once the manually triggered job is finished, the latest file UUID will be different than the initial UUID and the loop exits. If there is no change in 10 minutes (or whatever you set the timeout value), the script prints an error and continues.
