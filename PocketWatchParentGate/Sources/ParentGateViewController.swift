//
//  ParentGateViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 21.12.2019.
//

import UIKit

class ParentGateViewController: UIViewController {
    
    var completion: (() -> Void)?
    
    private(set) var popupRouter: PopupRouter?
        
    init(router: PopupRouter) {
        super.init(nibName: nil, bundle: nil)

        popupRouter = router
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFonts()
        setupLayout()
        setupPopupRouter()
    }
}

extension ParentGateViewController {
    
    private func setupFonts() {
        UIFont.registerFont(withFilenameString: "Metropolis-Bold.otf", bundle: PocketWatchParentGate.bundle)
        UIFont.registerFont(withFilenameString: "Metropolis-Medium.otf", bundle: PocketWatchParentGate.bundle)
        UIFont.registerFont(withFilenameString: "Metropolis-Regular.otf", bundle: PocketWatchParentGate.bundle)
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
                        
        let backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "parent_lock_background_image", in: PocketWatchParentGate.bundle, compatibleWith: nil)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)

        let views: [String : Any] = ["backgroundImageView" : backgroundImageView]
        var allConstraints: [NSLayoutConstraint] = []

        let backgroundVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[backgroundImageView]|",
            metrics: nil,
            views: views
        )
        allConstraints += backgroundVerticalConstraints

        let backgroundHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[backgroundImageView]|",
            metrics: nil,
            views: views
        )
        allConstraints += backgroundHorizontalConstraints
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    private func setupPopupRouter() {
        popupRouter?.presentingViewController = self
        popupRouter?.present(with: nil)
        popupRouter?.completion = { [weak self] in
            self?.dismiss(animated: true, completion: self?.completion)
        }
    }
}
