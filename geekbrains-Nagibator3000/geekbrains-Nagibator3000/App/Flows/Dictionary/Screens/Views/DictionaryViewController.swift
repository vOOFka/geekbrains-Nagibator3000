//
//  DictionaryViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit

final class DictionaryViewController: UIViewController {
  var viewModel: DictionaryViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColorScheme.raspberryRose.color
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.navigationItem.setupTitle(text: String(localized: "Dictionary"))
  }
}
