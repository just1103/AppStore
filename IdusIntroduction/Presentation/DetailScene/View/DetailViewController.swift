//
//  DetailViewController.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/08.
//

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
    private let ScrollContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Design.scrollContentStackViewSpacing
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.scrollContentStackViewVerticalInset,
            leading: Design.scrollContentStackViewHorizontalInset,
            bottom: Design.scrollContentStackViewVerticalInset,
            trailing: Design.scrollContentStackViewHorizontalInset
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let upperlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setContentHuggingPriority(.required, for: .vertical)
        view.backgroundColor = Design.upperlineViewBackgroundColor
        return view
    }()
    private let mainStackView = MainStackView()
    private let summaryScrollView = SummaryScrollView()  // TODO: Horizontal CollectionView로 구현 (고민 필요)
    private let screenshotDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .label
        label.text = "미리보기" // SectionKind.description.title ?? ""  // TODO: lazy 안붙여도 되는지 확인
        return label
    }()
    private let screenshotCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let descriptionLabel: UILabel = {  // TODO: Alert로 대체 가능
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .label
        return label
    }()
    
    private var viewModel: DetailViewModel!
    private var screenshotURLs = [String]()
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
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureHierarchy() {
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(ScrollContentStackView)
        ScrollContentStackView.addArrangedSubview(mainStackView)
//        containerStackView.addArrangedSubview(summaryScrollView)
        ScrollContentStackView.addArrangedSubview(upperlineView)
        ScrollContentStackView.addArrangedSubview(screenshotDescriptionLabel)
        ScrollContentStackView.addArrangedSubview(screenshotCollectionView)
        
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            containerScrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor),
            
            ScrollContentStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            ScrollContentStackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            ScrollContentStackView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            ScrollContentStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width - Design.containerStackViewHorizontalInset
            ),

            screenshotCollectionView.heightAnchor.constraint(equalTo: screenshotCollectionView.widthAnchor, multiplier: 1.15),
            
        ])
    }
    
    private func configureCollectionView() {
        screenshotCollectionView.register(cellType: ScreenshotCell.self)
        screenshotCollectionView.collectionViewLayout = createCollectionViewLayout()
        screenshotCollectionView.dataSource = self
        screenshotCollectionView.delegate = self
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let horizontalInset: CGFloat = 8
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: horizontalInset,
                bottom: 0,
                trailing: horizontalInset
            )
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.7),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
        
        return layout
    }

}

// MARK: - Combine Binding Methods
extension DetailViewController {
    private func bind() {
        let input = DetailViewModel.Input(
            leftBarButtonDidTap: leftBarButtonDidTap.eraseToAnyPublisher()
//            screenshotCellDidTap: <#AnyPublisher<IndexPath, Never>#>
        )

        guard let output = viewModel?.transform(input) else { return }
        
        configureUIContents(with: output.appItem)
//        configureCollectionView(with: output.appItem)
    }
    
//    private func configureCollectionView(with appItem: AnyPublisher<AppItem, Never>) {
//        appItem
//            .receive(on: DispatchQueue.main)  // FIXME: Stream 갈라지도록 구성
//            .map { [weak self] appItem -> [String] in
//                return appItem.screenshotURLs
//            }
//            .eraseToAnyPublisher()
//            .subscribe(screenshotCollectionView.itemsSubscriber(cellIdentifier: "ScreenshotCell", cellType: ScreenshotCell.self, cellConfig: { cell, indexPath, model in
//
//            }))
//
//            .bind(subscriber: screenshotCollectionView.rowsSubscriber(cellIdentifier: "ScreenshotCell", cellType: ScreenshotCell.self, cellConfig: { cell, indexPath, model in
//
////                cell.nameLabel.text = model.name
//              }))
//            .store(in: &self.cancellableBag)
//    }
    
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
        
        screenshotURLs = appItem.screenshotURLs
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotCell", for: indexPath) as? ScreenshotCell
        else {
            return UICollectionViewCell()
        }
        cell.apply(screenshotURL: screenshotURLs[indexPath.row])
        
        return cell
    }
}
extension DetailViewController: UICollectionViewDelegate {
    
}

// MARK: - NameSpaces
extension DetailViewController {
    private enum Text {
    }
    
    private enum Design {
        static let scrollContentStackViewHorizontalInset: CGFloat = 12
        static let scrollContentStackViewVerticalInset: CGFloat = 12
        static let scrollContentStackViewSpacing: CGFloat = 12
        static let upperlineViewBackgroundColor: UIColor = .systemGray3
    }
}
