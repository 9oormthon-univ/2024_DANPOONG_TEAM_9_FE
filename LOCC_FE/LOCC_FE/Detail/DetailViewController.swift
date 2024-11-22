import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        // Scroll View 및 Content View 설정
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // 각 섹션 생성
        let basicInfoSection = createBasicInfoSection() // 빨강
        let reviewSection = createReviewSection() // 주황
        let additionalInfoSection = createAdditionalInfoSection() // 노랑
        let detailedInfoSection = createDetailedInfoSection() // 초록
        let locationSection = createLocationSection() // 파랑
        let nearbyPlacesSection = createNearbyPlacesSection() // 남색

        let sections = [basicInfoSection, reviewSection, additionalInfoSection, detailedInfoSection, locationSection, nearbyPlacesSection]
        sections.forEach { contentView.addSubview($0) }

        // Scroll View 제약 조건 설정
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // 가로 크기 고정
        ])

        // 섹션 배치
        var previousSection: UIStackView?
        for section in sections {
            NSLayoutConstraint.activate([
                section.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                section.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])

            // 각 섹션 높이 설정
            if section == basicInfoSection {
                section.heightAnchor.constraint(equalToConstant: 324).isActive = true
            }

            if let previous = previousSection {
                section.topAnchor.constraint(equalTo: previous.bottomAnchor).isActive = true
            } else {
                section.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            }

            previousSection = section
        }

        // 마지막 섹션의 bottomAnchor를 contentView의 bottomAnchor에 연결
        if let lastSection = sections.last {
            lastSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }

    // 1. 가게 기본 정보 섹션
    private func createBasicInfoSection() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.backgroundColor = .red
        stackView.layer.cornerRadius = 0
        stackView.clipsToBounds = true

        // 고정 높이 설정 (324)
        stackView.heightAnchor.constraint(equalToConstant: 324).isActive = true

        // Header Container View
        let headerContainerView = UIView()
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Header (Horizontal StackView)
        let headerStackView = UIStackView()
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .horizontal
        headerStackView.distribution = .equalSpacing
        headerStackView.alignment = .center

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "icon_back"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        headerStackView.addArrangedSubview(backButton)

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.addArrangedSubview(spacer)

        let scrapButton = UIButton()
        scrapButton.setImage(UIImage(named: "icon_scrap_unselected"), for: .normal)
        scrapButton.translatesAutoresizingMaskIntoConstraints = false
        scrapButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        scrapButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        headerStackView.addArrangedSubview(scrapButton)

        // Header StackView를 Header Container View에 추가
        headerContainerView.addSubview(headerStackView)

        // Header StackView 레이아웃 설정
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -8),
            headerStackView.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Header Container View를 StackView에 추가
        stackView.addArrangedSubview(headerContainerView)

        // Basic Info Container View
        let basicInfoContainerView = UIView()
        basicInfoContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Vertical StackView for Basic Info
        let basicInfoStackView = UIStackView()
        basicInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        basicInfoStackView.axis = .vertical
        basicInfoStackView.distribution = .fill
        basicInfoStackView.alignment = .fill
        basicInfoStackView.spacing = 8

        // 가게 카테고리 Label
        let categoryLabel = UILabel()
        categoryLabel.text = "카페"
        categoryLabel.textAlignment = .left
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        basicInfoStackView.addArrangedSubview(categoryLabel)

        // 가게 이름 Label
        let nameLabel = UILabel()
        nameLabel.text = "로슈아커피"
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        basicInfoStackView.addArrangedSubview(nameLabel)

        // Status Container View
        let statusContainerView = UIView()
        statusContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Horizontal StackView for Status
        let statusStackView = UIStackView()
        statusStackView.translatesAutoresizingMaskIntoConstraints = false
        statusStackView.axis = .horizontal
        statusStackView.distribution = .fill
        statusStackView.alignment = .center
        statusStackView.spacing = 8

        // 영업중 Label
        let statusLabel = UILabel()
        statusLabel.text = "영업중"
        statusLabel.textAlignment = .left
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        statusStackView.addArrangedSubview(statusLabel)

        // 영업 종료 시간 Label
        let closingTimeLabel = UILabel()
        closingTimeLabel.text = "오후 10:00에 영업 종료"
        closingTimeLabel.textAlignment = .left
        closingTimeLabel.textColor = .white
        closingTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        statusStackView.addArrangedSubview(closingTimeLabel)

        // Status StackView를 Status Container View에 추가
        statusContainerView.addSubview(statusStackView)

        // Status StackView 레이아웃 설정
        NSLayoutConstraint.activate([
            statusStackView.topAnchor.constraint(equalTo: statusContainerView.topAnchor),
            statusStackView.leadingAnchor.constraint(equalTo: statusContainerView.leadingAnchor),
            statusStackView.trailingAnchor.constraint(lessThanOrEqualTo: statusContainerView.trailingAnchor), // 왼쪽 정렬
            statusStackView.bottomAnchor.constraint(equalTo: statusContainerView.bottomAnchor)
        ])

        // Status Container View를 Basic Info StackView에 추가
        basicInfoStackView.addArrangedSubview(statusContainerView)

        // Basic Info StackView를 Basic Info Container View에 추가
        basicInfoContainerView.addSubview(basicInfoStackView)

        // Basic Info StackView 레이아웃 설정
        NSLayoutConstraint.activate([
            basicInfoStackView.leadingAnchor.constraint(equalTo: basicInfoContainerView.leadingAnchor),
            basicInfoStackView.trailingAnchor.constraint(equalTo: basicInfoContainerView.trailingAnchor),
            basicInfoStackView.bottomAnchor.constraint(equalTo: basicInfoContainerView.bottomAnchor)
        ])

        // Basic Info Container View를 StackView의 맨 아래에 추가
        stackView.addArrangedSubview(basicInfoContainerView)

        return stackView
    }

    // 2. 후기 섹션
    private func createReviewSection() -> UIStackView {
        let reviewStackView = UIStackView()
        reviewStackView.translatesAutoresizingMaskIntoConstraints = false
        reviewStackView.axis = .vertical
        reviewStackView.distribution = .fill
        reviewStackView.alignment = .fill
        reviewStackView.spacing = 8
        reviewStackView.backgroundColor = .orange
        reviewStackView.clipsToBounds = true

        // Section Title Container
        let sectionTitleContainer = UIView()
        sectionTitleContainer.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true // 컨테이너 높이 설정

        // 섹션 제목
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.text = "후기"
        sectionTitleLabel.textAlignment = .left
        sectionTitleLabel.textColor = .white
        sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)

        // Section Title Layout
        sectionTitleContainer.addSubview(sectionTitleLabel)
        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: sectionTitleContainer.topAnchor),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: sectionTitleContainer.leadingAnchor, constant: 16),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: sectionTitleContainer.trailingAnchor, constant: -16),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: sectionTitleContainer.bottomAnchor)
        ])

        // Section Title을 가장 위에 추가
        reviewStackView.addArrangedSubview(sectionTitleContainer)

        // 별점 및 후기 정보
        let ratingInfoStackView = createRatingInfoStackView()
        reviewStackView.addArrangedSubview(ratingInfoStackView)

        // 가로 스크롤 가능한 후기 카드
        let reviewCardScrollView = createReviewCardScrollView()
        reviewStackView.addArrangedSubview(reviewCardScrollView)

        return reviewStackView
    }

    // 별점 및 후기 정보
    private func createRatingInfoStackView() -> UIStackView {
        let ratingInfoStackView = UIStackView()
        ratingInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingInfoStackView.axis = .horizontal
        ratingInfoStackView.distribution = .fill
        ratingInfoStackView.alignment = .center
        ratingInfoStackView.spacing = 8

        // 별점 Horizontal StackView
        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.distribution = .fillEqually
        starStackView.alignment = .center
        starStackView.spacing = 4
        for _ in 1...5 {
            let starImageView = UIImageView(image: UIImage(named: "icon_star"))
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            starStackView.addArrangedSubview(starImageView)
        }

        // 별점 정보
        let ratingLabel = UILabel()
        ratingLabel.text = "4.4"
        ratingLabel.textColor = .white
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 16)

        let maxRatingLabel = UILabel()
        maxRatingLabel.text = "/5"
        maxRatingLabel.textColor = .white
        maxRatingLabel.font = UIFont.systemFont(ofSize: 14)

        // 총 후기 개수
        let reviewCountLabel = UILabel()
        reviewCountLabel.text = "(273)"
        reviewCountLabel.textColor = .white
        reviewCountLabel.font = UIFont.systemFont(ofSize: 14)

        // 전체 보기 버튼
        let viewAllButton = UIButton()
        viewAllButton.setTitle("전체보기 >", for: .normal)
        viewAllButton.setTitleColor(.white, for: .normal)
        viewAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        // 왼쪽 정보 스택
        let leftInfoStackView = UIStackView(arrangedSubviews: [starStackView, ratingLabel, maxRatingLabel, reviewCountLabel])
        leftInfoStackView.axis = .horizontal
        leftInfoStackView.spacing = 8
        leftInfoStackView.alignment = .center

        // 오른쪽 버튼
        ratingInfoStackView.addArrangedSubview(leftInfoStackView)
        ratingInfoStackView.addArrangedSubview(UIView()) // Spacer
        ratingInfoStackView.addArrangedSubview(viewAllButton)

        return ratingInfoStackView
    }

    // 후기 카드 스크롤 뷰
    private func createReviewCardScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false

        // ScrollView 높이 고정
        scrollView.heightAnchor.constraint(equalToConstant: 224).isActive = true

        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .horizontal
        contentView.spacing = 16
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        // 샘플 후기 카드
        for i in 1...3 {
            let cardView = createReviewCard(
                profileImage: UIImage(named: "image6"), // 유저 프로필 이미지 (샘플 이미지 사용)
                userName: "유저 \(i)",
                rating: 4.5,
                reviewText: "옥수수빵이 진짜 큰데 맛도리뱅뱅임. 차 2시간 타고 올만 하다 이거임.",
                images: [
                    UIImage(named: "image1") ?? UIImage(),
                    UIImage(named: "image2") ?? UIImage(),
                    UIImage(named: "image3") ?? UIImage()
                ]
            )
            contentView.addArrangedSubview(cardView)
        }

        return scrollView
    }

    // 후기 카드 생성
    private func createReviewCard(profileImage: UIImage?, userName: String, rating: Double, reviewText: String, images: [UIImage]) -> UIView {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .darkGray
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
        cardView.heightAnchor.constraint(equalToConstant: 224).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: 240).isActive = true

        let verticalStackView = UIStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 12
        verticalStackView.alignment = .fill
        cardView.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])

        // 1. 유저 정보 (프로필 사진, 유저 이름, 별점)
        let userInfoStackView = UIStackView()
        userInfoStackView.axis = .horizontal
        userInfoStackView.spacing = 8
        userInfoStackView.alignment = .center

        let profileImageView = UIImageView(image: profileImage)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let userNameLabel = UILabel()
        userNameLabel.text = userName
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 14)

        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.spacing = 2
        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(named: "icon_star"))
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            starStackView.addArrangedSubview(starImageView)
        }

        userInfoStackView.addArrangedSubview(profileImageView)
        userInfoStackView.addArrangedSubview(userNameLabel)
        userInfoStackView.addArrangedSubview(starStackView)
        verticalStackView.addArrangedSubview(userInfoStackView)

        // 2. 후기 텍스트와 아이콘
        let reviewTextContainer = UIStackView()
        reviewTextContainer.translatesAutoresizingMaskIntoConstraints = false
        reviewTextContainer.axis = .vertical
        reviewTextContainer.spacing = 8
        reviewTextContainer.alignment = .leading

        // 아이콘 (icon_)
        let reviewIcon = UIImageView(image: UIImage(named: "icon_quotes")) // "icon_quotes"에 해당하는 이미지
        reviewIcon.translatesAutoresizingMaskIntoConstraints = false
        reviewIcon.contentMode = .scaleAspectFit
        reviewIcon.widthAnchor.constraint(equalToConstant: 15).isActive = true
        reviewIcon.heightAnchor.constraint(equalToConstant: 11).isActive = true

        // 후기 텍스트
        let reviewTextLabel = UILabel()
        reviewTextLabel.text = reviewText
        reviewTextLabel.textColor = .white
        reviewTextLabel.font = UIFont.systemFont(ofSize: 14)
        reviewTextLabel.numberOfLines = 0
        reviewTextLabel.textAlignment = .center

        // 컨테이너에 추가
        reviewTextContainer.addArrangedSubview(reviewIcon)
        reviewTextContainer.addArrangedSubview(reviewTextLabel)
        verticalStackView.addArrangedSubview(reviewTextContainer)

        // 3. 이미지 컨테이너
        let imageStackView = UIStackView()
        imageStackView.axis = .horizontal
        imageStackView.spacing = 8
        imageStackView.alignment = .center

        for image in images {
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            imageStackView.addArrangedSubview(imageView)
        }

        verticalStackView.addArrangedSubview(imageStackView)

        return cardView
    }
    
    // 3. 부가 정보 섹션
    private func createAdditionalInfoSection() -> UIStackView {
        let additionalInfoStackView = UIStackView()
        additionalInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalInfoStackView.axis = .vertical
        additionalInfoStackView.distribution = .fill
        additionalInfoStackView.alignment = .fill
        additionalInfoStackView.spacing = 16
        additionalInfoStackView.backgroundColor = .yellow
        additionalInfoStackView.clipsToBounds = true

        // 1. 영업 상태 (icon_clock + "영업중" + 토글 아이콘)
        let businessStatusStack = createBusinessStatusToggleRow()

        // 2. 전화번호 (icon_phone + "070-8807-1987")
        let phoneNumberStack = createHorizontalInfoRow(iconName: "icon_phone", text: "070-8807-1987")

        // 3. SNS 링크 (icon_sns + "http://instagram.com/loshuacoffee")
        let snsLinkStack = createHorizontalInfoRow(iconName: "icon_sns", text: "http://instagram.com/loshuacoffee")

        // Add rows to the vertical stack view
        additionalInfoStackView.addArrangedSubview(businessStatusStack)
        additionalInfoStackView.addArrangedSubview(phoneNumberStack)
        additionalInfoStackView.addArrangedSubview(snsLinkStack)

        return additionalInfoStackView
    }

    // 영업 상태 행 (토글 기능 포함)
    private func createBusinessStatusToggleRow() -> UIStackView {
        let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        containerStackView.alignment = .fill
        containerStackView.spacing = 8

        // Row StackView (icon_clock + "영업중" + toggle)
        let rowStackView = UIStackView()
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fill
        rowStackView.alignment = .center
        rowStackView.spacing = 8

        // Icon
        let iconImageView = UIImageView(image: UIImage(named: "icon_clock"))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // Label
        let textLabel = UILabel()
        textLabel.text = "영업중"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 14)

        // Toggle Button
        let toggleButton = UIButton()
        toggleButton.setImage(UIImage(named: "icon_toggle_down"), for: .normal)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        toggleButton.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // Hidden Container (initially hidden)
        let hiddenContainer = UIView()
        hiddenContainer.translatesAutoresizingMaskIntoConstraints = false
        hiddenContainer.backgroundColor = .white
        hiddenContainer.layer.cornerRadius = 8
        hiddenContainer.clipsToBounds = true
        hiddenContainer.isHidden = true // Initially hidden

        // Add vertical stack view for days and times
        let scheduleStackView = UIStackView()
        scheduleStackView.translatesAutoresizingMaskIntoConstraints = false
        scheduleStackView.axis = .vertical
        scheduleStackView.spacing = 8
        scheduleStackView.alignment = .fill

        // Add rows for each day
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        let time = "11:00-23:00"
        for day in days {
            let dayRowStackView = createHorizontalDayRow(day: day, time: time)
            scheduleStackView.addArrangedSubview(dayRowStackView)
        }

        // Add schedule stack view to hidden container
        hiddenContainer.addSubview(scheduleStackView)
        NSLayoutConstraint.activate([
            scheduleStackView.topAnchor.constraint(equalTo: hiddenContainer.topAnchor, constant: 8),
            scheduleStackView.leadingAnchor.constraint(equalTo: hiddenContainer.leadingAnchor, constant: 16),
            scheduleStackView.trailingAnchor.constraint(equalTo: hiddenContainer.trailingAnchor, constant: -16),
            scheduleStackView.bottomAnchor.constraint(equalTo: hiddenContainer.bottomAnchor, constant: -8)
        ])

        // Add action to toggle button
        toggleButton.addTarget(self, action: #selector(toggleHiddenContainer(_:)), for: .touchUpInside)

        // Add views to the row stack view
        rowStackView.addArrangedSubview(iconImageView)
        rowStackView.addArrangedSubview(textLabel)
        rowStackView.addArrangedSubview(UIView()) // Spacer
        rowStackView.addArrangedSubview(toggleButton)

        // Add rowStackView and hiddenContainer to the containerStackView
        containerStackView.addArrangedSubview(rowStackView)
        containerStackView.addArrangedSubview(hiddenContainer)

        // Connect hiddenContainer for toggling
        toggleButton.accessibilityHint = "hiddenContainer" // 연결을 위해 힌트를 사용
        toggleButton.tag = hiddenContainer.hash // 고유 ID로 컨테이너를 식별

        return containerStackView
    }

    // 하루의 영업 시간을 나타내는 Horizontal Row 생성
    private func createHorizontalDayRow(day: String, time: String) -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        rowStackView.axis = .horizontal
        rowStackView.spacing = 16
        rowStackView.alignment = .center

        // Day Label
        let dayLabel = UILabel()
        dayLabel.text = day
        dayLabel.textColor = .black
        dayLabel.font = UIFont.systemFont(ofSize: 14)
        dayLabel.textAlignment = .left

        // Time Label
        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.textColor = .black
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textAlignment = .right

        // Add to row stack view
        rowStackView.addArrangedSubview(dayLabel)
        rowStackView.addArrangedSubview(UIView()) // Spacer
        rowStackView.addArrangedSubview(timeLabel)

        return rowStackView
    }

    // 토글 동작
    @objc private func toggleHiddenContainer(_ sender: UIButton) {
        guard let superview = sender.superview?.superview as? UIStackView, // containerStackView를 찾기 위해 두 단계 상위로 접근
              let hiddenContainer = superview.arrangedSubviews.first(where: { $0.hash == sender.tag }) as? UIView else {
            return
        }

        if hiddenContainer.isHidden {
            hiddenContainer.isHidden = false
            sender.setImage(UIImage(named: "icon_toggle_up"), for: .normal)
        } else {
            hiddenContainer.isHidden = true
            sender.setImage(UIImage(named: "icon_toggle_down"), for: .normal)
        }
    }

    // 공통으로 사용할 Horizontal Row 생성 함수
    private func createHorizontalInfoRow(iconName: String, text: String) -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fill
        rowStackView.alignment = .center
        rowStackView.spacing = 8

        // Icon
        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // Label
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 14)

        // Add to the row stack view
        rowStackView.addArrangedSubview(iconImageView)
        rowStackView.addArrangedSubview(textLabel)

        return rowStackView
    }
    
    // 4. 상세 정보 섹션
    private func createDetailedInfoSection() -> UIStackView {
        let detailedInfoStackView = UIStackView()
        detailedInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        detailedInfoStackView.axis = .vertical
        detailedInfoStackView.distribution = .fill
        detailedInfoStackView.alignment = .fill
        detailedInfoStackView.spacing = 16
        detailedInfoStackView.backgroundColor = .green
        detailedInfoStackView.clipsToBounds = true

        // 1. 이미지
        let imageView = UIImageView(image: UIImage(named: "image1")) // "image1" 에셋 이미지
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true // 이미지 높이 설정

        // 2. 텍스트
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = """
        커다란 은행나무가 테라스에 있어 멋진 뷰와 함께
        여유롭게 커피를 마실 수 있는 카페입니다.
        가을에 가장 아름다운 모습을 뽐내어 가을에
        꼭 방문해야 하는 공간이에요.

        커다란 은행나무가 테라스에 있어 멋진 뷰와 함께
        여유롭게 커피를 마실 수 있는 카페입니다.
        가을에 가장 아름다운 모습을 뽐내어 가을에
        꼭 방문해야 하는 공간이에요.
        """
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .center

        // Add components to the stack view
        detailedInfoStackView.addArrangedSubview(imageView)
        detailedInfoStackView.addArrangedSubview(descriptionLabel)

        return detailedInfoStackView
    }

    // 5. 위치 안내 섹션
    private func createLocationSection() -> UIStackView {
        let locationSectionStackView = UIStackView()
        locationSectionStackView.translatesAutoresizingMaskIntoConstraints = false
        locationSectionStackView.axis = .vertical
        locationSectionStackView.spacing = 16
        locationSectionStackView.backgroundColor = .gray
        locationSectionStackView.alignment = .fill

        // 1. "위치 안내" 레이블
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.text = "위치 안내"
        sectionTitleLabel.textColor = .black
        sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        sectionTitleLabel.textAlignment = .left

        // 2. 흰색 컨테이너
        let whiteContainerView = UIStackView()
        whiteContainerView.translatesAutoresizingMaskIntoConstraints = false
        whiteContainerView.axis = .vertical
        whiteContainerView.spacing = 16
        whiteContainerView.alignment = .fill
        whiteContainerView.backgroundColor = .white
        whiteContainerView.layer.cornerRadius = 20
        whiteContainerView.clipsToBounds = true
        whiteContainerView.isLayoutMarginsRelativeArrangement = true
        whiteContainerView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        // 2-1. 지도 이미지
        let mapImageView = UIImageView(image: UIImage(named: "image4")) // "map_sample" 에셋 이미지
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        mapImageView.contentMode = .scaleAspectFill
        mapImageView.clipsToBounds = true
        mapImageView.layer.cornerRadius = 12
        mapImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        // 2-2. 주소지와 버튼 (horizontalStackView)
        let addressAndButtonStackView = UIStackView()
        addressAndButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        addressAndButtonStackView.axis = .horizontal
        addressAndButtonStackView.spacing = 8
        addressAndButtonStackView.alignment = .center

        // 주소지 (icon_location_orange + 텍스트)
        let addressStackView = UIStackView()
        addressStackView.translatesAutoresizingMaskIntoConstraints = false
        addressStackView.axis = .horizontal
        addressStackView.spacing = 8
        addressStackView.alignment = .center

        let locationIcon = UIImageView(image: UIImage(named: "icon_location_orange"))
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.contentMode = .scaleAspectFit
        locationIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        locationIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let addressLabel = UILabel()
        addressLabel.text = "경기 양주시 광사로 145 로슈아커피"
        addressLabel.textColor = .black
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.numberOfLines = 0

        addressStackView.addArrangedSubview(locationIcon)
        addressStackView.addArrangedSubview(addressLabel)

        // 길찾기 버튼
        let directionButton = UIButton(type: .system)
        directionButton.setTitle("길찾기", for: .normal)
        directionButton.setTitleColor(.white, for: .normal)
        directionButton.backgroundColor = UIColor(red: 0.27, green: 0.36, blue: 0.20, alpha: 1.0) // 녹색
        directionButton.layer.cornerRadius = 8
        directionButton.clipsToBounds = true
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        directionButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        directionButton.heightAnchor.constraint(equalToConstant: 36).isActive = true

        // 주소지 + 버튼 추가
        addressAndButtonStackView.addArrangedSubview(addressStackView)
        addressAndButtonStackView.addArrangedSubview(UIView()) // Spacer
        addressAndButtonStackView.addArrangedSubview(directionButton)

        // 흰색 컨테이너에 추가
        whiteContainerView.addArrangedSubview(mapImageView)
        whiteContainerView.addArrangedSubview(addressAndButtonStackView)

        // 섹션에 추가
        locationSectionStackView.addArrangedSubview(sectionTitleLabel)
        locationSectionStackView.addArrangedSubview(whiteContainerView)

        return locationSectionStackView
    }

    // 6. 주변 가볼만한 곳 섹션
    private func createNearbyPlacesSection() -> UIStackView {
        let nearbyPlacesStackView = UIStackView()
        nearbyPlacesStackView.translatesAutoresizingMaskIntoConstraints = false
        nearbyPlacesStackView.axis = .vertical
        nearbyPlacesStackView.spacing = 16
        nearbyPlacesStackView.backgroundColor = .lightGray
        nearbyPlacesStackView.alignment = .fill

        // 1. "주변 가볼만한 곳" 제목 레이블
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.text = "주변 가볼만한 곳"
        sectionTitleLabel.textColor = .black
        sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        sectionTitleLabel.textAlignment = .left

        // 2. 스크롤 뷰
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true

        // 3. 콘텐츠 뷰
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.alignment = .fill
        scrollView.addSubview(contentView)

        // 스크롤뷰와 콘텐츠 뷰의 제약 조건 설정
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // 폭 고정
        ])

        // 4. 가게 정보 카드 데이터
        let storeData: [[String: Any]] = [
            [
                "storeName": "로슈아커피",
                "isClosed": "영업중",
                "closeTime": "오후 10:00에 영업 종료",
                "star_rate": 4.40,
                "reviewNum": 237,
                "reviews_summary": "커다란 은행나무가 테라스에 있어 멋진 뷰와 함께 여유롭게 커피를 마실 수 있는 카페입니다.",
                "reviews_image": ["image1", "image2"]
            ],
            [
                "storeName": "몬슈아커피",
                "isClosed": "영업중",
                "closeTime": "오후 10:00에 영업 종료",
                "star_rate": 4.30,
                "reviewNum": 237,
                "reviews_summary": "가을에 더욱 매력적인 분위기를 느낄 수 있는 카페입니다.",
                "reviews_image": ["image3", "image4"]
            ],
            [
                "storeName": "바리스타하우스",
                "isClosed": "영업중",
                "closeTime": "오후 11:00에 영업 종료",
                "star_rate": 4.50,
                "reviewNum": 237,
                "reviews_summary": "도심 속에서 조용히 커피를 즐길 수 있는 공간입니다.",
                "reviews_image": ["image5", "image6"]
            ]
        ]

        // 5. 가게 정보 카드 생성
        for data in storeData {
            if let storeCard = createStoreCard(from: data) {
                contentView.addArrangedSubview(storeCard)
            }
        }

        // 6. 섹션에 추가
        nearbyPlacesStackView.addArrangedSubview(sectionTitleLabel)
        nearbyPlacesStackView.addArrangedSubview(scrollView)

        // 스크롤뷰의 높이 고정 (화면 크기에 따라 조정 가능)
        scrollView.heightAnchor.constraint(equalToConstant: 400).isActive = true

        return nearbyPlacesStackView
    }

    // 가게 정보 카드 생성
    private func createStoreCard(from data: [String: Any]) -> UIView? {
        guard
            let storeName = data["storeName"] as? String,
            let isClosed = data["isClosed"] as? String,
            let closeTime = data["closeTime"] as? String,
            let starRate = data["star_rate"] as? Double,
            let reviewNum = data["reviewNum"] as? Int,
            let reviewsSummary = data["reviews_summary"] as? String,
            let reviewsImage = data["reviews_image"] as? [String]
        else {
            return nil
        }

        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.masksToBounds = true
        cardView.backgroundColor = .white

        // 1. 상단 레이블 + 북마크 버튼
        let nameLabel = UILabel()
        nameLabel.text = storeName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black

        let bookmarkButton = UIButton(type: .custom)
        bookmarkButton.setImage(UIImage(named: "icon_scrape_unfilled"), for: .normal)
        bookmarkButton.setImage(UIImage(named: "icon_scrape"), for: .selected)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false

        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, bookmarkButton])
        nameStackView.axis = .horizontal
        nameStackView.spacing = 8
        nameStackView.alignment = .center

        // 북마크 버튼 크기 설정
        NSLayoutConstraint.activate([
            bookmarkButton.widthAnchor.constraint(equalToConstant: 24),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        // 2. 상태 + 종료 시간 (왼쪽 정렬)
        let statusLabel = UILabel()
        statusLabel.text = isClosed
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textColor = .systemGreen

        let closeTimeLabel = UILabel()
        closeTimeLabel.text = closeTime
        closeTimeLabel.font = UIFont.systemFont(ofSize: 12)
        closeTimeLabel.textColor = .gray

        let statusStackView = UIStackView(arrangedSubviews: [statusLabel, closeTimeLabel])
        statusStackView.axis = .horizontal
        statusStackView.spacing = 8
        statusStackView.alignment = .leading
        statusStackView.translatesAutoresizingMaskIntoConstraints = false

        let statusContainer = UIView()
        statusContainer.translatesAutoresizingMaskIntoConstraints = false
        statusContainer.addSubview(statusStackView)

        NSLayoutConstraint.activate([
            statusStackView.topAnchor.constraint(equalTo: statusContainer.topAnchor),
            statusStackView.leadingAnchor.constraint(equalTo: statusContainer.leadingAnchor),
            statusStackView.trailingAnchor.constraint(lessThanOrEqualTo: statusContainer.trailingAnchor), // 내부 콘텐츠 길이에 맞춤
            statusStackView.bottomAnchor.constraint(equalTo: statusContainer.bottomAnchor)
        ])

        // 3. 별점과 후기 (왼쪽 정렬)
        let starLabel = UILabel()
        starLabel.text = "★ \(starRate)"
        starLabel.font = UIFont.systemFont(ofSize: 14)
        starLabel.textColor = .orange

        let reviewNumLabel = UILabel()
        reviewNumLabel.text = "(\(reviewNum))"
        reviewNumLabel.font = UIFont.systemFont(ofSize: 12)
        reviewNumLabel.textColor = .gray

        let starStackView = UIStackView(arrangedSubviews: [starLabel, reviewNumLabel])
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        starStackView.alignment = .leading
        starStackView.translatesAutoresizingMaskIntoConstraints = false

        let starContainer = UIView()
        starContainer.translatesAutoresizingMaskIntoConstraints = false
        starContainer.addSubview(starStackView)

        NSLayoutConstraint.activate([
            starStackView.topAnchor.constraint(equalTo: starContainer.topAnchor),
            starStackView.leadingAnchor.constraint(equalTo: starContainer.leadingAnchor),
            starStackView.trailingAnchor.constraint(lessThanOrEqualTo: starContainer.trailingAnchor), // 내부 콘텐츠 길이에 맞춤
            starStackView.bottomAnchor.constraint(equalTo: starContainer.bottomAnchor)
        ])

        // 4. 이미지 뷰
        let imageStackView = UIStackView()
        imageStackView.axis = .horizontal
        imageStackView.spacing = 8
        imageStackView.distribution = .fillEqually
        imageStackView.translatesAutoresizingMaskIntoConstraints = false

        for imageName in reviewsImage {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageStackView.addArrangedSubview(imageView)
        }

        NSLayoutConstraint.activate([
            imageStackView.heightAnchor.constraint(equalToConstant: 154)
        ])

        // 5. 설명
        let descriptionLabel = UILabel()
        descriptionLabel.text = reviewsSummary
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .gray

        let reviewIcon = UIImageView(image: UIImage(named: "icon_review"))
        reviewIcon.contentMode = .scaleAspectFit
        reviewIcon.translatesAutoresizingMaskIntoConstraints = false

        let descriptionStackView = UIStackView(arrangedSubviews: [reviewIcon, descriptionLabel])
        descriptionStackView.axis = .horizontal
        descriptionStackView.spacing = 4
        descriptionStackView.alignment = .center

        // 리뷰 아이콘 크기 설정
        NSLayoutConstraint.activate([
            reviewIcon.widthAnchor.constraint(equalToConstant: 16),
            reviewIcon.heightAnchor.constraint(equalToConstant: 16)
        ])

        // 6. 전체 스택 뷰
        let verticalStackView = UIStackView(arrangedSubviews: [nameStackView, statusContainer, starContainer, imageStackView, descriptionStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])

        return cardView
    }

    // 공통 섹션 생성
    private func createSectionWithColor(_ color: UIColor, title: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.backgroundColor = color
        stackView.layer.cornerRadius = 0
        stackView.clipsToBounds = true
        
        return stackView
    }
}
