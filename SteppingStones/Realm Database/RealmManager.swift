//
//  RealmManager.swift
//  SteppingStones
//
//  Created by Christos Kirkos on 25/05/2019.
//  Copyright © 2019 chrkirk. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    static let shared = RealmManager()
    
    let realm: Realm? = {
        do {
            return try Realm()
        } catch let err {
            print("RealmManager.realm, Unable to initialize a Realm instance:", err)
            return nil
        }
    }()
    
    @discardableResult func createNote(text: String) -> Note? {
        guard let realm = self.realm else { return nil }
        
        let note = Note()
        note.text = text
        note.index = realm.objects(Note.self).count
        // note.dateCreated has the default value
        
        do {
            try realm.write {
                realm.add(note)
            }
            print("Added new note")
            return note
        } catch let err {
            print("RealmManager.createNote, Unable to write Realm object:", err)
            return nil
        }
    }
    
    @discardableResult func updateNote(_ note: Note, withText text: String) -> Note? {
        guard let realm = self.realm else { return nil }
        
        do {
            try realm.write {
                note.text = text
            }
            return note
        } catch let err {
            print("RealmManager.updateNote, Unable to write Realm object:", err)
            return nil
        }
    }
    
    func moveNote(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        guard let realm = self.realm else { return }
        
        var allNotes = fetchAllNotes()
        let movedNote = allNotes[fromIndex]
        allNotes.remove(at: fromIndex)
        allNotes.insert(movedNote, at: toIndex)
        
        do {
            try realm.write {
                for (index, note) in allNotes.enumerated() {
                    note.index = index
                }
            }
        } catch let err{
            print("RealmManager.moveNote, Unable to write Realm object:", err)
        }
    }
    
    func deleteNote(_ note: Note) {
        guard let realm = self.realm else { return }
        
        do {
            try realm.write {
                realm.delete(note)
            }
        } catch let err {
            print("RealmManager.deleteNote, Unable to delete note :", err)
        }
    }
    
    func fetchAllNotes() -> [Note] {
        guard let results = realm?.objects(Note.self).sorted(byKeyPath: "index") else { return [] }
        
        var notes = [Note]()
        results.forEach { notes.append($0) }
        return notes
    }
    
    func deleteAllNotes() {
        guard let realm = self.realm else { return }
        
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch let err {
            print("RealmManager.deleteAllNotes, Unable to remove all notes :", err)
        }
    }
}
