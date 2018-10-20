#!/bin/bash

set +x

WSK_CLI="bx wsk"
SOURCE="actions/GetClassifier/Sources/Action/GetClassifier.swift"

$WSK_CLI action update get-classifier "$SOURCE" --kind swift:4.1 --web true

$WSK_CLI service bind watson-vision-combined get-classifier

#$WSK_CLI action get get-classifier