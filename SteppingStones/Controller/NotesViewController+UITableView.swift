import UIKit

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NoteCell
        let note = self.notes[indexPath.row]
        cell.noteLabel.text = note.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: handleCellEditing(rowAction:indexPath:))
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: handleCellDeletion(rowAction:indexPath:))
        return [deleteAction, editAction]
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        realmManager.moveNote(from: sourceIndexPath.row, to: destinationIndexPath.row) { err in
            if let _ = err { return }
        }
    }
    
    private func handleCellDeletion(rowAction: UITableViewRowAction, indexPath: IndexPath) -> Void {
        self.realmManager.deleteNote(notes[indexPath.row]) { (err) in
            if let _ = err { return }
            self.realmManager.fetchAllNotes { savedNotes in
                self.notes = savedNotes
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }

    private func handleCellEditing(rowAction: UITableViewRowAction, indexPath: IndexPath) -> Void {
        let note = self.notes[indexPath.row]
        self.noteCurrentlyBeingEdited = note
        self.inputNoteView.setText(note.text)
        self.inputNoteView.showOnlyUpdateButton()
        if self.inputNoteView.becomeFirstResponder() { self.inputNoteView.isHidden = false }
    }
}
