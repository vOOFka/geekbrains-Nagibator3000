//
//  SelectLanguageCell.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import UIKit

class SelectLanguageCell: RxTableViewCell<SelectLanguageCellModel> {
  private var nameLabel = UILabel()
  
  private var iconImageView: UIImageView = {
    let iconImageView = UIImageView()
    iconImageView.layer.borderWidth = 1.0
    iconImageView.layer.borderColor = Constants.greenColor.cgColor
    iconImageView.layer.cornerRadius = 6.0
    iconImageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration.init(weight: .bold)
    return iconImageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialConfig()
    }

  override func config(item: SelectLanguageCellModel) {
    nameLabel.text = item.language.name.capitalized
    iconImageView.image = item.isSelected ? Constants.checkmarkIcon : nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    
    iconImageView.pin.centerLeft().margin(20.0).height(30.0).width(30.0)
    nameLabel.pin.after(of: iconImageView, aligned: .center).margin(20.0).right().sizeToFit()
  }
  
  private func initialConfig() {
    nameLabel.numberOfLines = 1
    selectionStyle = .none
    contentView.addSubview(nameLabel)
    contentView.addSubview(iconImageView)
  }
}

//MARK: - Constants

private enum Constants {
  static let checkmarkIcon = UIImage(systemName: "checkmark")?.withTintColor(greenColor, renderingMode: .alwaysOriginal)
  
  static let whiteColor = ColorScheme.white.color
  static let greenColor = ColorScheme.greenPantone.color
}
