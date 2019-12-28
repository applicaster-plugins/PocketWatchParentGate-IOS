//
//  VerticalAlignLabel.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 28.12.2019.
//

import Foundation

enum VerticalAlignment {
    case top
    case middle
    case bottom
}

class VerticalAlignLabel: UILabel {
    
    var verticalAlignment : VerticalAlignment = .middle {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.size.width - rect.size.width, y: bounds.origin.y, width: bounds.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: bounds.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: bounds.size.width, height: rect.size.height)
            }
        } else {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: bounds.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: bounds.size.width, height: rect.size.height)
            }
        }
    }
    
    override public func drawText(in rect: CGRect) {
        let rect = textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: rect)
    }
}
