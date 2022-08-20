//
//  CustomActionsView.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 12.08.2022.
//

import UIKit

protocol CustomActionsDelegate: AnyObject {
    func someActionButtonTap(sender: UIButton)
}

public final class CustomActionsView: UIView, CustomActionsDelegate {
    @objc func someActionButtonTap(sender: UIButton) {
        delegate?.someActionButtonTap(sender: sender)
    }
   
    weak var delegate: CustomActionsDelegate?
    
    init() {
        super.init(frame: .zero)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        ActionButtonType.allCases.forEach { [weak self] type in
            self?.configStackButton(with: type)
        }
    }
    
    private func configStackButton(with type: ActionButtonType) {
        guard let icon = Constants.icon(type) else {
            return
        }
        let button = UIButton()
        button.setImage(icon, for: .normal)
        button.accessibilityLabel = type.rawValue
        
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 26.0)
        button.configuration = configuration
        
        button.addTarget(self, action:#selector(someActionButtonTap), for: .touchUpInside)
        addSubview(button)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.height
        var previous: UIView?
        
        subviews.forEach { subview in
            subview.pin.height(height).width(height)
            if let previous = previous {
                subview.pin.before(of: previous).marginRight(20.0)
            } else {
                subview.pin.end()
            }
            previous = subview
        }
    }
}

public enum ActionButtonType: String, CaseIterable {
    case shareButton, copyButton, saveButton
    
    static func actionType(from string: String) -> ActionButtonType? {
        switch string {
        case shareButton.rawValue:
            return shareButton
        case copyButton.rawValue:
            return copyButton
        case saveButton.rawValue:
            return saveButton
        default:
            return nil
        }
    }
}

//MARK: - Constants

private enum Constants {
    static let whiteColor = ColorScheme.white.color
    
    static func icon(_ type: ActionButtonType) -> UIImage? {
        var iconName = String()
        switch type {
        case .shareButton:
            iconName = "square.and.arrow.up"
        case .copyButton:
            iconName = "square.fill.on.square"
        case .saveButton:
            iconName = "graduationcap.fill"
        }
        return UIImage(systemName: iconName)?.withTintColor(whiteColor, renderingMode: .alwaysOriginal)
    }
}
