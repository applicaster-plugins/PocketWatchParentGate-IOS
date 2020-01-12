//
//  NotificationsViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 26.12.2019.
//

import UIKit

class WarningViewController: UIViewController {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var okButton: HighlightableButton!
    @IBOutlet weak var enableButton: UIButton!
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        okCompletion?()
    }
    
    @IBAction func enableButtonAction(_ sender: UIButton) {
        enableCompletion?()
    }
    
    var okCompletion: (() -> Void)?
    var enableCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
}

extension WarningViewController {
    
    private func setupLayout() {
        bodyView.layer.cornerRadius = 16

        okButton.layer.cornerRadius = 6
        okButton.defaultColor = okButton.backgroundColor
        okButton.highlightedColor = UIColor.darkBlue
        
        enableButton.setTitleColor(UIColor.darkBlue, for: .highlighted)
    }
}
