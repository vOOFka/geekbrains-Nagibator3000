//
//  TranslateViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit

final class TranslateViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorScheme.fuchsiaBlue.color
        title = String(localized: "Translate")
    }
}
