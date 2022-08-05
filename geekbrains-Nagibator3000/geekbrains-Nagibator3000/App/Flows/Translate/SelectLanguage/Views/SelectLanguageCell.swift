//
//  SelectLanguageCell.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import UIKit

final class SelectLanguageCell: UITableViewCell {
    // MARK: - Public properties
    public static let reuseIdentifier = "SelectLanguageCell"
    
    // MARK: - Private properties
    private var viewModel: SelectLanguageCellModel?
    private var nameLabel = UILabel()
    private var iconImageView = UIImageView()
    
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
        contentView.backgroundColor = .orange
        nameLabel.numberOfLines = 1
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconImageView)
        
        layoutSubviews()
    }
    
    override func prepareForReuse() {
        viewModel = nil
        nameLabel.text = String()
        iconImageView.image = nil
    }
    
    public func config(with viewModel: SelectLanguageCellModel) {
        self.viewModel = viewModel
        
        nameLabel.text = viewModel.language.nativeName
        iconImageView.image = viewModel.isSelected ? Constants.checkmarkIcon : nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.pin.centerLeft().margin(20.0).height(30.0).width(30.0)
        nameLabel.pin.below(of: iconImageView, aligned: .center).horizontally()
        contentView.pin.height(nameLabel.frame.maxY + 12.0)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutSubviews()
        return CGSize(width: size.width, height: nameLabel.frame.maxY + 12.0)
    }
}

//MARK: - Constants

private enum Constants {
    static let checkmarkIcon = UIImage(systemName: "checkmark")
    
    static let backgroundColor = ColorScheme.fuchsiaBlue.color
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
}
