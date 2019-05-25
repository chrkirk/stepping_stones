//
//  InputView.swift
//  SteppingStones
//
//  Created by Christos Kirkos on 25/05/2019.
//  Copyright © 2019 chrkirk. All rights reserved.
//

import UIKit

protocol InputViewDelegate {
    func didPressSubmit()
}

class InputView: UIView, UITextViewDelegate {
    
    var delegate: InputViewDelegate?
    
    let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit", for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 64).isActive = true
        return btn
    }()
    
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

        let stackView = UIStackView(arrangedSubviews: [textView, submitButton])
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    @objc private func handleSubmit() {
        delegate?.didPressSubmit()
    }
    
    func setText(_ text: String) {
        textView.text = text
        textViewDidChange(textView)
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
