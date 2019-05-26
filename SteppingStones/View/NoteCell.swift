import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var noteLabel: UILabel!

    @IBOutlet weak var noteBackgroundView: UIView!
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            noteBackgroundView.layer.cornerRadius = 10
        }
    }
}
