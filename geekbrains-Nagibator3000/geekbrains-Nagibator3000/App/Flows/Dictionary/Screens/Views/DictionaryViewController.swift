//
//  DictionaryViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 31.07.2022.
//

import UIKit
import RxSwift
import RxDataSources
import Toast_Swift

final class DictionaryViewController: UIViewController {
    var viewModel: DictionaryViewModel!
    private var dataSource = RXDictionaryListDataSource()
    
    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
        bindLifeCycle()
        bindViewModel()
    }
    
    //MARK: - Config
    
    private func initialConfig() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        tableView.addGestureRecognizer(swipeLeft)
        
        view.backgroundColor = Constants.backgroundColor
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.registerClass(DictionaryTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.setupTitle(text: Constants.title)
        tableView.setEditing(true, animated: true)
    }
    
    private func bindLifeCycle() {
        rx.viewWillAppear
            .bind(to: viewModel.input.enterScreen)
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.output.translationsSections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [unowned self] indexPath in
                if let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? DictionaryTableViewCell,
                   let translationModel = cell.viewModel?.translationModel {
                    viewModel.input.onDeleteItem.accept(translationModel)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showToast
          .bind { [weak self] text in
            self?.showToast(text: text)
          }
          .disposed(by: disposeBag)
    }
    
    private func showToast(text: String) {
      var style = ToastStyle()
      style.messageColor = Constants.whiteColor
      self.view.makeToast(text, duration: 4.0, position: .bottom, style: style)
    }
    
    //MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all()
    }
    
    //MARK: - Actions
    
    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
   //     gesture.cancelsTouchesInView = false
        
        let location = gesture.location(in: tableView)
        let width = UIScreen.main.bounds.width

        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath)
        else {
            return
        }
        
        if gesture.direction == .left {
            UIView.animate(withDuration: 0.9) {
                cell.pin.width(width * 0.8)
            }
        }
        
        if gesture.direction == .right {
            
        }

//        let translation = gesture.translation(in: view)
//        print(translation.x)
//
//        if gesture.state == .changed && translation.x < 0 {
//            cell.transform = CGAffineTransform(translationX: translation.x, y: 0)
//
//            let alpha = abs((translation.x * 0.6) / limit)
//            UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut, animations: {
//                cell.backgroundColor = Constants.cellBackgroundColor.withAlphaComponent(alpha)
//            })
//        }
//
//        if gesture.state == .ended {
//            if translation.x < limit {
//                self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
//            } else {
//                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
//                    cell.transform = .identity
//                    cell.backgroundColor = Constants.cellBackgroundColor.withAlphaComponent(0.0)
//                }
//            }
//        }
    }
}

//MARK: - Constants

private enum Constants {
    static let title = "Dictionary".localized
    
    static let backgroundColor = ColorScheme.raspberryRose.color
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
    static let cellBackgroundColor = ColorScheme.alertRed.color
}
