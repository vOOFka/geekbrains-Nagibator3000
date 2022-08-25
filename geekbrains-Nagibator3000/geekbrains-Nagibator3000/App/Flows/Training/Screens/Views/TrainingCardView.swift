//
//  TrainingCardView.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 25.08.2022.
//

import UIKit

final public class TrainingCardView: UIView {
    private var titleFromLabel = UILabel()
    private var titleToLabel = UILabel()
    private var fromLabel = UILabel()
    private var toLabel = UILabel()
    
    init(with text: String, translate: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 250.0, height: 400.0))
        
        self.fromLabel.text = text
        self.toLabel.text = translate
        initialConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialConfig() {
        clipsToBounds = true
        layer.cornerRadius = 30.0
        backgroundColor = Constants.raspberryRoseColor
        
        addSubview(titleFromLabel)
        addSubview(titleToLabel)
        addSubview(fromLabel)
        addSubview(toLabel)
        
        titleFromLabel.text = Constants.titleFromLabel
        titleToLabel.text = Constants.titleToLabel
        
        titleFromLabel.font = Constants.boldFont
        titleToLabel.font = Constants.boldFont
        fromLabel.font = Constants.italicFont
        toLabel.font = Constants.italicFont
        
        fromLabel.numberOfLines = 0
        toLabel.numberOfLines = 0        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        titleFromLabel.pin.top(16.0).horizontally().margin(16.0).sizeToFit(.width)
        fromLabel.pin.below(of: titleFromLabel).horizontally().margin(16.0).sizeToFit(.width)
        
        
        titleToLabel.pin.below(of: fromLabel).horizontally().margin(16.0).sizeToFit(.width)
        toLabel.pin.below(of: titleToLabel).horizontally().margin(16.0).sizeToFit(.width)
    }
}

//MARK: - Constants

private enum Constants {
    static let raspberryRoseColor = ColorScheme.raspberryRose.color
    static let whiteColor = ColorScheme.white.color
    
    static let titleFromLabel = "Text".localized
    static let titleToLabel = "Translation".localized
    
    static let boldFont = UIFont.boldSystemFont(ofSize: 16.0)
    static let italicFont = UIFont.italicSystemFont(ofSize: 14.0)
}
