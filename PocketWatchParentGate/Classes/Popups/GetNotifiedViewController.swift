//
//  GetNotifiedViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 26.12.2019.
//

import UIKit

class GetNotifiedViewController: UIViewController {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var yesButton: HighlightableButton!
    @IBOutlet weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
}

extension GetNotifiedViewController {
    
    private func setupLayout() {
        bodyView.layer.cornerRadius = 16

        yesButton.layer.cornerRadius = 6
        yesButton.defaultColor = yesButton.backgroundColor
        yesButton.highlightedColor = UIColor.darkBlue
        
        noButton.setTitleColor(UIColor.darkBlue, for: .highlighted)
    }
}
