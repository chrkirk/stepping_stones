import UIKit

class NoteCell: UITableViewCell {

    let noteLabel = UILabel(frame: .zero)
    
    let noteBackgroundView = UIView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(noteBackgroundView)
        noteBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        noteBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        noteBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        noteBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        // Lower the priority of the bottom constaint to avoid breaking it when removing a cell from the table
        let con = noteBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        con.priority = .defaultHigh
        con.isActive = true
        
        noteBackgroundView.addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.topAnchor.constraint(equalTo: noteBackgroundView.topAnchor,  constant: 12).isActive = true
        noteLabel.bottomAnchor.constraint(equalTo: noteBackgroundView.bottomAnchor, constant: -12).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo: noteBackgroundView.leadingAnchor, constant: 12).isActive = true
        noteLabel.trailingAnchor.constraint(equalTo: noteBackgroundView.trailingAnchor, constant: -12).isActive = true
        noteLabel.numberOfLines = 0
        noteLabel.font = UIFont.preferredFont(forTextStyle: .body)
        noteLabel.adjustsFontForContentSizeCategory = true
        
        backgroundColor = .clear
        noteBackgroundView.backgroundColor = .white
        noteBackgroundView.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
