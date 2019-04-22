import Foundation

struct Note: Equatable, Codable {
    let text: String
    let dateCreated: Date
    
    // used when saving the Note to an archive
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(text: String, date: Date) {
        self.text = text
        self.dateCreated = date
    }
    
    // initializes a Note when reading data from an archive
    init?(json: Data) {
        if let note = try? JSONDecoder().decode(Note.self, from: json) {
            self = note
        } else {
            return nil
        }
    }
}
