//
//  DetailViewController.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/08.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    // MARK: - Nested Types
    enum SectionKind {
        case main, summary, screenshot, description, info
        
        var title: String? { // TODO: 활용하도록 개선
            switch self {
            case .main:
                return nil
            case .summary:
                return nil
            case .screenshot:
                return "미리보기"
            case .description:
                return nil
            case .info:
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
    private let scrollContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Design.scrollContentStackViewSpacing
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.scrollContentStackViewVerticalInset,
            leading: Design.scrollContentStackViewHorizontalInset,  // TODO: Leading Constraints 없애기 (실제 AppStore UI처럼)
            bottom: Design.scrollContentStackViewVerticalInset,
            trailing: 0
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let upperlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.upperlineViewBackgroundColor
        return view
    }()
    private let mainStackView = MainStackView()
    private let summaryScrollView = SummaryScrollView()
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
        return collectionView
    }()
    
    private let descriptionLabel: UILabel = { 
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
    private let screenshotCellDidTap = PassthroughSubject<IndexPath, Never>()
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
        containerScrollView.addSubview(scrollContentStackView)
        scrollContentStackView.addArrangedSubview(mainStackView)
//        containerStackView.addArrangedSubview(summaryScrollView)
        scrollContentStackView.addArrangedSubview(upperlineView)
        scrollContentStackView.addArrangedSubview(screenshotDescriptionLabel)
        scrollContentStackView.addArrangedSubview(screenshotCollectionView)
        
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerScrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor),
            
            scrollContentStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            scrollContentStackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            scrollContentStackView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            scrollContentStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            
            upperlineView.heightAnchor.constraint(equalToConstant: 0.5),

            screenshotCollectionView.heightAnchor.constraint(
                equalTo: screenshotCollectionView.widthAnchor,
                multiplier: 1
            ),
            
        ])
    }
    
    private func configureCollectionView() {
        screenshotCollectionView.register(cellType: ScreenshotCell.self)
        screenshotCollectionView.dataSource = self
        screenshotCollectionView.delegate = self
        screenshotCollectionView.collectionViewLayout = createCollectionViewLayout()
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
                widthDimension: .fractionalWidth(0.6),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
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
    
    private func configureUIContents(with appItem: AnyPublisher<AppItem, Never>) {
        appItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] appItem in
                self?.setupUI(appItem)
            })
            .store(in: &self.cancellableBag)
    }

    private func setupUI(_ appItem: AppItem) {
        mainStackView.apply(
            thumbnailURL: appItem.artworkURL100,
            title: appItem.trackName,
            genre: appItem.primaryGenreName
        )
        
        screenshotURLs = appItem.screenshotURLs
        screenshotCollectionView.reloadData()  // TODO: Combine binding 사용하여 개선
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotURLs.count // setupUI 보다 나중에 불림
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ScreenshotCell.self, for: indexPath) 
        cell.apply(screenshotURL: screenshotURLs[indexPath.row])
        
        return cell
    }
}
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        screenshotCellDidTap.send(indexPath)
    }
}

// MARK: - NameSpaces
extension DetailViewController {
    private enum Text {
        static let screenshootDescriptionLabelText: String = "미리보기"
        static let infoDescriptionLabelText: String = "정보"
    }
    
    private enum Design {
        static let scrollContentStackViewHorizontalInset: CGFloat = 12
        static let scrollContentStackViewVerticalInset: CGFloat = 12
        static let scrollContentStackViewSpacing: CGFloat = 12
        static let upperlineViewBackgroundColor: UIColor = .systemGray3
    }
}
