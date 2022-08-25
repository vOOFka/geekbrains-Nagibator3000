//
//  TrainingViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit
import Koloda

final class TrainingViewController: UIViewController {
  var viewModel: TrainingViewModel!
  var kolodaView = KolodaView(frame: CGRect(x: 0, y: 0, width: 250, height: 400))
    
    private let images: [UIImage] = Array(0...5).compactMap{ UIImage(named: String($0 + 1)) }
   
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColorScheme.white.color
  //  kolodaView.center = self.view.center
    view.addSubview(kolodaView)
   // kolodaView.backgroundColor = ColorScheme.greenPantone.color
   //   kolodaView.layer.cornerRadius = 30.0
   //   kolodaView.clipsToBounds = true
    kolodaView.dataSource = self
    kolodaView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.navigationItem.setupTitle(text: "Training".localized)
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        kolodaView.pin.center()
    }
}

extension TrainingViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.reloadData()
    }
}

extension TrainingViewController: KolodaViewDataSource {
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let image = UIImageView(image: images[Int(index)])
        image.layer.cornerRadius = 30.0
        image.clipsToBounds = true
        return image
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return images.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("TrainingOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
