import UIKit

// MARK: - SearchViewController
class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let searchTextField = UITextField()
    private var recentTags: [String] = ["단양 카페", "안동 카페", "파주 카페", "세븐틴 카페", "승관 카페", "곰돌이 카페", "고양이 카페"]
    private var recommemdedTags: [String] = ["파주 스테이", "파주 카페", "파주 맛집", "단양 숙소", "단양 맛집", "단양 기념품", "부산 카페"]
    private var popularSearches: [String] = ["성수", "강릉", "속초", "행궁동", "북카페", "드라이브", "경주", "파주", "제주도", "감자빵"]
    
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
    
    private var recentCollectionViewHeightConstraint: NSLayoutConstraint!
    
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
        stackView.spacing = 16
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
        
        // Create a stack view for Tag Header and Tag Collection
        let recommendedStackView = UIStackView()
        recommendedStackView.axis = .vertical
        recommendedStackView.alignment = .fill
        recommendedStackView.spacing = 16
        recommendedStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recommendedStackView)
        
        // Add Tag Header View
        let recommendedHeaderView = setupRecommendedHeaderView()
        recommendedStackView.addArrangedSubview(recommendedHeaderView)
        
        // 최근 태그 추가
        let recommendedTagsView = setupRecommendedTags()
        recommendedStackView.addArrangedSubview(recommendedTagsView)
        
        // Add border below the stack view
        let secondBorderView = UIView()
        secondBorderView.backgroundColor = UIColor(hex: "#111111").withAlphaComponent(0.06)
        secondBorderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondBorderView)
        
        // Create a stack view for Tag Header and Tag Collection
        let popularSearchesStackView = UIStackView()
        popularSearchesStackView.axis = .vertical
        popularSearchesStackView.alignment = .fill
        popularSearchesStackView.spacing = 16
        popularSearchesStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popularSearchesStackView)
        
        // Add Tag Header View
        let popularSearchesHeaderView = setupPopularSearchesHeaderView()
        popularSearchesStackView.addArrangedSubview(popularSearchesHeaderView)
        
        // 최근 태그 추가
        let popularSearchesTagsView = setupPopularSearches()
        popularSearchesStackView.addArrangedSubview(popularSearchesTagsView)
        
        // Add Stack View and Border Constraints
        NSLayoutConstraint.activate([
            // Stack View Constraints
            stackView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Border Constraints
            borderView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20), // 20px below the stackView
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 5), // 5px height
            
            // Stack View Constraints
            recommendedStackView.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 16),
            recommendedStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recommendedStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            secondBorderView.topAnchor.constraint(equalTo: recommendedStackView.bottomAnchor, constant: 20), // 20px below the stackView
            secondBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondBorderView.heightAnchor.constraint(equalToConstant: 5),
            
            // Stack View Constraints
            popularSearchesStackView.topAnchor.constraint(equalTo: secondBorderView.bottomAnchor, constant: 16),
            popularSearchesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            popularSearchesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
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
        searchTextField.font = UIFont(name: "Pretendard-Regular", size: 14)
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
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 18)
        titleLabel.textColor = UIColor(hex: "#1E1E1E")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        // Delete Button ("전체삭제")
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("전체삭제", for: .normal)
        deleteButton.setTitleColor(UIColor(hex: "#A5A5A5"), for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
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
    
    private func setupRecommendedHeaderView() -> UIView {
        // Header View
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Title Label ("추천 검색어")
        let titleLabel = UILabel()
        titleLabel.text = "추천 검색어"
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 18)
        titleLabel.textColor = UIColor(hex: "#1E1E1E")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        // Constraints for Header View
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            // Header View Height
            headerView.heightAnchor.constraint(equalToConstant: 40)
        ])

        return headerView
    }
    
    private func setupRecommendedTags() -> UIView {
        // 전체 태그들을 수직으로 쌓을 컨테이너 뷰 생성
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // 수직 스택뷰 생성
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 12 // 컨테이너 뷰 간의 간격
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(verticalStackView)

        // 첫 번째 태그 그룹 (0~2번)
        let firstContainerView = createTagsContainerView(from: recommemdedTags[0...2])
        verticalStackView.addArrangedSubview(firstContainerView)

        // 두 번째 태그 그룹 (3~6번)
        let secondContainerView = createTagsContainerView(from: recommemdedTags[3...6])
        verticalStackView.addArrangedSubview(secondContainerView)

        // 수직 스택뷰 제약 조건 설정
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }

    private func createTagsContainerView(from tags: ArraySlice<String>) -> UIView {
        // 태그들을 담을 컨테이너 뷰 생성
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // 태그 버튼들을 담을 가로 스택뷰 생성
        let tagsStackView = UIStackView()
        tagsStackView.axis = .horizontal
        tagsStackView.spacing = 8 // 버튼 간의 간격
        tagsStackView.alignment = .center
        tagsStackView.distribution = .fill
        tagsStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tagsStackView)

        // 태그를 버튼으로 추가
        for tag in tags {
            let tagButton = UIButton(type: .system)
            tagButton.setTitle(tag, for: .normal)
            tagButton.setTitleColor(UIColor(hex: "#6B7D5C"), for: .normal)
            tagButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 13)
            tagButton.backgroundColor = UIColor(hex: "#EBF3E4") // 연한 초록 배경
            tagButton.layer.cornerRadius = 16
            tagButton.layer.borderWidth = 1
            tagButton.layer.borderColor = UIColor(hex: "#D1E1C3").cgColor
            tagButton.translatesAutoresizingMaskIntoConstraints = false

            // 버튼 크기 설정
            tagButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            tagButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            
            // 버튼 클릭 이벤트 추가
            tagButton.addTarget(self, action: #selector(handleTagButtonClick(_:)), for: .touchUpInside)

            // 버튼에 태그를 식별할 수 있는 값을 설정
            tagButton.accessibilityLabel = tag

            // 버튼을 스택뷰에 추가
            tagsStackView.addArrangedSubview(tagButton)
        }

        // 스택뷰의 레이아웃 제약 조건 설정
        NSLayoutConstraint.activate([
            tagsStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tagsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tagsStackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
            tagsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }
    
    private func setupPopularSearchesHeaderView() -> UIView {
        // Header View
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Title Label ("인기 검색어")
        let titleLabel = UILabel()
        titleLabel.text = "인기 검색어"
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 18)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // 운영 시간 기준
        let updateLabel = UILabel()
        updateLabel.text = "08.26 02:00 기준"
        updateLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        updateLabel.textColor = UIColor(hex: "#A5A5A5")
        updateLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(updateLabel)

        // Constraints for Header View
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            // Delete Button Constraints
            updateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            updateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            // Header View Height
            headerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return headerView
    }
    
    private func setupPopularSearches() -> UIView {
        // 전체 컨테이너 뷰 생성
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // 가로 스택뷰 생성
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 16 // 두 세로 스택뷰 간 간격
        horizontalStackView.alignment = .top
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(horizontalStackView)

        // 첫 번째 세로 스택뷰 생성 (1~5)
        let leftVerticalStackView = createVerticalStackView(from: popularSearches[0..<5], startIndex: 1)
        horizontalStackView.addArrangedSubview(leftVerticalStackView)

        // 두 번째 세로 스택뷰 생성 (6~10)
        let rightVerticalStackView = createVerticalStackView(from: popularSearches[5..<10], startIndex: 6)
        horizontalStackView.addArrangedSubview(rightVerticalStackView)

        // 레이아웃 제약 조건 설정
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }

    private func createVerticalStackView(from searches: ArraySlice<String>, startIndex: Int) -> UIStackView {
        // 세로 스택뷰 생성
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 16 // 각 항목 간 간격
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        // 검색 항목 추가
        for (index, search) in searches.enumerated() {
            // 가로 스택뷰 생성
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 16 // 번호와 텍스트 간 간격
            horizontalStackView.alignment = .leading
            horizontalStackView.distribution = .fill
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

            // 번호(Label 1)
            let indexLabel = UILabel()
            indexLabel.text = "\(startIndex + index)"
            indexLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
            indexLabel.textColor = UIColor(hex: "#365C16")
            indexLabel.translatesAutoresizingMaskIntoConstraints = false

            // 검색어(Label 2)
            let searchLabel = UILabel()
            searchLabel.text = search
            searchLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
            searchLabel.textColor = UIColor(hex: "#111111")
            searchLabel.translatesAutoresizingMaskIntoConstraints = false

            // 두 개의 Label을 가로 스택뷰에 추가
            horizontalStackView.addArrangedSubview(indexLabel)
            horizontalStackView.addArrangedSubview(searchLabel)

            // 가로 스택뷰를 세로 스택뷰에 추가
            verticalStackView.addArrangedSubview(horizontalStackView)
        }

        return verticalStackView
    }
    
    // MARK: - Actions
    @objc private func handleBackButton() {
        // 모달로 표시된 현재 ViewController 닫기
            self.dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleDeleteAll() {
        recentTags.removeAll() // Clear all tags
        tagCollectionView.reloadData() // Refresh collection view
        print("전체 태그 삭제됨")
    }
    
    // 버튼 클릭 이벤트 핸들러
    @objc private func handleTagButtonClick(_ sender: UIButton) {
        if let tag = sender.accessibilityLabel {
            print("\(tag) 태그 클릭")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let tag = recentTags[indexPath.item]

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
        let tag = recentTags[indexPath.item]
        
        // Calculate label width dynamically
        let labelWidth = tag.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]).width
        let buttonWidth: CGFloat = 16 // Close button width
        let spacing: CGFloat = 12 + 4 + 12 // Leading + Spacing between label and button + Trailing

        return CGSize(width: labelWidth + buttonWidth + spacing, height: 32) // Dynamic width, fixed height
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = recentTags[indexPath.item]
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
        
        tagLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        tagLabel.textColor = UIColor(hex: "111111").withAlphaComponent(0.55)
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
