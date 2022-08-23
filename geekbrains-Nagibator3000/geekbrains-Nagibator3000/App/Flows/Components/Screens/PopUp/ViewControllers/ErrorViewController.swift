//
//  ErrorViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 22.08.2022.
//

import UIKit
import RxFlow
import RxRelay
import PinLayout

class ErrorViewController: UIViewController, Stepper {
  var steps = PublishRelay<Step>()
  var titleText: String
  var messageText: String
  var confirmButtonText: String

  private var mainStackView = UIStackView()
  private var titleLabel = UILabel()
  private var messageLabel = UILabel()
  private var confirmButton = UIButton()

  init(
    with error: ErrorType
  ) {
    switch error {
    case .connectionLost:
      self.titleText = Constants.connectionLostTitle
      self.messageText = Constants.connectionLostMessage

    case .internetConnectionLost:
      self.titleText = Constants.internetErrorTitle
      self.messageText = Constants.internetErrorMessage

    case .unauthorized:
      self.titleText = Constants.unauthorizedTitle
      self.messageText = Constants.unauthorizedMessage

    case .otherError:
      self.titleText = Constants.otherErrorTitle
      self.messageText = Constants.otherErrorMessage
    }

    self.confirmButtonText = Constants.confirmButtonTitle
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    titleText = Constants.emptyText
    messageText = Constants.emptyText
    confirmButtonText = Constants.emptyText
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupMainView()
    setupMainStack()
    setupConfirmButton()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
  }
  
  @IBAction private func onConfirmButtonTapped(_ sender: UIButton) {
    dismiss(animated: true)
  }

  private func setupMainView() {
    view.backgroundColor = Constants.mainViewBackgroundColor
  }

  private func setupMainStack() {
    mainStackView.backgroundColor = ColorScheme.greenPantone.color
    mainStackView.layer.cornerRadius = Constants.mainStackLayerCornerRadius
    view.addSubview(mainStackView)
  }

  private func setupConfirmButton() {
    confirmButton.backgroundColor = Constants.confirmButtonBackgroundColor
    confirmButton.setTitleColor(ColorScheme.white.color, for: .normal)
    confirmButton.layer.cornerRadius = Constants.confirmButtonLayerCornerRadius
  }
}

private enum Constants {
  // Strings
  static let nibName = String(describing: ErrorViewController.self)
  static let emptyText = ""
  static let internetErrorTitle = "Error.InternetError.Title".localized
  static let internetErrorMessage = "Error.InternetError.Message".localized
  static let connectionLostTitle = "Error.ConnectionLost.Title".localized
  static let connectionLostMessage = "Error.ConnectionLost.Message".localized
  static let confirmButtonTitle = "Error.ConfirmButton.Title".localized
  static let unauthorizedMessage = "Error.Unauthorized.Message".localized
  static let unauthorizedTitle = "Error.Unauthorized.Title".localized
  static let otherErrorTitle = "Error.OtherError.Title".localized
  static let otherErrorMessage = "Error.OtherError.Message".localized

  // Colors
  static let mainViewBackgroundColor = UIColor.black.withAlphaComponent(0.4)
  static let confirmButtonBackgroundColor = UIColor.yellow
  static let titleLabelForegroundColor = ColorScheme.white.color
  static let messageLabelForeground = ColorScheme.white.color

  // Sizes
  static let mainStackLayerCornerRadius: CGFloat = 16
  static let confirmButtonLayerCornerRadius: CGFloat = 24
  static let titleLabelSketchLineHeight: CGFloat = 22
}

