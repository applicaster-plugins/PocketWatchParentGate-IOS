//
//  ControlNotificationsViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 18.01.2020.
//

import UIKit

class ControlNotificationsViewController: UIViewController {
        
    @IBOutlet weak var notificationsSwitch: UISwitch!
        
    @IBAction func switchAction(_ sender: UISwitch) {
        popupRouter.notificationsEnabled = sender.isOn
        let parentGateViewController = ParentGateViewController(router: popupRouter)
        parentGateViewController.modalPresentationStyle = .fullScreen
        parentGateViewController.completion = { [weak parentGateViewController] in
            self.notificationsSwitch.setOn(self.popupRouter.notificationsEnabled, animated: true)
            parentGateViewController?.dismiss(animated: true, completion: nil)
        }
        present(parentGateViewController, animated: true, completion: nil)
    }
    
    var completion: (() -> Void)?
    
    private var popupRouter = NotificationsPopupRouter(bundle: Bundle(for: PocketWatchParentGate.self))

    private lazy var bundle: Bundle = {
        return Bundle(for: PocketWatchParentGate.self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwitch), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        setupSwitch()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

extension ControlNotificationsViewController {
    
    @objc private func setupSwitch() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationsSwitch.isEnabled = true
                self.notificationsSwitch.isOn = settings.authorizationStatus == .authorized
            }
        }
    }
}
