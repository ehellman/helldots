#!/bin/bash

logger() {
  local message="[chezmoiscript:$0] $1"
  
  # Always echo to stdout
  echo "$message"
}

logger "allowing zen browser to use 1password integration"

ensure_owner() {
  local file="$1"
  local desired_owner="$2"

  # get file/dir owner
  owner=$(stat -c "%U" "$file")

  # check if ownership is correct
  if [ "$owner" != "$desired_owner" ]; then
    logger "$file is not owned by $desired_owner"
    sudo chown "$desired_owner:$desired_owner" "$file"
    logger "adjusted ownership for $file to $desired_owner:$desired_owner"
  else
    logger "$file already owned by $desired_owner"
  fi
}

ensure_permissions() {
  local file="$1"
  local desired_permissions="$2"

  # get numeric file/folder permissions
  permissions=$(stat -c "%a" "$file")

  # check if permissions match the expected permissions
  if [ "$permissions" -ne "$desired_permissions" ]; then
    logger "$file does not have $desired_permissions permissions."
    sudo chmod "$desired_permissions" "$file"
    logger "adjusted permissions for $file to $desired_permissions"
  else
    logger "$file already has the correct permissions ($desired_permissions)."
  fi
}

folder_path="/etc/1password"
file_name="custom_allowed_browsers"
full_path="$folder_path/$file_name"

if [ ! -d "$folder_path" ]; then
  logger "creating $folder_path"
  sudo mkdir "$folder_path" 
else
  logger "$folder_path already exists, verifying permissions and ownership"

  ensure_owner "$folder_path" "root"
  ensure_permissions "$folder_path" 0755
fi

if [ -f "$full_path" ]; then
  logger "$full_path already exists, verifying permissions and ownership"
  ensure_owner "$full_path" "root"
  ensure_permissions "$full_path" 0644
else
  sudo touch $full_path 
  ensure_permissions "$full_path" 0644
fi

if ! grep -Fxq "zen-bin" "$full_path"; then
  logger "adding zen-bin to $full_path"
  echo "zen-bin" | sudo tee -a $full_path > /dev/null
else
  logger "zen-bin already exists in $full_path"
fi

logger "1password integration for zen browser completed successfully"

# reset sudo timeout
sudo -k

