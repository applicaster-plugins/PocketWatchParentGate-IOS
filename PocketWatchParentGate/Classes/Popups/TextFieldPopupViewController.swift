//
//  TextFieldPopupViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 23.12.2019.
//

import UIKit

class TextFieldPopupViewController: UIViewController {
    
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textField: FlexibleInsetsTextField!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var normalButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorButtonsConstraint: NSLayoutConstraint!
    
    enum State {
        case idle, error
    }

    var state: State = .idle
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
}

extension TextFieldPopupViewController {
    
    private func setupLayout() {
        bodyView.layer.cornerRadius = 16
        
        noButton.layer.cornerRadius = 6
        submitButton.layer.cornerRadius = 6
        
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1
        textField.layer.borderColor = state == .idle ? UIColor.darkGray.cgColor : UIColor.errorRed.cgColor
        textField.textInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        
        errorLabel.isHidden = state == .idle
        
        normalButtonsConstraint.isActive = state == .idle
        errorButtonsConstraint.isActive = state == .error
    }
}
