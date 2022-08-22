//
//  TrainingOverlayView.swift
//  geekbrains-Nagibator3000
//
//  Created by Константин Каменчуков on 21.08.2022.
//

import UIKit
import Koloda

class TrainingOverlayView: OverlayView {
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [weak self] in
        var imageView = UIImageView(frame: self?.bounds ?? CGRect(x: 0, y: 0, width: 250, height: 600))
        self?.addSubview(imageView)
        return imageView
    }()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left?:
               overlayImageView.backgroundColor = .green
            case .right?:
                overlayImageView.backgroundColor = .red
            default:
                overlayImageView.image = nil
            }
        }
    }
}

