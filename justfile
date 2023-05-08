up:
  #!/usr/bin/env bash
  lastrun=$(gum spin --spinner dot --title "Getting latest run..." -- gh run list --workflow build.yml -L 1 --json "conclusion,databaseId,displayTitle" -q '.[0]')
  echo "Found latest run"
  status=$(echo $lastrun | jq -r '.conclusion')
  id=$(echo $lastrun | jq -r '.databaseId')
  title=$(echo $lastrun | jq -r '.displayTitle')

  gum spin --spinner dot --title "Downloading artifact..." -- gh run download $id -n firmware -D ./firmware
  echo "Downloaded artifact: $title"

  # wait until  /volumes xiao-sense mounted
  gum spin --spinner dot --title "Wait until xiao sense mounts..." -- bash -c 'while [ ! -d /Volumes/XIAO-SENSE ]; do sleep 1; done'
  echo "Xiao sense mounted, copying firmware to xiao sense..."

  cp -X ./firmware/totem_left-seeeduino_xiao_ble-zmk.uf2 /Volumes/XIAO-SENSE
  rm -rf ./firmware
  
  echo 'Done!'
