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
    // MARK: - Nested Types
    enum SectionKind {
        case main, summary, screenshot, description, detail
        
        var title: String? {
            switch self {
            case .main:
                return nil
            case .summary:
                return nil
            case .screenshot:
                return "미리보기"
            case .description:
                return nil
            case .detail:
                return "정보"
            }
        }
    }
    
    // MARK: - Properties
    private let containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let mainStackView = MainStackView()
    private let summaryScrollView = SummaryScrollView()  // TODO: Horizontal CollectionView로 구현 (고민 필요)
    private let screenshotDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .label
        label.text = SectionKind.description.title ?? ""  // TODO: lazy 안붙여도 되는지 확인
        return label
    }()
    private let screenshotCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
        bind()
    }

    // MARK: - Methods
    private func configureUI() {
        configureNavigationBar()
        configureHierarchy()
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureHierarchy() {
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(mainStackView)
//        containerScrollView.addSubview(summaryScrollView)
        containerScrollView.addSubview(screenshotCollectionView)
        
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerScrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
        ])
    }
}

// MARK: - Combine Binding Methods
extension DetailViewController {
    private func bind() {
        let input = DetailViewModel.Input(leftBarButtonDidTap: leftBarButtonDidTap.eraseToAnyPublisher())

        guard let output = viewModel?.transform(input) else { return }
        
        configureUIContents(with: output.appItem)
    }
    
    private func configureUIContents(with appItem: AnyPublisher<AppItem, Never>) {
        appItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] appItem in
                self?.setupUI(appItem)
            })
            .store(in: &self.cancellableBag)
    }
    
    // UI 셋업
    private func setupUI(_ appItem: AppItem) {
        mainStackView.apply(
            thumbnailURL: appItem.artworkURL100,
            title: appItem.trackName,
            genre: appItem.primaryGenreName
        )
    }
}

// MARK: - NameSpaces
extension DetailViewController {
    private enum Text {
    }
    
    private enum Design {
        
    }
}
