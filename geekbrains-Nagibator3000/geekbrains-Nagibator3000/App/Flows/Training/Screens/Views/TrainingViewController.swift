//
//  TrainingViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit

final class TrainingViewController: UIViewController {
  var viewModel: TrainingViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColorScheme.white.color
    title = String(localized: "Training")
  }
}
