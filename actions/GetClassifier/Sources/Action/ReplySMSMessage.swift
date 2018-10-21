
import Foundation

struct TwimlHeaders: Encodable {
    let content_type = "application/xml"
    enum CodingKeys: String, CodingKey {
        case content_type = "content-type"
    }
}
struct TwimlOutput: Encodable {
    let body: String
    let headers = TwimlHeaders()
}
func replySMSMessage(param: ImageTags, completion: @escaping (TwimlOutput?, Error?) -> Void) {
    let petDetected = param.body?.tags[0].name  ?? "no pet found"
    let petImage: String = param.body?.imageUrl ?? "no image"
    let petFound = lookupPet(pet: petDetected)
    let body = getBodyMessage(body: petFound, media: petImage)
    let twimlM = TwimlOutput(body: body)
    completion(twimlM, nil)
}

func lookupPet(pet:String) -> String {
    return pet
}



func getBodyMessage(body: String, media: String) -> String {
    let body = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Response>
    <Message>
    <Body>\(body)</Body>
    <Media>\(media)</Media>
    </Message>
    </Response>
    """
    return body
}

struct ImageTags: Codable {
    struct RecognitionTags: Codable {
        struct RecognitionTag: Codable {
            let name: String
            let score: Double?
        }
        let tags: [RecognitionTag]
        let imageUrl : String
    }
    let body: RecognitionTags?
}

