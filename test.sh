#!/bin/bash
WSK_CLI="bx wsk"

function test_visual_recognition {
    # Get the Web Action URL
    local URL=$(bx wsk action get get-classifier --url | tail -1)
    echo WEB Action URL=$URL
    IMAGE_BIRD="https://farm6.staticflickr.com/5254/5499587391_93be1c5973_z_d.jpg"
    IAMGE_DOG="https://farm9.staticflickr.com/8636/16418099709_d76b38ac26_z_d.jpg"
    # Call the Web Action URL
    CURL_CMD="curl -s $URL?imageUrl=$IMAGE_BIRD"
    echo $CURL_CMD
    $CURL_CMD | jq
}

function test_post_sms {
    source secrets.env
    SMS_MESSAGE="Hello ATO!!"
    echo $WSK_CLI action invoke post-sms -p toNumber "$SMS_TO_NUMBER" -p message "\"$SMS_MESSAGE\""  -r
    $WSK_CLI action invoke post-sms -p toNumber "$SMS_TO_NUMBER" -p message "$SMS_MESSAGE"  -r | jq
    local URL=$(bx wsk action get post-sms --url | tail -1)
    echo "$URL?toNumber=$SMS_TO_NUMBER&message=hello"
}

test_visual_recognition
test_post_sms

