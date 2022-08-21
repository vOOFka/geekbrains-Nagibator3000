//
//  TranslateViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit
import RxCocoa
import RxSwift
import Toast_Swift

final class TranslateViewController: UIViewController {
  var viewModel: TranslateViewModel!
  private let disposeBag = DisposeBag()
  
  private let sourceLanguageButton = UIButton()
  private let swapLanguageButton = UIButton()
  private let destinationLanguageButton = UIButton()
  
  private let sourceTextView = CustomTextView()
  private let destinationTextView = CustomTextView()
  private let actionView = CustomActionsView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initialConfig()
    bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.navigationItem.setupTitle(text: Constants.title)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard let navigationBar = navigationController?.navigationBar else {
      return
    }
    let mainWidth = UIScreen.main.bounds.width
    
    let buttonHeight: CGFloat = 60.0
    let buttonWidth: CGFloat = (mainWidth / 2) - buttonHeight / 2
    
    view.pin.all()
    sourceLanguageButton.pin.below(of: navigationBar).left().width(buttonWidth).height(buttonHeight)
    destinationLanguageButton.pin.below(of: navigationBar).right().width(buttonWidth).height(buttonHeight)
    swapLanguageButton.pin.horizontallyBetween(sourceLanguageButton, and: destinationLanguageButton, aligned: .center).height(buttonHeight)
    
    sourceTextView.pin.below(of: swapLanguageButton, aligned: .center).width(mainWidth - 40.0).height(mainWidth / 3).margin(20.0)
    destinationTextView.pin.below(of: sourceTextView, aligned: .center).width(mainWidth - 40.0).height(mainWidth / 3).margin(20.0)
    
    actionView.pin.below(of: destinationTextView, aligned: .right).width(mainWidth).height(buttonHeight * 0.6).marginTop(16.0)
  }
  
  private func initialConfig() {
    view.backgroundColor = Constants.backgroundColor
    setupTextViews()
    setupButtons()
    setupActionView()
  }
  
  private func setupTextViews() {
    sourceTextView.delegate = self
    destinationTextView.isEditable = false
    sourceTextView.textColor = Constants.blackColor
    destinationTextView.textColor = Constants.blackColor
    
    view.addSubview(sourceTextView)
    view.addSubview(destinationTextView)
  }
  
  private func setupButtons() {
    swapLanguageButton.setImage(Constants.swapIcon, for: .normal)
    swapLanguageButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    var configuration = UIButton.Configuration.plain()
    configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30.0)
    swapLanguageButton.configuration = configuration

    view.addSubview(sourceLanguageButton)
    view.addSubview(destinationLanguageButton)
    view.addSubview(swapLanguageButton)
  }
  
  private func setupActionView() {
    actionView.delegate = self
    view.addSubview(actionView)
  }
  
  private func bindViewModel() {
    swapLanguageButton.rx.tap
      .map { _ in Void() }
      .bind(to: viewModel.input.onReverseLanguage)
      .disposed(by: disposeBag)
    
    sourceLanguageButton.rx.tap
      .map { _ in Void() }
      .bind(to: viewModel.input.onTapFromLanguage)
      .disposed(by: disposeBag)
    
    destinationLanguageButton.rx.tap
      .map { _ in Void() }
      .bind(to: viewModel.input.onTapToLanguage)
      .disposed(by: disposeBag)
    
    viewModel.output.translateText
      .map { $0.toText }
      .drive(destinationTextView.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.output.destinationLanguage
      .map { $0.name.capitalized }
      .drive(destinationLanguageButton.rx.title())
      .disposed(by: disposeBag)
    
    viewModel.output.sourceLanguage
      .map { $0.name.capitalized }
      .drive(sourceLanguageButton.rx.title())
      .disposed(by: disposeBag)
    
    viewModel.output.reverseText
      .bind { [weak self] _ in
        guard let self = self else { return }
        guard !self.sourceTextView.text.isEmpty,
              !self.destinationTextView.text.isEmpty else {
          
          self.sourceTextView.text = ""
          self.destinationTextView.text = ""
          return
        }
        let tempValue = self.sourceTextView.text
        self.sourceTextView.text = self.destinationTextView.text
        self.destinationTextView.text = tempValue
      }
      .disposed(by: disposeBag)
    
    viewModel.output.showToast
      .bind { [weak self] text in
        self?.showToast(text: text)
      }
      .disposed(by: disposeBag)
  }
  
  private func showToast(text: String) {
    var style = ToastStyle()
    style.messageColor = Constants.whiteColor
    self.view.makeToast(text, duration: 4.0, position: .bottom, style: style)
  }
}

extension TranslateViewController: CustomActionsDelegate {
  func someActionButtonTap(sender: UIButton) {
    guard let label = sender.accessibilityLabel,
          let senderType = ActionButtonType.actionType(from: label) else {
      return
    }
    switch senderType {
    case .shareButton:
      viewModel.input.onShare.accept(Void())
    case .copyButton:
      UIPasteboard.general.string = destinationTextView.text
      viewModel.input.onCopy.accept(Void())
    case .saveButton:
      viewModel.input.onSave.accept(Void())
    }
  }
}

extension TranslateViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      viewModel.input.onTranslate.accept(textView.text)
      textView.resignFirstResponder()
    }
    return true
  }
}

//MARK: - Constants

private enum Constants {
  static let title = "Translate".localized
  
  static let swapIcon = UIImage(systemName: "arrow.left.and.right.square")?.withTintColor(whiteColor, renderingMode: .alwaysOriginal)
  
  static let backgroundColor = ColorScheme.greenPantone.color
  static let whiteColor = ColorScheme.white.color
  static let greenColor = ColorScheme.greenPantone.color
  static let blackColor = ColorScheme.black.color
}
