//
//  ViewController.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/04.
//

import UIKit
import Combine

final class LookupViewController: UIViewController {
    // MARK: - Properties
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Text.searchTextFieldPlaceHolder
        textField.returnKeyType = .search
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        return textField
    }()
    private let descriptionLabel: UILabel = {  // TODO: Alert로 대체 가능
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemRed
        return label
    }()
    
    private var viewModel: LookupViewModel!
    private let textFieldDidReturn = PassthroughSubject<String, Never>()
    private var cancellableBag = Set<AnyCancellable>()
    
    // MARK: - Initializers
    convenience init(viewModel: LookupViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDescriptionLabel()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Methods
    private func configureUI() {
        configureNavigationBar()
        configureSearchTextField()
        configureHierarchy()
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Text.navigationTitle
        navigationItem.backButtonTitle = Design.backButtonTitle
    }
    
    private func configureSearchTextField() {
        searchTextField.delegate = self
    }
    
    private func configureHierarchy() {
        view.addSubview(searchTextField)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
        ])
    }
    
    private func updateDescriptionLabel() {
        descriptionLabel.text = Text.emptyString
    }
}

// MARK: - Combine Binding Methods
extension LookupViewController {
    private func bind() {
        let input = LookupViewModel.Input(searchTextDidReturn: textFieldDidReturn.eraseToAnyPublisher())

        guard let output = viewModel?.transform(input) else { return }
        
        configureSearchTextViewAndLabel(with: output.isAPIResponseValid)
    }
    
    private func configureSearchTextViewAndLabel(
        with isAPIResponseValid: AnyPublisher<Bool, Never>
    ) {
        isAPIResponseValid
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isAPIResponseValid in
                if isAPIResponseValid == false {
                    self?.descriptionLabel.text = Text.descriptionLabelTextIfRequestFail
                }
            })
            .store(in: &cancellableBag)
    }
}

// MARK: - TextFieldDelegate
extension LookupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text else {
            return false
        }
        textFieldDidReturn.send(searchText)
        
        return true
    }
}

// MARK: - NameSpaces
extension LookupViewController {
    private enum Text {
        static let navigationTitle = "App Lookup"
        static let searchTextFieldPlaceHolder = "앱 ID를 입력해주세요."
        static let descriptionLabelTextIfRequestFail = "앱 ID를 다시 확인해주세요."
        static let emptyString = ""
    }
    
    private enum Design {
        static let backButtonTitle = "검색"
    }
}
