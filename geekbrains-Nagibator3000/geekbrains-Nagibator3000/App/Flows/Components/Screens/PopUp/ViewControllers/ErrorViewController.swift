//
//  ErrorViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 22.08.2022.
//

import UIKit
import RxFlow
import RxSwift
import RxRelay
import PinLayout

class ErrorViewController: UIViewController, Stepper {
  var steps = PublishRelay<Step>()
  var titleText: String
  var messageText: String
  var confirmButtonText: String

  private var mainHolderView = UIView()
  private var titleLabel = UILabel()
  private var messageLabel = UILabel()
  private var confirmButton = UIButton()
  private let disposeBag = DisposeBag()

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
    setupMainHolder()
    setupConfirmButton()
    setupLabels()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
      let mainWidth = UIScreen.main.bounds.width
      mainHolderView.pin.width(mainWidth * 0.8)
      
      titleLabel.pin.top().horizontally().margin(16.0).sizeToFit(.width)
      messageLabel.pin.below(of: titleLabel).horizontally().margin(16.0).sizeToFit(.width)
      
      confirmButton.pin.below(of: messageLabel).horizontally().margin(16.0).height(48.0)
      
      mainHolderView.pin.center().height(confirmButton.frame.maxY + 16.0)
      view.pin.all()
  }
  
  private func setupMainView() {
    view.backgroundColor = Constants.backgroundColor
    view.addSubview(mainHolderView)
  }

  private func setupMainHolder() {
    mainHolderView.addSubview(titleLabel)
    mainHolderView.addSubview(messageLabel)
    mainHolderView.addSubview(confirmButton)
    
    mainHolderView.backgroundColor = Constants.greenColor
    mainHolderView.layer.cornerRadius = Constants.mainStackLayerCornerRadius
  }

  private func setupConfirmButton() {
    confirmButton.setTitle(confirmButtonText, for: .normal)
    confirmButton.backgroundColor = Constants.whiteColor
    confirmButton.setTitleColor(Constants.blackColor, for: .normal)
    confirmButton.layer.cornerRadius = Constants.confirmButtonLayerCornerRadius
    confirmButton.rx.tap
      .map { _ in ErrorStep.close }
      .bind(to: steps)
      .disposed(by: disposeBag)
  }
  
  private func setupLabels() {
    titleLabel.text = titleText.uppercased()
    messageLabel.text = messageText
    
    titleLabel.numberOfLines = 0
    messageLabel.numberOfLines = 0
    
    titleLabel.textAlignment = .center
    messageLabel.textAlignment = .center
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
  static let backgroundColor = UIColor.black.withAlphaComponent(0.4)
  static let whiteColor = ColorScheme.white.color
  static let blackColor = ColorScheme.black.color
  static let greenColor = ColorScheme.greenPantone.color.withAlphaComponent(0.8)

  // Sizes
  static let mainStackLayerCornerRadius: CGFloat = 16
  static let confirmButtonLayerCornerRadius: CGFloat = 24
  static let titleLabelSketchLineHeight: CGFloat = 22
}

