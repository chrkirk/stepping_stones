import Foundation
import RealmSwift

struct RealmManager {
    
    // The arguments of the completion closures are Note instead of RealmNote
    // so that they can be used for UI purposes (outside of the background queue)
    
    static let shared = RealmManager()
    
    func createNote(text: String, completion: @escaping (Note?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let realm = try? Realm() else { return }
            
            let note = RealmNote()
            note.text = text
            note.index = realm.objects(RealmNote.self).count
            // note.dateCreated has the default value
            
            do {
                try realm.write {
                    realm.add(note)
                }
                completion(Note(text: note.text, dateCreate: note.dateCreated, index: note.index), nil)
            } catch let err {
                print("RealmManager.createNote, Unable to write Realm object:", err)
                completion(nil, err)
            }
        }
    }
    
    func updateNote(_ note: Note, withText text: String, completion: @escaping (Note?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let realm = try? Realm() else { return }
            
            guard let noteToUpdate = realm.objects(RealmNote.self).filter("index = \(note.index)").first else { return }
            
            do {
                try realm.write {
                    noteToUpdate.text = text
                }
                completion(Note(text: noteToUpdate.text, dateCreate: noteToUpdate.dateCreated, index: noteToUpdate.index), nil)
            } catch let err {
                print("RealmManager.updateNote, Unable to write Realm object:", err)
                completion(nil, err)
            }
        }
    }
    
    func moveNote(from fromIndex: Int, to toIndex: Int, completion: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if fromIndex == toIndex {
                return
            }
            
            guard let realm = try? Realm() else { return }
            
            var results = [RealmNote]()
            realm.objects(RealmNote.self).sorted(byKeyPath: "index").forEach { results.append($0) }
            
            let movedNote = results[fromIndex]
            results.remove(at: fromIndex)
            results.insert(movedNote, at: toIndex)
            
            do {
                try realm.write {
                    for (index, note) in results.enumerated() {
                        note.index = index
                    }
                }
                completion(nil)
            } catch let err{
                print("RealmManager.moveNote, Unable to write Realm object:", err)
                completion(err)
            }
        }
    }
    
    func deleteNote(_ note: Note, completion: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let realm = try? Realm() else { return }
            
            let noteToDelete = realm.objects(RealmNote.self).filter("index = \(note.index)")
            
            do {
                try realm.write {
                    realm.delete(noteToDelete)
                }
                completion(nil)
            } catch let err {
                print("RealmManager.deleteNote, Unable to delete note :", err)
                completion(err)
            }
        }
    }
    
    func fetchAllNotes(completion: @escaping ([Note]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let realm = try? Realm() else {
                completion([])
                return
            }
            
            let results = realm.objects(RealmNote.self).sorted(byKeyPath: "index")
            
            var notes = [Note]()
            results.forEach { notes.append(Note(text: $0.text, dateCreate: $0.dateCreated, index: $0.index)) }
            completion(notes)
        }
    }
    
    func deleteAllNotes(completion: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let realm = try? Realm() else { return }
            
            do {
                try realm.write {
                    realm.deleteAll()
                }
                completion(nil)
            } catch let err {
                print("RealmManager.deleteAllNotes, Unable to remove all notes :", err)
                completion(err)
            }
        }
    }
}
