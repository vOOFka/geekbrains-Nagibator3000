//
//  TrainingViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit
import Koloda
import RxCocoa
import RxSwift

final class TrainingViewController: UIViewController {
  var viewModel: TrainingViewModel!
  var kolodaView = KolodaView(frame: CGRect(x: 0, y: 0, width: 250, height: 400))
  
  private var trainingCards: [UIView] = []
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColorScheme.white.color
    view.addSubview(kolodaView)
    kolodaView.dataSource = self
    kolodaView.delegate = self
    bindLifeCycle()
    bindSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.navigationItem.setupTitle(text: "Training".localized)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    kolodaView.pin.center()
  }
  
  private func bindLifeCycle() {
    rx.viewWillAppear
      .bind(to: viewModel.input.enterScreen)
      .disposed(by: disposeBag)
  }
  
  private func bindSource() {
    viewModel.output.source
      .drive { [weak self] source in
        self?.trainingCards = source
          .compactMap{ model in TrainingCardView(with: model.fromText, translate: model.toText) }
        self?.kolodaView.reloadData()
      }
      .disposed(by: disposeBag)
  }
}

extension TrainingViewController: KolodaViewDelegate {
  func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    kolodaView.reloadData()
  }
}

extension TrainingViewController: KolodaViewDataSource {
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    return trainingCards[index]
  }
  
  func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return trainingCards.count
  }
  
  func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return .default
  }
  func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    return TrainingOverlayView()
  }
}
