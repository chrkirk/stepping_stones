import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var index: Int = 0
}
