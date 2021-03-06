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
    
    @IBAction func viewPrivacyAction(_ sender: UIButton) {
        viewPrivacyCompletion?()
    }
    
    @IBAction func yesButtonAction(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self.yesCompletion?(granted)
                if (granted) {
                    PocketWatchParentGate.subscribePush()
                } else {
                    PocketWatchParentGate.unsubscribePush()
                }
            }
        }
    }
    
    @IBAction func noButtonAction(_ sender: UIButton) {
        noCompletion?()
    }
    
    var viewPrivacyCompletion: (() -> Void)?
    var yesCompletion: ((Bool) -> Void)?
    var noCompletion: (() -> Void)?

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
