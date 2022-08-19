//
//  DictionaryTableViewCell.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 14.08.2022.
//

import UIKit
import RxSwift

final class DictionaryTableViewCell: UITableViewCell {
    var viewModel: DictionaryTableCellViewModel!
    
    // MARK: - Private properties
    private var fromLabel = UILabel()
    private var toLabel = UILabel()
    private var separatorView = UIView()
    var disposeBag = DisposeBag()
    
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
        selectionStyle = .none
        
        contentView.addSubview(fromLabel)
        contentView.addSubview(toLabel)
        contentView.addSubview(separatorView)
        
        separatorView.backgroundColor = Constants.separatorColor
        
        layoutSubviews()
    }
    
    override func prepareForReuse() {
        fromLabel.text = String()
        toLabel.text = String()
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = 1.0 / UIScreen.main.bounds.width
        
        fromLabel.pin.top().horizontally().margin(16.0).sizeToFit()
        toLabel.pin.below(of: fromLabel, aligned: .start).right(16.0).sizeToFit()
        
        contentView.pin.height(toLabel.frame.maxY + 16.0)
        
        separatorView.pin.bottom().horizontally(16.0).height(height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutSubviews()
        return CGSize(width: size.width, height: separatorView.frame.maxY)
    }
}

extension DictionaryTableViewCell: BindableType {
    func bindViewModel() {
        viewModel.text
            .drive(fromLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.translation
            .drive(toLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: - Constants

private enum Constants {
    static let titleFromLabel = "Text".localized
    static let titleToLabel = "Translation".localized
    
    static let separatorColor = ColorScheme.greenPantone.color
}
