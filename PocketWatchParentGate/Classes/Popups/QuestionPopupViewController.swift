//
//  TextFieldPopupViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 23.12.2019.
//

import UIKit

class QuestionPopupViewController: UIViewController {
    
    enum State {
        case idle, error
    }
    
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textField: FlexibleInsetsTextField!
    @IBOutlet weak var noButton: HighlightableButton!
    @IBOutlet weak var submitButton: HighlightableButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var normalButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorButtonsConstraint: NSLayoutConstraint!
    
    @IBAction func noButtonAction(_ sender: UIButton) {
        noCompletion?()
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if let currentProblemItem = currentProblemItem, currentProblemItem.answer == textField.text {
            state = .idle
            submitCompletion?(textField.text)
        } else {
            state = .error
            textField.text = nil
            setupProblems()
        }
        
        updateTextField()
    }
    
    var noCompletion: (() -> Void)?
    var submitCompletion: ((String?) -> Void)?
    
    var state: State = .idle {
        didSet {
            errorLabel.isHidden = state == .idle
            
            normalButtonsConstraint.isActive = state == .idle
            errorButtonsConstraint.isActive = state == .error
        }
    }
    
    private var tapGesture: UITapGestureRecognizer?
    
    private var isTextFieldSelected: Bool = false {
        didSet {
            updateTextField()
        }
    }
    
    private var problems: [ProblemItem]? = {
        return Problems().problems
    }()
    private var currentProblemItem: ProblemItem?
                    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupProblems()
    }
}

extension QuestionPopupViewController {
    
    private func setupLayout() {
        bodyView.layer.cornerRadius = 16
        
        noButton.layer.cornerRadius = 6
        noButton.defaultColor = noButton.backgroundColor
        noButton.highlightedColor = UIColor.lightBlue
        
        submitButton.layer.cornerRadius = 6
        submitButton.defaultColor = submitButton.backgroundColor
        submitButton.highlightedColor = UIColor.darkBlue
                
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1
        isTextFieldSelected = false
        textField.textInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        textField.delegate = self
        
        state = .idle        
    }
    
    private func setupProblems() {
        guard var problems = problems, problems.count > 0 else { return }
        
        let randomIndex = Int.random(in: 0..<problems.count)
        let problemItem = problems.remove(at: randomIndex)
        currentProblemItem = problemItem
        self.problems = problems
        
        questionLabel.text = currentProblemItem?.question
    }
    
    private func updateTextField() {
        if isTextFieldSelected {
            textField.layer.borderColor = state == .idle ? UIColor.waterBlue.cgColor : UIColor.errorRed.cgColor
        } else {
            textField.layer.borderColor = state == .idle ? UIColor.darkGray.cgColor : UIColor.errorRed.cgColor
        }
    }
}

extension QuestionPopupViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isTextFieldSelected = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        self.tapGesture = tapGesture
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isTextFieldSelected = false
        
        if let tapGesture = tapGesture {
            self.view.removeGestureRecognizer(tapGesture)
            self.tapGesture = nil
        }
    }
}

extension QuestionPopupViewController {
    
    @objc private func didTap(gesture: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
