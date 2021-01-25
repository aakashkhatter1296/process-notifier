# Usage : . ./notifier.sh -s "Success message" -f "Failure message"
# 
# Usage inside .zshrc or .bashrc :
# notifier ()
# {
#   . <path to script> $*
# }

#!/bin/bash 

# # Important: Keep this as the first command in the script
# Store the status of last command i.e. whether it ran successfully or not.
# This status value is by convention 0 on success or an integer in the range 1 - 255 on error
lastCommandStatus=$?

# Store postman webhook url
postmanWebhookUrl="<Add your postman webhook url here>";
# Store communication channels. By default all the supported channels are added. You can remove whatever channel you don't need.
channels="[\"slack\", \"push\", \"email\"]"

# Store default values for success and failure messages
s=${s:-Process succeeded ✅}
f=${f:-Process failed ❌}

# Parsing of user input and storing them
while [ $# -gt 0 ]; do
   if [[ $1 == *"-"* ]]; then
        param="${1/-/}"
        declare $param="$2"
   fi
  shift
done

# Command run before this script failed
if (( lastCommandStatus )); then
  message=$f
  processStatus="failure"
# Command run before this script succeeded
else
  message=$s
  processStatus="success"
fi

# Send request to postman webhook with the message, process status and the channels to notify
curl --location --request POST $postmanWebhookUrl \
--header 'Content-Type: application/json' \
--data-raw '{
    "message": "'"$message"'",
    "channels": '"$channels"',
    "status": "'"$processStatus"'"
}'