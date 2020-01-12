//
//  FlexibleInsetsTextField.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 24.12.2019.
//

import Foundation

public class FlexibleInsetsTextField: UITextField {
        
    public var textInset: UIEdgeInsets = .zero {
        didSet {
            layoutIfNeeded()
        }
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInset.left + textInset.right , dy: textInset.top + textInset.bottom)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInset.left + textInset.right , dy: textInset.top + textInset.bottom)
    }
}
