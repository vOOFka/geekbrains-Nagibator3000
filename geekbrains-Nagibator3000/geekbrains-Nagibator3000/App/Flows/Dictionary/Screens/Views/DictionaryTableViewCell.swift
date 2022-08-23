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
    private var holderView = UIView()
    private var titleFromLabel = UILabel()
    private var titleToLabel = UILabel()
    private var fromLabel = UILabel()
    private var toLabel = UILabel()
    private var separatorView = UIView()
    
    private var deleteView = UIView()
    private var iconTrash = UIImageView(image: Constants.deleteIcon)
        
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
        
        contentView.addSubview(holderView)
        contentView.addSubview(deleteView)
        
        deleteView.addSubview(iconTrash)
        
        holderView.addSubview(titleFromLabel)
        holderView.addSubview(titleToLabel)
        holderView.addSubview(fromLabel)
        holderView.addSubview(toLabel)
        holderView.addSubview(separatorView)
       
        deleteView.backgroundColor = Constants.deleteBackgroundColor
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
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let mainWidth = UIScreen.main.bounds.width
        let state = true//viewModel?.isPrepareForDelete ?? false
        let width = (state) ? mainWidth - 100.0 : mainWidth
        
        titleFromLabel.pin.top(16.0).horizontally().margin(16.0).sizeToFit()
        fromLabel.pin.below(of: titleFromLabel).horizontally().margin(16.0).sizeToFit()
        
        
        titleToLabel.pin.below(of: fromLabel).horizontally().margin(16.0).sizeToFit()
        toLabel.pin.below(of: titleToLabel).horizontally().margin(16.0).sizeToFit()
        
        holderView.pin.height(toLabel.frame.maxY + 32.0).width(width)
        contentView.pin.height(toLabel.frame.maxY + 32.0).width(mainWidth)
        
        separatorView.pin.bottom().left(16.0).height(onePixelHeight).width(width - 32.0)
        
        if state {
            deleteView.pin.after(of: holderView).width(100.0).height(contentView.frame.maxY + 1.0)
            iconTrash.pin.center().width(30.0).height(30.0)
        }
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
    static let deleteBackgroundColor = ColorScheme.alertRed.color
    
    static let deleteIcon = UIImage(systemName: "trash")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    
    static let boldFont = UIFont.boldSystemFont(ofSize: 16.0)
    static let italicFont = UIFont.italicSystemFont(ofSize: 14.0)
}
