//
//  EmptyStateView.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 28.08.2022.
//

import UIKit

public final class EmptyStateView: UIView {
    private(set) var addButton = UIButton()
    private var emptyLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        config()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func config() {
        frame = UIScreen.main.bounds
        emptyLabel.text = Constants.emptyLabelText
        emptyLabel.font = Constants.boldFont
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        
        addButton.setTitle(Constants.titleAddButton, for: .normal)
        addButton.backgroundColor = Constants.blueColor
        addButton.setTitleColor(Constants.whiteColor, for: .normal)
        addButton.layer.cornerRadius = 6.0
        addButton.clipsToBounds = true

        
        addSubview(emptyLabel)
        addSubview(addButton)

        emptyLabel.pin.vCenter(-50.0).horizontally(20.0).sizeToFit(.width)
        addButton.pin.below(of: emptyLabel, aligned: .center).height(44.0).width(emptyLabel.frame.width * 0.7).margin(20.0)
        
        isHidden = true
    }
}

//MARK: - Constants

private enum Constants {
  static let emptyLabelText = "Your dictionary is empty, add words and come back!".localized
  static let titleAddButton = "Add".localized
  
  static let whiteColor = ColorScheme.white.color
  static let blueColor = ColorScheme.fuchsiaBlue.color
  
  static let boldFont = UIFont.boldSystemFont(ofSize: 20.0)
}
