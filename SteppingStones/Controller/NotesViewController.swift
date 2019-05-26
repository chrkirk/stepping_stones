import UIKit

class NotesViewController: UIViewController, InputViewDelegate {
    
    var realmManager: RealmManager!
    
    var notes = [Note]()
    
    var noteCurrentlyBeingEdited: Note?

    let cellID = "cellID"
    
    let tableView = UITableView(frame: .zero)
    
    // the inputNoteView appears and sticks on top of the keyboard when the add button gets pressed
    // that is why we need a variable to change its bottomAchor when that happens
    let inputNoteView = InputView()
    
    var inputNoteViewBottomAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: cellID)
        
        inputNoteView.delegate = self
        inputNoteView.showOnlySubmitButton()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditingMode))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toggleKeyboard))
        
        registerForKeyboardNotifications()
        setupViews()
        
        // initialize the table content by fetching everything from the database
        notes = realmManager.fetchAllNotes()
    }
    
    private func setupViews() {
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.addSubview(inputNoteView)
        inputNoteView.translatesAutoresizingMaskIntoConstraints = false
        inputNoteView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        inputNoteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        inputNoteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        inputNoteViewBottomAnchor = inputNoteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        inputNoteViewBottomAnchor.isActive = true
        
        inputNoteView.backgroundColor = .white
        inputNoteView.isHidden = true
    }
    
    @objc private func toggleEditingMode() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            view.layoutIfNeeded()
        } else {
            tableView.setEditing(true, animated: true)
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - Keyboard handling
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func toggleKeyboard() {
        if inputNoteView.isFirstResponder {
            // hide keyboard and input view
            if inputNoteView.resignFirstResponder() { inputNoteView.isHidden = true }
        } else {
            // show keyboard and input view
            if inputNoteView.becomeFirstResponder() { inputNoteView.isHidden = false }
        }
    }
    
    @objc private func handleKeyboard(_ notification: NSNotification) {
        let info: [AnyHashable:Any]! = notification.userInfo
        
        /* We want to have the inputTextField stick on top of the keyboard, to do that we need:
         * - the top position of the keyboard (we get that through the keyboard's height)
         * - the animation of the keyboard
         * - the animation timing function (animation curve)
         */
        let keyboardHeight: CGFloat = {
            let kbRect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            return kbRect.height
        }()
        
        let keyboardAnimationDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardAnimationCurve = UIView.AnimationOptions(rawValue: info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt)
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            inputNoteViewBottomAnchor.isActive = false
            inputNoteViewBottomAnchor = inputNoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight)
            inputNoteViewBottomAnchor.isActive = true
            
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: keyboardAnimationCurve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            inputNoteViewBottomAnchor.isActive = false
            inputNoteViewBottomAnchor = inputNoteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            inputNoteViewBottomAnchor.isActive = true
            
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: keyboardAnimationCurve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    // MARK: - InputViewDelegate
    func didPressSubmit() {
        guard let text = inputNoteView.textView.text, !text.isEmpty else { return }
        
        if let newNote = realmManager.createNote(text: text) {
            notes = realmManager.fetchAllNotes()
            let indexPath = IndexPath(row: newNote.index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        inputNoteView.setText("")
        toggleKeyboard()
    }
    
    func didPressUpdate() {
        guard let text = inputNoteView.textView.text, !text.isEmpty else { return }
        if let note = noteCurrentlyBeingEdited {
            realmManager.updateNote(note, withText: text)
            
            let indexPath = IndexPath(row: note.index, section: 0)
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
        
        noteCurrentlyBeingEdited = nil
        toggleKeyboard()
        inputNoteView.showOnlySubmitButton()
    }
}
