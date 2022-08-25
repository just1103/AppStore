//
//  DetailViewController.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/08.
//

import Combine
import UIKit

final class DetailViewController: UIViewController {
    // MARK: - Nested Types
    enum SectionKind {
        case main, summary, screenshot, description, info
    }
    
    enum InfoComponents: CaseIterable {
        case provider, fileSize, language, advisoryRating, price
        
        var title: String {
            switch self {
            case .provider:
                return "제공자"
            case .fileSize:
                return "크기"
            case .language:
                return "언어"
            case .advisoryRating:
                return "연령 등급"
            case .price:
                return "가격"
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
            leading: Design.scrollContentStackViewHorizontalInset,
            bottom: Design.scrollContentStackViewVerticalInset,
            trailing: Design.scrollContentStackViewHorizontalInset
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let mainStackView = MainStackView()
    private let summaryUpperlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.upperlineViewBackgroundColor
        return view
    }()
    private let summaryScrollView = SummaryScrollView()
    private let screenshotUpperlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.upperlineViewBackgroundColor
        return view
    }()
    private let screenshotDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .label
        label.text = Text.screenshotDescriptionLabelText
        return label
    }()
    private let screenshotCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private let descriptionUpperlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.upperlineViewBackgroundColor
        return view
    }()
    private let descriptionLabel: UILabel = {  
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let unfoldButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.unfoldButtonTitleForUnfolding, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    private let infoUpperlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.upperlineViewBackgroundColor
        return view
    }()
    private let infoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .label
        label.text = Text.infoDescriptionLabelText
        return label
    }()
    private let infoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 0
        return tableView
    }()
    
    private var viewModel: DetailViewModel!
    private var screenshotURLs = [String]()
    private var infoContents = [String]()
    private let leftBarButtonDidTap = PassthroughSubject<Void, Never>()
    private let shareButtonDidtap = PassthroughSubject<Void, Never>()
    private let screenshotCellDidSelect = PassthroughSubject<Int, Never>()
    private let unfoldButtonDidTap = PassthroughSubject<Void, Never>()
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
        configureButtons()
        configureHierarchy()
        configureCollectionView()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureButtons() {
        unfoldButton.addTarget(self, action: #selector(touchUpUnfoldButton), for: .touchUpInside)
    }
    
    @objc
    private func touchUpUnfoldButton() {
        unfoldButtonDidTap.send(())
    }
    
    private func configureHierarchy() {
        mainStackView.delegate = self
        
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(scrollContentStackView)
        scrollContentStackView.addArrangedSubview(mainStackView)
        scrollContentStackView.addArrangedSubview(summaryUpperlineView)
        scrollContentStackView.addArrangedSubview(summaryScrollView)
        scrollContentStackView.addArrangedSubview(screenshotUpperlineView)
        scrollContentStackView.addArrangedSubview(screenshotDescriptionLabel)
        scrollContentStackView.addArrangedSubview(screenshotCollectionView)
        scrollContentStackView.addArrangedSubview(descriptionUpperlineView)
        scrollContentStackView.addArrangedSubview(descriptionLabel)
        view.addSubview(unfoldButton)
        scrollContentStackView.addArrangedSubview(infoUpperlineView)
        scrollContentStackView.addArrangedSubview(infoDescriptionLabel)
        scrollContentStackView.addArrangedSubview(infoTableView)
        
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
            
            // FIXME: iPad에서 ScrollView 너비가 화면에 꽉차게 수정
            summaryUpperlineView.heightAnchor.constraint(equalToConstant: 0.5),
            summaryScrollView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.18),
            summaryScrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: summaryScrollView.heightAnchor),
            
            screenshotUpperlineView.heightAnchor.constraint(equalToConstant: 0.5),
            screenshotCollectionView.heightAnchor.constraint(
                equalTo: screenshotCollectionView.widthAnchor,
                multiplier: 1
            ),
            
            descriptionUpperlineView.heightAnchor.constraint(equalToConstant: 0.5),
            unfoldButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            unfoldButton.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 7),
            unfoldButton.heightAnchor.constraint(equalToConstant: unfoldButton.intrinsicContentSize.height - 3),
            unfoldButton.widthAnchor.constraint(equalToConstant: unfoldButton.intrinsicContentSize.width + 12),
            
            infoUpperlineView.heightAnchor.constraint(equalToConstant: 0.5),
            infoTableView.heightAnchor.constraint(equalTo: infoTableView.widthAnchor, multiplier: 0.7)
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

    private func configureTableView() {
        infoTableView.register(cellType: InfoCell.self)
        infoTableView.dataSource = self
    }
}

