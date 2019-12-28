//
//  PrivacyViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 28.12.2019.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleButton: UILabel!
    @IBOutlet weak var privacyLabel: VerticalAlignLabel!
    
    @IBOutlet weak var titleTopToParentConstraint: NSLayoutConstraint!
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
}

extension PrivacyViewController {
    
    private func setupLayout() {
        privacyLabel.verticalAlignment = .top
        
        if #available(iOS 13, *) {
            closeButton.isHidden = true
            titleTopToParentConstraint.isActive = true
        } else {
            titleTopToParentConstraint.isActive = false
            
            let views: [String: Any] = [
                "closeButton": closeButton!,
                "titleButton": titleButton!
            ]
            
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:[closeButton]-(8)-[titleButton]",
                    metrics: nil,
                    views: views
                )
            )
        }
    }
}
