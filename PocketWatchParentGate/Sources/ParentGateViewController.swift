//
//  ParentGateViewController.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 21.12.2019.
//

import UIKit

class ParentGateViewController: UIViewController {
    
    var completion: (() -> Void)?
    
    private var popupRouter: PopupRouter?
    
    private lazy var bundle: Bundle = {
        return Bundle(for: PocketWatchParentGate.self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFonts()
        setupLayout()
        setupPopupRouter()
    }
}

extension ParentGateViewController {
    
    private func setupFonts() {
        UIFont.registerFont(withFilenameString: "Metropolis-Bold.otf", bundle: bundle)
        UIFont.registerFont(withFilenameString: "Metropolis-Medium.otf", bundle: bundle)
        UIFont.registerFont(withFilenameString: "Metropolis-Regular.otf", bundle: bundle)
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
                        
        let backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "parent_lock_background_image", in: bundle, compatibleWith: nil)
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
        popupRouter = StartupPopupRouter(rootViewController: self, bundle: bundle)
        popupRouter?.present(with: .questions)
        popupRouter?.completion = { [weak self] in
            self?.dismiss(animated: true, completion: self?.completion)
        }
    }
}
