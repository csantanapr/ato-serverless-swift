import VisualRecognitionV3

struct Input: Decodable {
    let imageUrl: String?
    let apiKey: String?
    let __bx_creds: WatsonCredentials?
}

struct Output: Encodable {
    let body: RecognitionTags
}

func main(param: Input, completion: @escaping (Output?, Error?) -> Void) -> Void {
    // set up visual recogntiion sdk
    let apiKey: String = param.apiKey ?? (param.__bx_creds?.watson_vision_combined.apikey)!
    let imageUrl: String = param.imageUrl ?? defaultImage
    let visualRecognition = VisualRecognition(version: "2018-10-19", apiKey: apiKey)
    let failure = { (error: Error) in print("err",error) }
    
    // make call to visual recognition classify function
    visualRecognition.classify(url: imageUrl, failure: failure) { classifiedImages in
        let image = classifiedImages.images.first
        let classifier = image?.classifiers.first
        let classes = classifier?.classes
        var resultTags = [RecognitionTag]()
        for theclass in classes! {
            resultTags.append(RecognitionTag(name:theclass.className, score:theclass.score ?? 0))
        }
        let result = Output(body: RecognitionTags(tags: resultTags))
        completion(result, nil)
    }
}





struct WatsonCredentials: Decodable {
    struct Credentials: Decodable {
        let apikey: String
    }
    let watson_vision_combined: Credentials
    enum CodingKeys: String, CodingKey
    {
        case watson_vision_combined = "watson-vision-combined"
    }
}

struct RecognitionTag: Encodable {
    let name: String
    let score: Double
}
struct RecognitionTags: Encodable {
    let tags: [RecognitionTag]
}

let defaultImage = "https://farm9.staticflickr.com/8636/16418099709_d76b38ac26_z_d.jpg"

