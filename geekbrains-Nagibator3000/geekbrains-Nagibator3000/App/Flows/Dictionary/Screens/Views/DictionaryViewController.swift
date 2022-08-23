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
    private var isMovedCells: Bool = false
    
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
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        tableView.addGestureRecognizer(swipeRight)
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("I'm scrolling!")
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
        
        tableView.rx.didScroll
            .subscribe(onNext: { [unowned self] _ in
                self.getBackCells()
            })
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
    
    private func getBackCells() {
        guard isMovedCells == true else {
            return
        }
        self.tableView.visibleCells.forEach { cell in
            if let cell = cell as? DictionaryTableViewCell,
               (cell.viewModel?.isPrepareForDelete == true) {
                UIView.animate(withDuration: 0.1) {
                    cell.pin.left()
                }
            }
        }
        self.isMovedCells = false
    }
    
    //MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all()
    }
    
    //MARK: - Actions
    
    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        let location = gesture.location(in: tableView)
   
        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath) as? DictionaryTableViewCell
        else {
            return
        }
        
        if gesture.direction == .left {
            if cell.viewModel?.isPrepareForDelete == false {
                cell.viewModel?.state()
            }
        }
        
        if gesture.direction == .right {
            if cell.viewModel?.isPrepareForDelete == true {
                cell.viewModel?.state()
            }
        }
        
        UIView.animate(withDuration: 0.8) { [weak self] in
            cell.pin.left(-100.0)
            self?.isMovedCells = true
        }
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