// MARK: - Combine Binding Methods
extension DetailViewController {
    private func bind() {
        let input = DetailViewModel.Input(
            leftBarButtonDidTap: leftBarButtonDidTap.eraseToAnyPublisher(),
            sharebuttonDidTap: shareButtonDidtap.eraseToAnyPublisher(),
            screenshotCellDidSelect: screenshotCellDidSelect.eraseToAnyPublisher(),
            unfoldButtonDidTap: unfoldButtonDidTap.eraseToAnyPublisher()
        )

        guard let output = viewModel?.transform(input) else { return }

        configureUIContents(with: output.appItem)
        configureActivityViewController(with: output.appShareActivityItems)
        toggleDescriptionLabelHeight(with: output.isDescriptionLabelUnfolded)
    }
    
    private func configureUIContents(with outputPublisher: AnyPublisher<AppItem, Never>) {
        outputPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] appItem in
                self?.setupUI(appItem)
            })
            .store(in: &cancellableBag)
    }

    private func setupUI(_ appItem: AppItem) {
        mainStackView.apply(
            appIconURL: appItem.artworkURL100,
            title: appItem.trackName,
            genre: appItem.primaryGenreName
        )
        
        summaryScrollView.apply(appItem)
        
        screenshotURLs = appItem.screenshotURLs
        screenshotCollectionView.reloadData()  // TODO: Combine DataSources 사용하여 개선 가능
        
        descriptionLabel.text = appItem.appDescription
        
        let fileSizeMegaBytes = (Double(appItem.fileSizeBytes) ?? 0) / Double(1024 * 1024)
        let fileSizeText = String(format: "%.1f", fileSizeMegaBytes) + "MB"
        let languageDescription = appItem.languageCodesISO2A.joined(separator: " & ")  // TODO: Localization
        let appItemInfoContents = [
            appItem.artistName, fileSizeText, languageDescription, appItem.contentAdvisoryRating, appItem.formattedPrice
        ]
        infoContents.append(contentsOf: appItemInfoContents)
        infoTableView.reloadData()  // TODO: Combine DataSources 사용하여 개선 가능
    }
    
    private func configureActivityViewController(with outputPublisher: AnyPublisher<[String], Never>) {
        outputPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] appShareActivityItems in
                guard
                    let appIconURL = appShareActivityItems[safe: 0],
                    let trackName = appShareActivityItems[safe: 1],
                    let genreName = appShareActivityItems[safe: 2],
                    let trackViewURL = appShareActivityItems[safe: 3]
                else { return }
                
                let items = [AppShareActivityItemSource(
                    appIconURL: appIconURL, 
                    trackName: trackName,
                    genreName: genreName,
                    trackViewURL: trackViewURL
                )]
                
                let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self?.mainStackView.shareButton
                activityViewController.popoverPresentationController?.sourceRect = self?.mainStackView.shareButton.bounds ?? CGRect()
                activityViewController.popoverPresentationController?.permittedArrowDirections = .up
                self?.present(activityViewController, animated: true)
            })
            .store(in: &cancellableBag)
    }
    
    private func toggleDescriptionLabelHeight(with outputPublisher: AnyPublisher<Bool, Never>) {
        outputPublisher
            .sink { [weak self] isDescriptionLabelUnfolded in
                if isDescriptionLabelUnfolded {
                    self?.unfoldButton.setTitle(Text.unfoldButtonTitleForFolding, for: .normal)
                    self?.descriptionLabel.numberOfLines = 0
                } else {
                    self?.unfoldButton.setTitle(Text.unfoldButtonTitleForUnfolding, for: .normal)
                    self?.descriptionLabel.numberOfLines = 2
                }
            }
            .store(in: &cancellableBag)
    }
}

// MARK: - CollectionView DataSource
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotURLs.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ScreenshotCell.self, for: indexPath) 
        cell.apply(screenshotURL: screenshotURLs[indexPath.row])
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        screenshotCellDidSelect.send(indexPath.row)
    }
}

// MARK: - TableView DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InfoComponents.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: InfoCell.self, for: indexPath)
        let category = InfoComponents.allCases[indexPath.row].title
        guard let content = infoContents[safe: indexPath.row] else { return InfoCell() }
        
        cell.apply(
            category: category,
            content: content
        )
        
        return cell
    }
}

// MARK: - AppShareActivityViewPresenterDelegate
extension DetailViewController: AppShareActivityViewPresenterDelegate {
    func shareButtonDidTap() {
        shareButtonDidtap.send(())
    }
}

// MARK: - NameSpaces
extension DetailViewController {
    private enum Text {
        static let screenshotDescriptionLabelText: String = "미리보기"
        static let infoDescriptionLabelText: String = "정보"
        static let unfoldButtonTitleForUnfolding: String = "펼치기"
        static let unfoldButtonTitleForFolding: String = "접기"
    }
    
    private enum Design {
        static let scrollContentStackViewHorizontalInset: CGFloat = 12
        static let scrollContentStackViewVerticalInset: CGFloat = 12
        static let scrollContentStackViewSpacing: CGFloat = 16
        static let upperlineViewBackgroundColor: UIColor = .systemGray3
    }
}
