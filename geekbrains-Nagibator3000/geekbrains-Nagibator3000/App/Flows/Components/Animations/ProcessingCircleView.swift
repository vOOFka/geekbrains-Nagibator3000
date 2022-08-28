//
//  ProcessingCircleView.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 28.08.2022.
//

import Lottie
import UIKit

public final class ProcessingCircleView: UIView {
    private var animationView: AnimationView!
    
    init() {
        super.init(frame: .zero)
        self.animationView = AnimationView(name: "ProcessingCircle")
        configDefaults()
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func play() {
        animationView.play()
    }
    
    public func stop() {
        animationView.stop()
    }
    
    public func configDefaults() {
        frame = UIScreen.main.bounds
        backgroundColor = Constants.whiteColor
        addSubview(animationView)
        animationView.pin.center().height(200.0).width(200.0)
        animationView.backgroundColor = Constants.whiteColor
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = 1.1
    }    
}

//MARK: - Constants

private enum Constants {
    static let whiteColor = ColorScheme.white.color
}
