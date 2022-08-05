//
//  SelectLanguageCell.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import UIKit

final class SelectLanguageCell: UITableViewCell {   
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
        nameLabel.numberOfLines = 1
        
        iconImageView.layer.borderWidth = 1.0
        iconImageView.layer.borderColor = Constants.greenColor.cgColor
        iconImageView.layer.cornerRadius = 6.0
        
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
        nameLabel.pin.after(of: iconImageView, aligned: .center).margin(20.0).right().sizeToFit()
    }
}

//MARK: - Constants

private enum Constants {
    static let checkmarkIcon = UIImage(systemName: "checkmark")

    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
}
