import Dispatch
import Foundation

let jsonDecoder = JSONDecoder()
let jsonEncoder = JSONEncoder()
func checkEnvVar(env: String) -> String {
    if ProcessInfo.processInfo.environment[env] == nil {
        print("!!! environment variable not setup SMS_ACCOUNT_ID please add in Scheme\nProduct->Scheme=>Edit Scheme")
        exit(1)
    }
    return ProcessInfo.processInfo.environment[env]!
}

func fromJSON<T: Decodable>(inputStr: String, type: T.Type) throws -> T {
    let json = inputStr.data(using: .utf8, allowLossyConversion: true)!
    let decoded = try jsonDecoder.decode(type, from: json)
    return decoded
}

let dispatchGroup = DispatchGroup()

/*** Visual Recognition ***/
let WATSON_API_KEY = checkEnvVar(env: "WATSON_API_KEY")
let IMAGE_URL = "https://farm9.staticflickr.com/8636/16418099709_d76b38ac26_z_d.jpg"
let inputStr = """
{
"imageUrl":"\(IMAGE_URL)",
"apiKey": "\(WATSON_API_KEY)"
}
"""
let inputVisualRecognition = try fromJSON(inputStr: inputStr, type: Input.self)
dispatchGroup.enter()
classifyImage(param: inputVisualRecognition) { out, _ in
    dump(out)
    let jsonData = try? jsonEncoder.encode(out)
    let jsonString = String(data: jsonData!, encoding: .utf8)
    print(jsonString!)
    dispatchGroup.leave()
}

_ = dispatchGroup.wait(timeout: .distantFuture)

/*** SMS Action Debug ***/

let SMS_ACCOUNT_ID = checkEnvVar(env: "SMS_ACCOUNT_ID")
let SMS_AUTH_TOKEN = checkEnvVar(env: "SMS_AUTH_TOKEN")
let SMS_FROM_NUMBER = checkEnvVar(env: "SMS_FROM_NUMBER")
let SMS_TO_NUMBER = checkEnvVar(env: "SMS_TO_NUMBER")
let inputSMSStr = """
{
"accountSID":"\(SMS_ACCOUNT_ID)",
"authToken":"\(SMS_AUTH_TOKEN)",
"fromNumber":"\(SMS_FROM_NUMBER)",
"toNumber":"\(SMS_TO_NUMBER)",
"message":"testing openwhisk",
}
"""
let inputSMS = try fromJSON(inputStr: inputSMSStr, type: SMSInput.self)
dispatchGroup.enter()
postSMSMessage(param: inputSMS) { out, _ in
    dump(out)
    let jsonData = try? jsonEncoder.encode(out)
    let jsonString = String(data: jsonData!, encoding: .utf8)
    print(jsonString!)
    dispatchGroup.leave()
}

// small trick to wait
_ = dispatchGroup.wait(timeout: .distantFuture)
