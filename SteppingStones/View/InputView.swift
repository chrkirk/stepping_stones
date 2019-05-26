import UIKit

protocol InputViewDelegate {
    func didPressSubmit()
    func didPressUpdate()
}

class InputView: UIView, UITextViewDelegate {
    
    var delegate: InputViewDelegate?
    
    let buttonWidth: CGFloat = 64
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var updateButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func handleSubmit() {
        delegate?.didPressSubmit()
    }
    
    @IBAction func handleUpdate() {
        delegate?.didPressUpdate()
    }
    
    func setText(_ text: String) {
        textView.text = text
        textViewDidChange(textView)
    }
    
    func showOnlySubmitButton() {
        submitButtonWidthConstraint.isActive = false
        submitButtonWidthConstraint = submitButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        submitButtonWidthConstraint.isActive = true
        
        updateButtonWidthConstraint.isActive = false
        updateButtonWidthConstraint = updateButton.widthAnchor.constraint(equalToConstant: 0)
        updateButtonWidthConstraint.isActive = true
    }
    
    func showOnlyUpdateButton() {
        submitButtonWidthConstraint.isActive = false
        submitButtonWidthConstraint = submitButton.widthAnchor.constraint(equalToConstant: 0)
        submitButtonWidthConstraint.isActive = true
        
        updateButtonWidthConstraint.isActive = false
        updateButtonWidthConstraint = updateButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        updateButtonWidthConstraint.isActive = true
    }
    
    // MARK: - Handle first responder
    // used for decide whether the keyboard should be displayed or not
    override var isFirstResponder: Bool {
        get {
            return textView.isFirstResponder
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width - 64, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
