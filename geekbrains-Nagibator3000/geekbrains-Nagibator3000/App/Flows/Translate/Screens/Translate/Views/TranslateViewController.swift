//
//  TranslateViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit
import RxCocoa
import RxSwift
import Swinject

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
  
    //MARK: - Config
    
    private func initialConfig() {
        view.backgroundColor = Constants.backgroundColor
        sourceTextView.delegate = self
        destinationTextView.isEditable = false
   
        
        configLanguageButtons()
        actionView.delegate = self
        
        view.addSubview(sourceLanguageButton)
        view.addSubview(destinationLanguageButton)
        view.addSubview(swapLanguageButton)
        
        view.addSubview(sourceTextView)
        view.addSubview(destinationTextView)
        
        view.addSubview(actionView)
    }
    
    private func configLanguageButtons() {
        swapLanguageButton.setImage(Constants.swapIcon, for: .normal)
        swapLanguageButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30.0)
        swapLanguageButton.configuration = configuration
        
        swapLanguageButton.addTarget(self, action:#selector(swapLanguageButtonTap), for: .touchUpInside)
        
        sourceLanguageButton.addTarget(self, action:#selector(selectLanguageButtonTap), for: .touchUpInside)
        destinationLanguageButton.addTarget(self, action:#selector(selectLanguageButtonTap), for: .touchUpInside)
        
        sourceLanguageButton.accessibilityLabel = "source"
        destinationLanguageButton.accessibilityLabel = "destination"
    }
    
    private func bindViewModel() {
        viewModel.sourceLanguage.asObservable().bind { [weak self] lang in
            self?.sourceLanguageButton.setTitle(lang.code?.uppercased(), for: .normal)
        }.disposed(by: disposeBag)
        
        viewModel.destinationLanguage.asObservable().bind { [weak self] lang in
            self?.destinationLanguageButton.setTitle(lang.code?.uppercased(), for: .normal)
        }.disposed(by: disposeBag)
        
        viewModel.translatedText.asObservable().bind { [weak self] text in
            self?.destinationTextView.text = text
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Layout
    
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
    
    // MARK: - Button actions
    @objc private func selectLanguageButtonTap(sender : UIButton) {
        let type: LanguageType = (sender.accessibilityLabel == "source") ? .source : .destination
        let selectLanguageViewController = SelectLanguageViewController(viewModel: viewModel, type: type)
        
        let navigationController = UINavigationController(rootViewController: selectLanguageViewController)
        navigationController.isNavigationBarHidden = false
        navigationController.modalPresentationStyle = .automatic
        
        present(navigationController, animated: true)
    }
    
    @objc private func swapLanguageButtonTap(sender : UIButton) {
        viewModel.swapLanguages()
    }
}

extension TranslateViewController: CustomActionsDelegate {
    func someActionButtonTap(sender: UIButton) {
        print("+++")
    }
}

extension TranslateViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            viewModel.translate(text: textView.text)
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
}
