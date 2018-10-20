#!/bin/bash
set +x

# Test using the CLI
WSK_CLI="bx wsk"
$WSK_CLI action invoke get-classifier -r | jq

# Get the Web Action URL
URL=$(bx wsk action get get-classifier --url | tail -1)
echo $URL

curl -s $URL | jq