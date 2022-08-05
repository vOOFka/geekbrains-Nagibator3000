//
//  TranslateViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit
import PinLayout
import RxCocoa
import RxSwift

final class TranslateViewController: UIViewController {
    var viewModel: TranslateViewModel
    private let disposeBag = DisposeBag()
    
    private let sourceLanguageButton = UIButton()
    private let swapLanguageButton = UIButton()
    private let destinationLanguageButton = UIButton()
    
    // MARK: - Init

    init(viewModel: TranslateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
        bindViewModelInput()
    //    bindViewModelOutput()
    }
    
    //MARK: - Config
    
    private func initialConfig() {
        view.backgroundColor = Constants.backgroundColor
        title = Constants.title
        
        configLanguageButtons()
        
        view.addSubview(sourceLanguageButton)
        view.addSubview(destinationLanguageButton)
        view.addSubview(swapLanguageButton)
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
    
    private func bindViewModelInput() {
        viewModel.sourceLanguage.asObservable().bind { [weak self] lang in
            self?.sourceLanguageButton.setTitle(lang.code?.capitalized, for: .normal)
        }.disposed(by: disposeBag)
        
        viewModel.destinationLanguage.asObservable().bind { [weak self] lang in
            self?.destinationLanguageButton.setTitle(lang.code?.capitalized, for: .normal)
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        let buttonHeight: CGFloat = 60.0
        let buttonWidth: CGFloat = (UIScreen.main.bounds.width / 2) - buttonHeight / 2
        
        view.pin.all()
        sourceLanguageButton.pin.below(of: navigationBar).left().width(buttonWidth).height(buttonHeight)
        destinationLanguageButton.pin.below(of: navigationBar).right().width(buttonWidth).height(buttonHeight)
        swapLanguageButton.pin.horizontallyBetween(sourceLanguageButton, and: destinationLanguageButton, aligned: .center).height(buttonHeight)
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

//MARK: - Constants

private enum Constants {
    static let title = "Translate".localized
    
    static let swapIcon = UIImage(systemName: "arrow.left.and.right.square")
    
    static let backgroundColor = ColorScheme.fuchsiaBlue.color
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
}
