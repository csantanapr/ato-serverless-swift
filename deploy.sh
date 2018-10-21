#!/bin/bash
set +x
WSK_CLI="bx wsk"

function deploy_visual_recognition {
    # Deploy visual recognition action
    SOURCE_CLASSIFIER="actions/GetClassifier/Sources/Action/GetClassifier.swift"
    $WSK_CLI action update get-classifier "$SOURCE_CLASSIFIER" --kind swift:4.1 --web true
    $WSK_CLI service bind watson-vision-combined get-classifier
    #$WSK_CLI action get get-classifier
}

function deploy_post_sms {
    source secrets.env
    # Deploy post sms message action
    SOURCE_POST_SMS="actions/GetClassifier/Sources/Action/PostSMSMessage.swift"
    $WSK_CLI action update post-sms --main postSMSMessage "$SOURCE_POST_SMS" --kind swift:4.1 --web true \
    -p accountSID "$SMS_ACCOUNT_ID" \
    -p authToken "$SMS_AUTH_TOKEN" \
    -p fromNumber "$SMS_FROM_NUMBER"
    #$WSK_CLI action get post-sms
}

deploy_visual_recognition
deploy_post_sms




