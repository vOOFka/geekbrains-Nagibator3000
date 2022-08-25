//
//  TrainingOverlayView.swift
//  geekbrains-Nagibator3000
//
//  Created by Константин Каменчуков on 21.08.2022.
//

import UIKit
import Koloda

class TrainingOverlayView: OverlayView {
    lazy var overlayImageView: UIImageView = {
        [weak self] in
        var imageView = UIImageView(frame: self?.bounds ?? CGRect(x: 0, y: 0, width: 250, height: 600))
        imageView.layer.cornerRadius = 30.0
        imageView.clipsToBounds = true
        self?.addSubview(imageView)
        return imageView
    }()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left?:
                overlayImageView.backgroundColor = Constants.redColor
            case .right?:
                overlayImageView.backgroundColor = Constants.greenColor
            default:
                overlayImageView.image = nil
            }
        }
    }
}

//MARK: - Constants

private enum Constants {
    static let greenColor = ColorScheme.greenPantone.color
    static let redColor = ColorScheme.alertRed.color
}
