//
//  NotificationsViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 26.12.2019.
//

import UIKit

class WarningViewController: UIViewController {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
}

extension WarningViewController {
    
    private func setupLayout() {
        bodyView.layer.cornerRadius = 16

        okButton.layer.cornerRadius = 6
    }
}
