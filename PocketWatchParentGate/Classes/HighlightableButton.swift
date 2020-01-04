//
//  HighlightableButton.swift
//  PocketWatchParentGate
//
//  Created by Andrii Novoselskyi on 26.12.2019.
//

import Foundation

class HighlightableButton: UIButton {
    
    var defaultColor: UIColor?
    var highlightedColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            guard let highlightedColor = highlightedColor, let defaultColor = defaultColor else { return }
            backgroundColor = isHighlighted ? highlightedColor : defaultColor
        }
    }
}
