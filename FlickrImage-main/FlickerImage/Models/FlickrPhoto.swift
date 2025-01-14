import Foundation

struct FlickrPhoto: Codable {
    let title: String
    let link: String
    let description: String
    let generator: String
    let items: [Item]
}

struct Item: Codable, Identifiable, Hashable {
    let id = UUID().uuidString
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author, authorID, tags: String

    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case description, published, author
        case authorID = "author_id"
        case tags
    }
}

extension Item {
     func extractDimensions() -> (String, String) {
        let regexPattern = "<img[^>]+width=\"([0-9]+)\"[^>]+height=\"([0-9]+)\"[^>]*>"
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive) else {
            return ("No width found", "No height found")
        }
        
        let nsString = self.description as NSString
        let results = regex.matches(in: self.description, options: [], range: NSRange(location: 0, length: nsString.length))
        
        if let match = results.first {
            let widthRange = Range(match.range(at: 1), in: self.description)
            let heightRange = Range(match.range(at: 2), in: self.description)
            
            let imgWidth = widthRange.map { String(self.description[$0]) } ?? "No width found"
            let imgHeight = heightRange.map { String(self.description[$0]) } ?? "No height found"
            
            return (imgWidth, imgHeight)
        }
        
        return ("No width found", "No height found")
    }
}

// MARK: - Media
struct Media: Codable, Hashable {
    let m: String
}


