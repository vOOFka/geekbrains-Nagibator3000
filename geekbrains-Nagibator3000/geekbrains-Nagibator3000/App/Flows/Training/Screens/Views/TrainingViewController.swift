//
//  TrainingViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit
import Koloda

private var numberOfCards: Int = 6
final class TrainingViewController: UIViewController {
  var viewModel: TrainingViewModel!
  var kolodaView = KolodaView(frame: CGRect(x: 0, y: 0, width: 250, height: 400))
    
  fileprivate var images: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "\(index + 1)")!)
        }
        return array
  }()
   
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColorScheme.white.color
    kolodaView.center = self.view.center
    view.addSubview(kolodaView)
    kolodaView.backgroundColor = ColorScheme.greenPantone.color
    kolodaView.dataSource = self
    kolodaView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.navigationItem.setupTitle(text: "Training".localized)
  }
}

extension TrainingViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.reloadData()
    }
}

extension TrainingViewController: KolodaViewDataSource {
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: images[Int(index)])
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
