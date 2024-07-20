//
//  BackgroundDecorationView.swift
//  Weather
//
//  Created by 조규연 on 7/20/24.
//

import UIKit

final class BackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.contentBackgroundColor
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
