#!/bin/bash
set +x

WSK_CLI=${WSK_CLI:-bx wsk}

echo Using CLI $WSK_CLI

function deploy_visual_recognition {
    SOURCE_CLASSIFIER="actions/GetClassifier/Sources/Action/GetClassifier.swift"
    $WSK_CLI action update get-classifier --main classifyImage "$SOURCE_CLASSIFIER" --kind swift:4.1 --web true
    if [ "$WSK_CLI" = "bx wsk" ]; then
        $WSK_CLI service bind watson-vision-combined get-classifier
    else
        $WSK_CLI action update get-classifier -p apiKey "$WATSON_VISUAL_RECOGNITION_IAM_API_KEY"
    fi

}

function deploy_reply_sms {
    SOURCE_REPLY_SMS="actions/GetClassifier/Sources/Action/ReplySMSMessage.swift"
    $WSK_CLI action update reply-sms --main replySMSMessage  "$SOURCE_REPLY_SMS" --kind swift:4.1 --web true
}

function deploy_sequence {
   $WSK_CLI action update pet-store-webhook --sequence get-classifier,reply-sms --web true
   $WSK_CLI action get pet-store-webhook --url
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

#main functions
deploy_visual_recognition
deploy_reply_sms
deploy_sequence
# For Bonus
#deploy_post_sms




