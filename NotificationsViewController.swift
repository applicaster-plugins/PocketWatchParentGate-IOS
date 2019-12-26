//
//  NotificationsViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 26.12.2019.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var okButton: HighlightableButton!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
}

extension NotificationsViewController {
    
    private func setupLayout() {
        bodyView.layer.cornerRadius = 16

        okButton.layer.cornerRadius = 6
        okButton.defaultColor = okButton.backgroundColor
        okButton.highlightedColor = UIColor.darkGreen
        
        checkMarkImageView.layer.cornerRadius = checkMarkImageView.frame.size.width / 2
    }
}
