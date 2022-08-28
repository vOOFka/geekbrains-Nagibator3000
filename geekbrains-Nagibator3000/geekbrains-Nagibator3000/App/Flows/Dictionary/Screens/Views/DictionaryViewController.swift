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
    private var loadingAnimationView = ProcessingCircleView()
    
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
        bindStates()
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
        
        setupLoadingAnimationView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.setupTitle(text: Constants.title)
        tableView.setEditing(true, animated: true)
        setupNavbarButton()
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
                    removeAllDeleteActionsView()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showToast
            .bind { [weak self] text in
                self?.showToast(text: text)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindStates() {
        viewModel.output.state
        .drive { [weak self] state in
            switch state {
            case .load:
                self?.tableView.isHidden = true
                self?.loadingAnimationView.isHidden = false
                self?.loadingAnimationView.pin.center()
                self?.loadingAnimationView.play()
            case .empty:
                self?.loadingAnimationView.isHidden = true
                self?.loadingAnimationView.stop()
              //  self?.emptyHolderView.isHidden = false
                self?.tableView.isHidden = true
            case .completed:
                self?.loadingAnimationView.isHidden = true
                self?.loadingAnimationView.stop()
                self?.tableView.isHidden = false
            }
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
            UIView.animate(withDuration: 0.1) {
                cell.pin.left()
            }
            removeAllDeleteActionsView()
        }
        self.isMovedCells = false
    }
    
    private func configDeleteAction(_ cell: DictionaryTableViewCell, _ indexPath: IndexPath) {
        if let existView = view.subviews.first(where: { $0.tag == indexPath.row }),
           existView.accessibilityIdentifier == "handleDeleteTap" {
            existView.removeFromSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let frame = cell.frame
        if let globalPoint = cell.superview?.convert(cell.frame.origin, to: nil) {
            let view = UIView(frame: CGRect(x: globalPoint.x + frame.maxX + 100,
                                            y: globalPoint.y,
                                            width: 100.0,
                                            height: frame.size.height))
            view.tag = indexPath.row
            view.accessibilityIdentifier = "handleDeleteTap"
            self.view.addSubview(view)
            view.addGestureRecognizer(tap)
        }
    }
    
    private func removeSingleActionView(_ tag: Int) {
        view.subviews.forEach { view in
            if view.accessibilityIdentifier == "handleDeleteTap",
               view.tag == tag {
                view.removeFromSuperview()
            }
        }
    }
    
    private func removeAllDeleteActionsView() {
        view.subviews.forEach { view in
            if view.accessibilityIdentifier == "handleDeleteTap" {
                view.removeFromSuperview()
            }
        }
    }
    
    private func setupNavbarButton() {
        let addButton = UIBarButtonItem(image: Constants.addIcon, style: .plain, target: self, action: #selector(addTapped))
        tabBarController?.navigationItem.rightBarButtonItems = [addButton]
    }
    
    //MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all()
        loadingAnimationView.pin.all()
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
            UIView.animate(withDuration: 0.8) { [weak self] in
                guard let self = self else { return }
                cell.pin.left(-100.0)
                self.isMovedCells = true
                self.configDeleteAction(cell, indexPath)
            }
        }
        
        if gesture.direction == .right {
            UIView.animate(withDuration: 0.8) { [weak self] in
                guard let self = self else { return }
                cell.pin.left()
                self.removeSingleActionView(indexPath.row)
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let senderView = sender.view else {
            return
        }
        let indexPath = IndexPath(row: senderView.tag, section: 0)
        
        if (tableView.cellForRow(at: indexPath) != nil) {
            tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
        }
    }
    
    @objc private func addTapped() {
        viewModel.input.onAddItem.accept(Void())
    }
}

// MARK: - Animations

extension DictionaryViewController {
    private func setupLoadingAnimationView() {
        view.addSubview(loadingAnimationView)
        loadingAnimationView.isHidden = true
    }
}

//MARK: - Constants

private enum Constants {
    static let title = "Dictionary".localized
    
    static let backgroundColor = ColorScheme.raspberryRose.color
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
    static let cellBackgroundColor = ColorScheme.alertRed.color
    
    static let addIcon = UIImage(systemName: "plus")?.withTintColor(whiteColor, renderingMode: .alwaysOriginal)
}
