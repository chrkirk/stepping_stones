//
//  NotesViewController+UITableView.swift
//  SteppingStones
//
//  Created by Christos Kirkos on 25/05/2019.
//  Copyright © 2019 chrkirk. All rights reserved.
//

import UIKit

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NoteCell
        let note = notes[indexPath.row]
        cell.noteLabel.text = note.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        realm.moveNote(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realm.deleteNote(notes[indexPath.row])
            notes = realm.fetchAllNotes()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
