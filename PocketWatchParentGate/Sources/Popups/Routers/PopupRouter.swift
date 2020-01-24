//
//  PopupRouter.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 18.01.2020.
//

import Foundation

enum PopupType: String {
    case questions, getNotified, warning, notifications, privacy
}

struct PopupRouterConstants {
    static let disableNotificationsTitle = "Please, disable notifications manually"
    static let enableNotificationsTitle = "Please, enable notifications manually"
    static let notificationsActionTitle = "OK"
}

protocol PopupRouter {
    
    var completion: (() -> Void)? { get set }
    
    var presentingViewController: UIViewController? { get set }
    
    var initialPopupType: PopupType { get set }
    
    init(rootViewController: UIViewController?, bundle: Bundle)
    
    func present(with type: PopupType?)
    
    func present(modalWith type: PopupType?)
}

extension PopupRouter {
    
    func presentAlert(title: String?, message: String, actionTitle: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        self.presentingViewController?.present(alert, animated: true, completion: nil)
    }
}
