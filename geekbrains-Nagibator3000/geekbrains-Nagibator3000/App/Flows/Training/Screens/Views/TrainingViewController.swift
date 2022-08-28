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
import Lottie
import RxFlow

final class TrainingViewController: UIViewController, Stepper {
  private var cupAnimationView: AnimationView!
    
  private var emptyStateView = EmptyStateView()
  
  var steps = PublishRelay<Step>()
  
  var viewModel: TrainingViewModel!
  var kolodaView = KolodaView(frame: CGRect(x: 0, y: 0, width: 250, height: 400))
  
  private var trainingCards: [UIView] = []
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColorScheme.white.color
    view.addSubview(kolodaView)
    kolodaView.delegate = self
    kolodaView.dataSource = self
    bindLifeCycle()
    bindSource()
    setupCupAnimationView()
    configEmptyStateView()
    bindStates()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    kolodaView.pin.center()
    tabBarController?.navigationItem.setupTitle(text: Constants.title)
    tabBarController?.navigationItem.rightBarButtonItems?.removeAll()
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
        self?.kolodaView.resetCurrentCardIndex()
      }
      .disposed(by: disposeBag)
  }
  
  private func bindStates() {
    viewModel.output.state
      .drive { [weak self] state in
        switch state {
        case .load:
          self?.kolodaView.isHidden = false
          self?.emptyStateView.isHidden = true
          self?.cupAnimationView.isHidden = true
          
        case .empty:
          self?.emptyStateView.isHidden = false
          self?.emptyStateView.pin.all()
          self?.kolodaView.isHidden = true
          self?.cupAnimationView.isHidden = true
          
        case .completed:
          self?.emptyStateView.isHidden = true
          self?.cupAnimationView.isHidden = true
          self?.kolodaView.isHidden = false
        }
      }
      .disposed(by: disposeBag)
  }
  
}

extension TrainingViewController: KolodaViewDelegate {
  func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    kolodaView.isHidden = true
    emptyStateView.isHidden = true
    cupAnimationView.pin.center()
    cupAnimationView.isHidden = false
    cupAnimationView.play()
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
  
  func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
    guard direction == .right || direction == .topRight || direction == .bottomRight else { return }
    
    viewModel.input.delete.accept(index)
  }
}

// MARK: - Empty state view

extension TrainingViewController {
  private func configEmptyStateView() {
    emptyStateView.addButton.addTarget(self, action:#selector(addButtonTap), for: .touchUpInside)
    view.addSubview(emptyStateView)
  }
  
  @objc private func addButtonTap(sender: UIButton) {
    viewModel.input.onAdd.accept(Void())
  }
}

// MARK: - Animations

extension TrainingViewController {
  private func setupCupAnimationView() {
    cupAnimationView = AnimationView(name: "Cup")
    configDefaults(with: cupAnimationView)
  }
  
  private func configDefaults(with animationView: AnimationView) {
    animationView.pin.height(400.0).width(400.0)
    animationView.backgroundColor = Constants.whiteColor
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .playOnce
    animationView.animationSpeed = 1.1
    view.addSubview(animationView)
    animationView.isHidden = true
  }
}

//MARK: - Constants

private enum Constants {
  static let title = "Training".localized
  static let emptyLabelText = "Your dictionary is empty, add words and come back!".localized
  static let titleAddButton = "Add".localized
  
  static let whiteColor = ColorScheme.white.color
  static let blackColor = ColorScheme.black.color
  static let blueColor = ColorScheme.fuchsiaBlue.color
  
  static let boldFont = UIFont.boldSystemFont(ofSize: 20.0)
}
