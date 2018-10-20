# All Things Open 2018 - Serverless Swift Demo Code usign Apache OpenWhisk on IBM Cloud Functions

This is a simple example using Swift to build a Serverless Application that leverages IBM Watson Visual Recognition.

# Prerequisites

- Get a free account for [IBM Cloud Functions](https://console.bluemix.net), there is a free montly tier of 400GBs

- Install the [IBM Cloud CLI](https://console.bluemix.net/docs/cli/reference/bluemix_cli/download_cli.html) and setup the [IBM Cloud Functions Plugin](https://console.bluemix.net/openwhisk/learn/cli)

- Setup a new [Watson Recognition Service](https://console.bluemix.net/catalog/services/visual-recognition) from the Catalog

- Install [jq](https://stedolan.github.io/jq/) (brew install jq)

# Deploy
Run the `deploy.sh` script
```
./deploy.sh
```

# Test
Invoke the deployed action using `curl` to call the Web API
```
./test.sh
```

# Use XCode to Develop and Debug
Make sure swift CLI is setup correctly with Swift 4.1 or 4.2
```
cd actions/GetClassifier/
swift build
```
Generate an XCode project using Swift Package Manager (spm)
```
swift package generate generate-xcodeproj
```

## Using XCode project
Open the new Xcode project
```
open ./Action.xcodeproj
```

Open the [Sources/main.swift](actions/GetClassifier/Sources/Action/main.swift) file this file will allow you to run the Action locally and be able to debug the function in the Action.
Set the environment variable `WATSON_API_KEY` in XCode Product->Scheme=>Edit Scheme you can get the value from the IBM Cloud Console in the Watson Recognition Service instance you created.

The file `main.swift` is only to be use for debugging locally, the file `GetClassifier.swift` is the file that contains the Action code that gets deployed to the cloud.

#### LICENSE
[Apache-2.0](./LICENSE.txt)
