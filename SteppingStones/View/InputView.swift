import UIKit

protocol InputViewDelegate {
    func didPressSubmit()
    func didPressUpdate()
}

class InputView: UIView, UITextViewDelegate {
    
    var delegate: InputViewDelegate?
    
    let buttonWidth: CGFloat = 64
    
    let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit", for: .normal)
        return btn
    }()
    
    var submitButtonWidthConstaint: NSLayoutConstraint?
    
    let updateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Update", for: .normal)
        return btn
    }()
    
    var updateButtonWidthConstaint: NSLayoutConstraint?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.preferredFont(forTextStyle: .body)
        tv.isScrollEnabled = false
        tv.backgroundColor = UIColor(red: 1, green: 245/255, blue: 245/255, alpha: 1)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        textView.delegate = self
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [textView, submitButton, updateButton])
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        submitButtonWidthConstaint = submitButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        submitButtonWidthConstaint?.isActive = true
        
        updateButtonWidthConstaint = updateButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        updateButtonWidthConstaint?.isActive = true
    }
    
    @objc private func handleSubmit() {
        delegate?.didPressSubmit()
    }
    
    @objc private func handleUpdate() {
        delegate?.didPressUpdate()
    }
    
    func setText(_ text: String) {
        textView.text = text
        textViewDidChange(textView)
    }
    
    func showOnlySubmitButton() {
        submitButtonWidthConstaint?.isActive = false
        submitButtonWidthConstaint = submitButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        submitButtonWidthConstaint?.isActive = true
        
        updateButtonWidthConstaint?.isActive = false
        updateButtonWidthConstaint = updateButton.widthAnchor.constraint(equalToConstant: 0)
        updateButtonWidthConstaint?.isActive = true
    }
    
    func showOnlyUpdateButton() {
        submitButtonWidthConstaint?.isActive = false
        submitButtonWidthConstaint = submitButton.widthAnchor.constraint(equalToConstant: 0)
        submitButtonWidthConstaint?.isActive = true
        
        updateButtonWidthConstaint?.isActive = false
        updateButtonWidthConstaint = updateButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        updateButtonWidthConstaint?.isActive = true
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
