import Foundation

// This is a singleton class, responsible for saving the notes to an archive
class NoteStore {
    
    static let sharedInstance = NoteStore()
    
    var allNotes = [Note]()
    
    let url: URL?
    
    // finds existing archive or creates a new one
    private init() {
        url = {
            if var url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
                url.appendPathComponent("notes.json")
                return url
            }
            return nil
        }()
        if let url = url, let jsonData = try? Data(contentsOf: url) {
            allNotes = try! JSONDecoder().decode([Note].self, from: jsonData)
            print("NoteStore.init: successful")
        }
    }
    
    // MARK: - Mutating the allNotes instance variable
    @discardableResult func createNote(withText text: String) -> Note {
        let newNote =  Note(text: text, date: Date())
        allNotes.append(newNote)
        return newNote
    }
    
    func moveNote(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let movedNote = allNotes[fromIndex]
        allNotes.remove(at: fromIndex)
        allNotes.insert(movedNote, at: toIndex)
    }
    
    func removeNote(_ note: Note) {
        if let index = allNotes.firstIndex(of: note) {
            allNotes.remove(at: index)
        }
    }
    
    // MARK: - Saving notes to archive
    func saveTasks() {
        if let json = try? JSONEncoder().encode(allNotes), let url = url {
            do {
                try json.write(to: url)
                print("NoteStore.saveTasks: successful")
            } catch let error {
                print("NoteStore.saveTasks: \(error)")
            }
        }
    }
}
