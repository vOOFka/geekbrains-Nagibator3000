//
//  TranslateViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit
import PinLayout

final class TranslateViewController: UIViewController {
    var viewModel: TranslateViewModel
    
    private let buttonSourceLanguage = UIButton()
    private let buttonDestinationLanguage = UIButton()
    
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
    }
    
    //MARK: - Config
    
    private func initialConfig() {
        navigationController?.navigationBar.standardAppearance
        view.backgroundColor = Constants.backgroundColor
        title = Constants.title
        
        buttonSourceLanguage.setTitle(viewModel.sourceLanguage?.code, for: .normal)
        buttonDestinationLanguage.setTitle(viewModel.destinationLanguage?.code, for: .normal)
        
        buttonSourceLanguage.addTarget(self, action:#selector(buttonSelectLanguageTap), for: .touchUpInside)
        buttonDestinationLanguage.addTarget(self, action:#selector(buttonSelectLanguageTap), for: .touchUpInside)
        
        view.addSubview(buttonSourceLanguage)
        view.addSubview(buttonDestinationLanguage)
    }
    
    //MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        view.pin.all()
        buttonSourceLanguage.pin.below(of: navigationBar).left().width(UIScreen.main.bounds.width / 2).height(60.0)
        buttonDestinationLanguage.pin.below(of: navigationBar).right().width(UIScreen.main.bounds.width / 2).height(60.0)
    }
    
    // MARK: - Button actions
    @objc private func buttonSelectLanguageTap(sender : UIButton) {
        print("+++++++++++++")
        //private let selectLanguageViewController: UIViewController? = nil
    }
}

//MARK: - Constants

private enum Constants {
    static let title = "Translate".localized
    
    static let backgroundColor = ColorScheme.fuchsiaBlue.color
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
}
