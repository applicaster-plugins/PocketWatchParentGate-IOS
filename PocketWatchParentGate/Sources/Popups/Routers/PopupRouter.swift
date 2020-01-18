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

protocol PopupRouter {
    
    var completion: (() -> Void)? { get set }
    
    init(rootViewController: UIViewController, bundle: Bundle)
    
    func present(with type: PopupType)
    
    func present(modalWith type: PopupType)
}
