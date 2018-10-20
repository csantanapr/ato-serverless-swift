import Foundation
import Dispatch

let IMAGE_URL = "https://farm9.staticflickr.com/8636/16418099709_d76b38ac26_z_d.jpg"

//set environment variable Product->Scheme=>Edit Scheme
let WATSON_API_KEY = ProcessInfo.processInfo.environment["WATSON_API_KEY"] ?? "<API KEY MISSING>"

if WATSON_API_KEY == "<API KEY MISSING>" {
    print("!!! environment variable not setup WATSON_API_KEY_VISUAL_RECOGNITION please add in Scheme\nProduct->Scheme=>Edit Scheme")
    exit(1)
}

let inputStr = """
{
"imageUrl":"\(IMAGE_URL)",
"apiKey": "\(WATSON_API_KEY)"
}
"""
let jsonDecoder = JSONDecoder()
let jsonEncoder = JSONEncoder()
let json = inputStr.data(using: .utf8, allowLossyConversion: true)!
let testInput = try jsonDecoder.decode(Input.self, from: json)
let dispatchGroup = DispatchGroup()
dispatchGroup.enter()

//Here is the test driver to run the main function in the Action
main(param: testInput) { (out, e) in
    dump(out)
    let jsonData = try? jsonEncoder.encode(out)
    let jsonString = String(data: jsonData!, encoding: .utf8)
    print(jsonString!)
    dispatchGroup.leave()
}


//small trick to wait
let _ = dispatchGroup.wait(timeout: .distantFuture)

