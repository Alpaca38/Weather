//
//  BaseLabel.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import UIKit

class BaseLabel: UILabel {
    init(font: UIFont) {
        super.init(frame: .zero)
        self.font = font
        textColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
