import Foundation
import Dispatch

let jsonDecoder = JSONDecoder()
let jsonEncoder = JSONEncoder()

//set environment variable Product->Scheme=>Edit Scheme
let WATSON_API_KEY_VISUAL_RECOGNITION = ProcessInfo.processInfo.environment["WATSON_API_KEY_VISUAL_RECOGNITION"] ?? "<API KEY MISSING>"

let inputStr = """
{
"imageUrl":"https://farm9.staticflickr.com/8636/16418099709_d76b38ac26_z_d.jpg",
"apiKey": "\(WATSON_API_KEY_VISUAL_RECOGNITION)"
}
"""
let json = inputStr.data(using: .utf8, allowLossyConversion: true)!
let testInput = try jsonDecoder.decode(Input.self, from: json)

let dispatchGroup = DispatchGroup()
dispatchGroup.enter()
main(param: testInput) { (out, e) in
    let jsonData = try? jsonEncoder.encode(out)
    let jsonString = String(data: jsonData!, encoding: .utf8)
    print("\(jsonString!)")
    dispatchGroup.leave()
}
//small trick to wait
let _ = dispatchGroup.wait(timeout: .distantFuture)

