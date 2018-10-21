import Foundation

struct SMSInput: Decodable {
    let accountSID: String
    let authToken: String
    let fromNumber: String
    let toNumber: String
    let message: String
}

struct SMSOutput: Encodable {
    let body: SMSResponse
}

func postSMSMessage(param: SMSInput, completion: @escaping (SMSOutput?, Error?) -> Void) {
    let parameters = ["From": param.fromNumber,
                      "To": param.toNumber,
                      "Body": param.message]
    httpRequest(method: "POST",
                url: "https://api.twilio.com/2010-04-01/Accounts/\(param.accountSID)/Messages.json",
                parameters: parameters,
                username: param.accountSID,
                password: param.authToken) { resp, error in
        completion(resp, error)
    }
}






















func httpRequest(method: String,
                 url: String,
                 parameters: [String: String],
                 username: String,
                 password: String,
                 completion: @escaping (SMSOutput?, Error?) -> Void) {
    let apiKey = "\(username):\(password)"
    let loginData: Data = apiKey.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    let base64EncodedAuthKey = loginData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = method
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.addValue("Basic \(base64EncodedAuthKey)", forHTTPHeaderField: "Authorization")
    var parameterBody = ""
    for (key, value) in parameters {
        let p = "\(key)=\(percentEscapeString(value))"
        parameterBody = parameterBody == "" ? p : parameterBody + "&" + p
    }
    request.httpBody = parameterBody.data(using: String.Encoding.utf8)
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let task = session.dataTask(with: request, completionHandler: { data, _, error -> Void in
        if let error = error {
            completion(nil, error)
        } else {
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let postResponse = try decoder.decode(SMSResponse.self, from: data)
                    completion(SMSOutput(body: postResponse), nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    })
    task.resume()
}

struct SMSResponse: Codable {
    let sid: String?
}

func percentEscapeString(_ string: String) -> String {
    var characterSet = CharacterSet.alphanumerics
    characterSet.insert(charactersIn: "-._* ")
    return string
        .addingPercentEncoding(withAllowedCharacters: characterSet)!
        .replacingOccurrences(of: " ", with: "+")
}
