#!/bin/bash
set +x

# Test using the CLI
#WSK_CLI="bx wsk"
#$WSK_CLI action invoke get-classifier -r | jq

# Get the Web Action URL
URL=$(bx wsk action get get-classifier --url | tail -1)
echo WEB Action URL=$URL

IMAGE_BIRD="https://farm6.staticflickr.com/5254/5499587391_93be1c5973_z_d.jpg"
IAMGE_DOG="https://farm9.staticflickr.com/8636/16418099709_d76b38ac26_z_d.jpg"
# Call the Web Action URL
CURL_CMD="curl -s $URL?imageUrl=$IMAGE_BIRD"
echo $CURL_CMD
$CURL_CMD | jq

