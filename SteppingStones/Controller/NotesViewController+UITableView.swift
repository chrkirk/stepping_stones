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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: handleCellEditing(rowAction:indexPath:))
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: handleCellDeletion(rowAction:indexPath:))
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        realmManager.moveNote(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    private func handleCellDeletion(rowAction: UITableViewRowAction, indexPath: IndexPath) -> Void {
        realmManager.deleteNote(notes[indexPath.row])
        notes = realmManager.fetchAllNotes()
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func handleCellEditing(rowAction: UITableViewRowAction, indexPath: IndexPath) -> Void {
        let note = notes[indexPath.row]
        noteCurrentlyBeingEdited = note
        inputNoteView.setText(note.text)
        inputNoteView.showOnlyUpdateButton()
        if inputNoteView.becomeFirstResponder() { inputNoteView.isHidden = false }
    }
}
