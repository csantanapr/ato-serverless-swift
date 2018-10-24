 struct Input: Codable {
     let name: String?
 }
 struct Output: Codable {
     let body: String
 }
 func main(param: Input, completion: (Output?, Error?) -> Void) -> Void {
     let result = Output(body: "Hello \(param.name ?? "stranger")!")
     print("Log greeting:\(result.body)")
     completion(result, nil)
 }