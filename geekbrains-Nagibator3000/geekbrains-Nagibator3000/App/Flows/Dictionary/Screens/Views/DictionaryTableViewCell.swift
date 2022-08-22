//
//  DictionaryTableViewCell.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 14.08.2022.
//

import UIKit
import RxSwift

final class DictionaryTableViewCell: RxTableViewCell<DictionaryTableCellViewModel> {
    var viewModel: DictionaryTableCellViewModel?
    
    // MARK: - Private properties
    private var titleFromLabel = UILabel()
    private var titleToLabel = UILabel()
    private var fromLabel = UILabel()
    private var toLabel = UILabel()
    private var separatorView = UIView()
    
    private let onePixelHeight = 1.0 / UIScreen.main.scale
    
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
        titleFromLabel.text = Constants.titleFromLabel
        titleToLabel.text = Constants.titleToLabel
        titleFromLabel.font = Constants.boldFont
        titleToLabel.font = Constants.boldFont
        
        fromLabel.numberOfLines = 0
        toLabel.numberOfLines = 0
        fromLabel.font = Constants.italicFont
        toLabel.font = Constants.italicFont
        
        contentView.addSubview(titleFromLabel)
        contentView.addSubview(titleToLabel)
        contentView.addSubview(fromLabel)
        contentView.addSubview(toLabel)
        contentView.addSubview(separatorView)
        
        backgroundColor = Constants.backgroundColor
        
        separatorView.backgroundColor = Constants.separatorColor
        layoutSubviews()
    }
    
    override func config(item: DictionaryTableCellViewModel) {
        self.fromLabel.text = item.text
        self.toLabel.text = item.translation
        self.viewModel = item
    }
    
    override func prepareForReuse() {
        fromLabel.text = String()
        toLabel.text = String()
        backgroundColor = Constants.backgroundColor
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleFromLabel.pin.top(16.0).horizontally().margin(16.0).sizeToFit()
        fromLabel.pin.below(of: titleFromLabel).horizontally().margin(16.0).sizeToFit(.width)
        
        
        titleToLabel.pin.below(of: fromLabel).horizontally().margin(16.0).sizeToFit()
        toLabel.pin.below(of: titleToLabel).horizontally().margin(16.0).sizeToFit(.width)
        
        contentView.pin.height(toLabel.frame.maxY + 16.0)
        
        separatorView.pin.bottom().horizontally(16.0).height(onePixelHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutSubviews()
        return CGSize(width: size.width, height: separatorView.frame.maxY + 1.0)
    }
    
}

//MARK: - Constants

private enum Constants {
    static let titleFromLabel = "Text".localized
    static let titleToLabel = "Translation".localized
    
    static let separatorColor = ColorScheme.greenPantone.color
    static let backgroundColor = ColorScheme.alertRed.color
    
    static let boldFont = UIFont.boldSystemFont(ofSize: 16.0)
    static let italicFont = UIFont.italicSystemFont(ofSize: 14.0)
}
