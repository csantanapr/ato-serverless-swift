
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
    //let petImage: String = param.body?.imageUrl ?? "no image"
    let petFound = lookupPet(pet: petDetected)
    let body = getBodyMessage(body: "\(petDetected), \(petFound.description), $\(petFound.price)", media: petFound.imageUrl)
    let twimlM = TwimlOutput(body: body)
    completion(twimlM, nil)
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


struct Pet {
    let name: String
    let description: String
    let price: Double
    let imageUrl: String
}
func lookupPet(pet:String) -> Pet {
    let petStore = buildStore()
    let petlower = pet.lowercased()
    let outOfStock = "https://csantanapr.github.io/ato-serverless-swift/images/out-off-stock.jpg"
    var thePet = Pet(name: "pet", description: "not in stock", price: 0.00, imageUrl: outOfStock)
    for e in petStore {
        if petlower.contains(e.name) {
            thePet = e
        }
    }
    return thePet
}

func buildStore() -> [Pet] {
    var petstore = [Pet]()
    let baseImageUrl = "https://csantanapr.github.io/ato-serverless-swift/images"
    petstore.append(Pet(name: "bulldog",   description: "Friendly dog from England",price: 400.99, imageUrl:"\(baseImageUrl)/bulldog.jpg"))
    petstore.append(Pet(name: "chihuahua", description: "Great companion dog",price: 250.49, imageUrl:"\(baseImageUrl)/chihuahua.jpg"))
    petstore.append(Pet(name: "finch",     description: "Great stress reliever",price: 7.99, imageUrl:"\(baseImageUrl)/finch.jpg"))
    petstore.append(Pet(name: "labrador",  description: "Great hunting dog",price: 500.49, imageUrl:"\(baseImageUrl)/labrador.jpg"))
    petstore.append(Pet(name: "macaw",     description: "Great companion for up to 75 years", price: 900.49, imageUrl:"\(baseImageUrl)/macaw.jpg"))
    petstore.append(Pet(name: "spaniel",   description: "Long, low-built bird dogs of great strength and endurance", price: 600.49, imageUrl:"\(baseImageUrl)/spaniel.jpg"))
    petstore.append(Pet(name: "terrier",   description: "Great family dog", price: 300.49, imageUrl:"\(baseImageUrl)/terrier.jpg"))
    petstore.append(Pet(name: "siberian",  description: "Playful, athletic, agile, and light on his feet", price: 800.49, imageUrl:"\(baseImageUrl)/husky.jpg"))
    petstore.append(Pet(name: "bernese",   description: "Watchdog and loyal companion", price: 100.99, imageUrl:"\(baseImageUrl)/bernese.jpg"))
    return petstore
}



