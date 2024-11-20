import UIKit

// MARK: - SearchViewController
class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let searchTextField = UITextField()
    private var tags: [String] = ["단양 카페", "안동 카페", "파주 카페", "세븐틴 카페", "부승관 카페", "곰돌이 카페", "고양이 카페"]
    
    private let tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var tagCollectionViewHeightConstraint: NSLayoutConstraint!
    
    private let searchContainerView = UIView()
    private let searchIconView = UIImageView(image: UIImage(named: "icon_search"))
    private let clearButton = UIButton()
    
    private let customNavBar: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_back"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update height constraint to match content size
        tagCollectionViewHeightConstraint.constant = tagCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        tagCollectionView.backgroundColor = .clear
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupSearchBar()
        
        // Create a stack view for Tag Header and Tag Collection
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Add Tag Header View
        let tagHeaderView = setupTagHeaderView()
        stackView.addArrangedSubview(tagHeaderView)
        
        // Add Tag Collection View
        stackView.addArrangedSubview(tagCollectionView)
        
        // Set collection view constraints
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        tagCollectionView.backgroundColor = .blue
        tagCollectionViewHeightConstraint = tagCollectionView.heightAnchor.constraint(equalToConstant: 0)
        tagCollectionViewHeightConstraint.isActive = true

        // Add border below the stack view
        let borderView = UIView()
        borderView.backgroundColor = UIColor(hex: "#111111").withAlphaComponent(0.06)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(borderView)

        // Add Stack View and Border Constraints
        NSLayoutConstraint.activate([
            // Stack View Constraints
            stackView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Border Constraints
            borderView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20), // 20px below the stackView
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 5) // 5px height
        ])
    }

    private func setupNavigationBar() {
        view.addSubview(customNavBar)
        customNavBar.addArrangedSubview(backButton)
        customNavBar.addArrangedSubview(searchContainerView)
        
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        // Add border below navigation bar
        let navBarBorder = UIView()
        navBarBorder.backgroundColor = UIColor(hex: "#111111").withAlphaComponent(0.2)
        navBarBorder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarBorder)
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customNavBar.heightAnchor.constraint(equalToConstant: 60),
            
            navBarBorder.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            navBarBorder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarBorder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarBorder.heightAnchor.constraint(equalToConstant: 0.75)
        ])
    }
    
    private func setupSearchBar() {
        searchContainerView.layer.cornerRadius = 18
        searchContainerView.backgroundColor = UIColor(hex: "#111111").withAlphaComponent(0.06)
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        searchIconView.contentMode = .scaleAspectFit
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchIconView)
        
        searchTextField.placeholder = "지역, 공간, 메뉴 검색"
        searchTextField.borderStyle = .none
        searchTextField.isUserInteractionEnabled = true
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchTextField)
        
        clearButton.setImage(UIImage(named: "icon_search_x"), for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),
            
            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 12),
            searchIconView.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 20),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: 8),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            
            clearButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 8),
            clearButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -12),
            clearButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupTagHeaderView() -> UIView {
        // Header View
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Title Label ("최근 검색어")
        let titleLabel = UILabel()
        titleLabel.text = "최근 검색어"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        // Delete Button ("전체삭제")
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("전체삭제", for: .normal)
        deleteButton.setTitleColor(UIColor.lightGray, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(handleDeleteAll), for: .touchUpInside)
        headerView.addSubview(deleteButton)

        // Constraints for Header View
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            // Delete Button Constraints
            deleteButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            // Header View Height
            headerView.heightAnchor.constraint(equalToConstant: 40)
        ])

        return headerView
    }

    private func setupTagCollectionView() {
        view.addSubview(tagCollectionView)
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        tagCollectionView.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            tagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
    
    // MARK: - Actions
    @objc private func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleDeleteAll() {
        tags.removeAll() // Clear all tags
        tagCollectionView.reloadData() // Refresh collection view
        print("전체 태그 삭제됨")
    }
}

// MARK: - thickBottomBorder
extension UIView {
    func addThickBottomBorder(color: UIColor, height: CGFloat, bottomSpacing: CGFloat = 0) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)

        NSLayoutConstraint.activate([
            border.heightAnchor.constraint(equalToConstant: height),
            border.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            border.topAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomSpacing)
        ])

        return border
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let tag = tags[indexPath.item]

        // Configure the cell
        cell.configure(with: tag) { [weak self] in
            guard let self = self else { return }
//            self.tags.remove(at: indexPath.item)
//            self.tagCollectionView.deleteItems(at: [indexPath])
            print("\(tag) 태그 삭제 버튼 클릭")
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tags[indexPath.item]
        
        // Calculate label width dynamically
        let labelWidth = tag.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]).width
        let buttonWidth: CGFloat = 16 // Close button width
        let spacing: CGFloat = 12 + 4 + 12 // Leading + Spacing between label and button + Trailing

        return CGSize(width: labelWidth + buttonWidth + spacing, height: 32) // Dynamic width, fixed height
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = tags[indexPath.item]
        print("\(tag) 태그 클릭")
    }
}

// MARK: - TagCell
class TagCell: UICollectionViewCell {
    private let tagLabel = UILabel()
    private let closeButton = UIButton(type: .custom) // Close button
    
    var onCloseButtonTapped: (() -> Void)? // Callback for close button tap
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor(hex: "#111111").withAlphaComponent(0.1).cgColor // 10% transparent #111111
        contentView.layer.borderWidth = 1 // Border thickness
        
        tagLabel.font = UIFont.systemFont(ofSize: 14)
        tagLabel.lineBreakMode = .byClipping // Prevent ellipsis
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagLabel)
        
        // Configure close button
        closeButton.setImage(UIImage(named: "icon_x"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        contentView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            // Tag label constraints
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            // Adjust spacing between tagLabel and closeButton
            closeButton.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 4), // 4px gap
            closeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // Close button constraints
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(with tag: String, onClose: @escaping () -> Void) {
        tagLabel.text = tag
        self.onCloseButtonTapped = onClose
    }

    @objc private func closeButtonTapped() {
        onCloseButtonTapped?()
    }
}
