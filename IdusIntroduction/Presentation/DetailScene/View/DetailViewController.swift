//
//  DetailViewController.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/08.
//

import Foundation

import UIKit
import Combine

final class DetailViewController: UIViewController {
    // MARK: - Properties
    private let descriptionLabel: UILabel = {  // TODO: Alert로 대체 가능
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .black
        return label
    }()
    
    private var viewModel: DetailViewModel!
    private let leftBarButtonDidTap = PassthroughSubject<Void, Never>()
    private var cancellableBag = Set<AnyCancellable>()
    
    // MARK: - Initializers
    convenience init(viewModel: DetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Methods
    private func configureUI() {
        configureNavigationBar()
        configureHierarchy()
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .white
//        navigationItem.backButtonTitle = Design.backButtonTitle
    }
    
    private func configureHierarchy() {
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
        ])
    }
}

// MARK: - Combine Binding Methods
extension DetailViewController {
    private func bind() {
        let input = DetailViewModel.Input(leftBarButtonDidTap: leftBarButtonDidTap)

        guard let output = viewModel?.transform(input) else { return }
        
        configureUIContents(with: output.appItem)
    }
    
    private func configureUIContents(
        with appItem: Just<AppItem?>
    ) {
        appItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] appItem in
                guard let appItem = appItem else { return }
                self?.setNavigationTitle(appItem.trackName)
                self?.setupUI(appItem)
            })
            .store(in: &self.cancellableBag)
    }
    
    private func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    // UI 셋업
    private func setupUI(_ appItem: AppItem) {
        
    }
}

// MARK: - NameSpaces
extension DetailViewController {
    private enum Text {
    }
    
    private enum Design {
        static let backButtonTitle = ""
    }
}
