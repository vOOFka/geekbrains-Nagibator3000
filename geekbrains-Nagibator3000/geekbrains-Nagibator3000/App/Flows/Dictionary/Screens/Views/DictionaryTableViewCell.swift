//
//  DictionaryTableViewCell.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 14.08.2022.
//

import UIKit

final class DictionaryTableViewCell: UITableViewCell {
    // MARK: - Public properties
    public static let reuseIdentifier = "DictionaryTableViewCell"
    
    // MARK: - Private properties
    private var fromLabel = UILabel()
    private var toLabel = UILabel()
    
    // MARK: - Init & Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialConfig()
    }
    
    private func initialConfig() {
        contentView.addSubview(fromLabel)
        contentView.addSubview(toLabel)
        
        layoutSubviews()
    }
    
    public func config(with model: TranslationModel) {
        fromLabel.text = Constants.titleFromLabel + " " + model.fromText
        toLabel.text = Constants.titleToLabel + " " + model.toText
    }
    
    override func prepareForReuse() {
        fromLabel.text = String()
        toLabel.text = String()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fromLabel.pin.top().horizontally().margin(20.0).sizeToFit()
        toLabel.pin.below(of: fromLabel).margin(20.0).sizeToFit()
        
        contentView.pin.height(toLabel.frame.maxY + 12.0)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutSubviews()
        return CGSize(width: size.width, height: toLabel.frame.maxY + 12.0)
    }
}

//MARK: - Constants

private enum Constants {
    static let titleFromLabel = "Text".localized
    static let titleToLabel = "Translate".localized
}
