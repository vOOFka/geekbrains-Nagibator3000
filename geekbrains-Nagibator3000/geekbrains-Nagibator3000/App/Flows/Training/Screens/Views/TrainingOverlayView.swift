//
//  TrainingOverlayView.swift
//  geekbrains-Nagibator3000
//
//  Created by Константин Каменчуков on 21.08.2022.
//

import UIKit
import Koloda

private let overlayRight = "noOverlay"
private let overlayLeft = "yesOverlay"

class TrainingOverlayView: OverlayView {
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [weak self] in
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 600))
        self?.addSubview(imageView)
        return imageView
    }()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left?:
                overlayImageView.image = UIImage(named: overlayLeft)
            case .right?:
                overlayImageView.image = UIImage(named: overlayRight)
            default:
                overlayImageView.image = nil
            }
        }
    }
}

