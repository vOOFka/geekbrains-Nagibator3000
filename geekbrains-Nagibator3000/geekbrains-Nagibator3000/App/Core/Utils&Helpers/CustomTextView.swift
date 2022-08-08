//
//  CustomTextView.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 08.08.2022.
//

import UIKit

final class CustomTextView: UITextView {
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        config()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func config() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        autocorrectionType = .no
        backgroundColor = Constants.backgroundColor
        textColor = Constants.textColor
        font = UIFont.preferredFont(forTextStyle: .body)
        layer.cornerRadius = Constants.cornerRadius
        textContainerInset = UIEdgeInsets(top: 12, left: 4, bottom: 12, right: 4)
        
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }
}

//MARK: - Constants

private enum Constants {
    static let backgroundColor = ColorScheme.white.color
    static let shadowColor = ColorScheme.raspberryRose.color.cgColor
    static let textColor = ColorScheme.fuchsiaBlue.color
    
    static let cornerRadius = 8.0
}
