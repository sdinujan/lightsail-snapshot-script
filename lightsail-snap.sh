#!/bin/bash

aws lightsail create-instance-snapshot --instance-name <SERVER NAME> --instance-snapshot-name <SERVER NAME>$(date +%Y-%m-%d-%H.%M) --profile <IAM USER NAME> --region <REGION>

#sleep 20

# Set number of snapshots you'd like to keep

snapshotsToKeep=1

# get the total number of available Lightsail snapshots

numberOfSnapshots=$(aws lightsail get-instance-snapshots --profile <IAM USER NAME> --region <REGION> | jq '.[]|length')

# get the names of all snapshots sorted from old to new

SnapshotNames=$(aws lightsail get-instance-snapshots --profile <IAM USER NAME> --region <REGION> | jq '.[] | sort_by(.createdAt) | .[].name')

# loop through all snapshots

while IFS= read -r line

do

let "i++"

# delete old snapshot condition

if (($i <= $numberOfSnapshots-$snapshotsToKeep))

then

snapshotToDelete=$(echo "$line" | tr -d '"')

# delete snapshot now

aws lightsail delete-instance-snapshot --instance-snapshot-name $snapshotToDelete --profile <IAM USER NAME> --region <REGION>

echo "Deleted Snapshot: " + $line

fi

done <<< "$SnapshotNames"

exit 1
