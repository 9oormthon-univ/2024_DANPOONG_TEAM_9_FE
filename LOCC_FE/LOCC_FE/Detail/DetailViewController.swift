import UIKit

class DetailViewController: UIViewController {
    private var storeData: StoreData?
    private var scrapButton: UIButton!
    var storeId: Int? // storeId를 받을 프로퍼티 추가
    
    private let dayMapping: [String: String] = [
        "MONDAY": "월",
        "TUESDAY": "화",
        "WEDNESDAY": "수",
        "THURSDAY": "목",
        "FRIDAY": "금",
        "SATURDAY": "토",
        "SUNDAY": "일"
    ]

    private let jwtToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJlc3RoZXIwOTA0QG5hdmVyLmNvbSIsInVzZXJuYW1lIjoi7Jqw7J2A7KeEIiwicm9sZSI6IlVTRVIiLCJpYXQiOjE3MzIzMTMzMTYsImV4cCI6MTczMzE3NzMxNn0.m1wso6RkWxmvipO8KAe9yHJc2u654_RyU8jptQLWBj0"
    
    func fetchStoreDetails(storeId: Int, completion: @escaping (StoreData?) -> Void) {
        let url = URL(string: "http://13.209.85.14/api/v1/stores/\(storeId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let storeResponse = try decoder.decode(StoreDetailResponse.self, from: data)
                completion(storeResponse.data)
            } catch {
                print("Decoding error: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // storeId를 사용하여 데이터를 로드
        if let storeId = storeId {
            fetchStoreDetails(storeId: storeId) { [weak self] data in
                guard let self = self, let data = data else { return }
                DispatchQueue.main.async {
                    self.storeData = data
                    self.setupUI()
                }
            }
        } else {
            print("storeId가 전달되지 않았습니다.")
        }
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
        var previousSection: UIView?
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
    private func createBasicInfoSection() -> UIView {
        guard let storeData = storeData else { return UIView() }
        
        // Main Container View
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true

        // 배경 이미지
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        if let imageUrl = URL(string: storeData.imageUrl) {
            backgroundImageView.loadImage(from: imageUrl)
        }
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        containerView.addSubview(backgroundImageView)

        // 반투명 레이어
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3) // 검정색, 투명도 30%
        containerView.addSubview(overlayView)

        // 상세 정보 StackView
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.alignment = .fill
        contentStackView.spacing = 16

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
        backButton.setImage(UIImage(named: "icon_back_detail"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        headerStackView.addArrangedSubview(backButton)

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.addArrangedSubview(spacer)

        scrapButton = UIButton()
        scrapButton.setImage(UIImage(named: storeData.bookmarked ? "icon_scrape" : "icon_scrap_unselected"), for: .normal)
        scrapButton.translatesAutoresizingMaskIntoConstraints = false
        scrapButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        scrapButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        scrapButton.addTarget(self, action: #selector(toggleBookmark), for: .touchUpInside)
        headerStackView.addArrangedSubview(scrapButton)

        // Header StackView를 Header Container View에 추가
        headerContainerView.addSubview(headerStackView)

        // Header StackView 레이아웃 설정
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 16),
            headerStackView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 4),
            headerStackView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -4),
            headerStackView.heightAnchor.constraint(equalToConstant: 44)
        ])

        contentStackView.addArrangedSubview(headerContainerView)

        // Basic Info StackView
        let basicInfoStackView = UIStackView()
        basicInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        basicInfoStackView.axis = .vertical
        basicInfoStackView.alignment = .leading
        basicInfoStackView.spacing = 6

        // 카테고리 Container
        let categoryContainerView = UIView()
        categoryContainerView.translatesAutoresizingMaskIntoConstraints = false
        categoryContainerView.backgroundColor = UIColor(hex: "#FFB13C").withAlphaComponent(0.12)
        categoryContainerView.layer.borderColor = UIColor(hex: "FA9F16").cgColor
        categoryContainerView.layer.borderWidth = 1
        categoryContainerView.layer.cornerRadius = 12

        let categoryLabel = UILabel()
        categoryLabel.text = storeData.category
        categoryLabel.textAlignment = .center
        categoryLabel.textColor = UIColor(hex: "DC8F1C")
        categoryLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false

        categoryContainerView.addSubview(categoryLabel)

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: categoryContainerView.topAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor, constant: 8),
            categoryLabel.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor, constant: -8),
            categoryLabel.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor, constant: -4)
        ])

        basicInfoStackView.addArrangedSubview(categoryContainerView)

        // 가게 이름
        let nameLabel = UILabel()
        nameLabel.text = storeData.storeName
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Pretendard-Bold", size: 24)
        basicInfoStackView.addArrangedSubview(nameLabel)

        // 영업 상태
        let statusStackView = UIStackView()
        statusStackView.translatesAutoresizingMaskIntoConstraints = false
        statusStackView.axis = .horizontal
        statusStackView.spacing = 8

        let statusLabel = UILabel()
        statusLabel.text = storeData.status
        statusLabel.textAlignment = .left
        statusLabel.textColor = UIColor(hex: "3F8008")
        statusLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        statusStackView.addArrangedSubview(statusLabel)

        let closingTimeLabel = UILabel()
        closingTimeLabel.text = storeData.closeTime != nil ? "\(storeData.closeTime)에 영업 종료" : ""
        closingTimeLabel.textAlignment = .left
        closingTimeLabel.textColor = .white
        closingTimeLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        statusStackView.addArrangedSubview(closingTimeLabel)

        basicInfoStackView.addArrangedSubview(statusStackView)

        contentStackView.addArrangedSubview(basicInfoStackView)

        containerView.addSubview(contentStackView)

        // 레이아웃 제약 조건 설정
        NSLayoutConstraint.activate([
            // 배경 이미지
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // 반투명 오버레이
            overlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // 상세 정보 컨텐츠
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -28)
        ])

        return containerView
    }

    // 2. 후기 섹션
    private func createReviewSection() -> UIStackView {
        let reviewStackView = UIStackView()
        reviewStackView.translatesAutoresizingMaskIntoConstraints = false
        reviewStackView.axis = .vertical
        reviewStackView.distribution = .fill
        reviewStackView.alignment = .fill
        reviewStackView.spacing = 8
        reviewStackView.backgroundColor = UIColor(hex: "F8F7F0")
        reviewStackView.clipsToBounds = true

        // Section Title Container
        let sectionTitleContainer = UIView()
        sectionTitleContainer.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleContainer.heightAnchor.constraint(equalToConstant: 52).isActive = true // 컨테이너 높이 설정

        // 섹션 제목
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.text = "후기"
        sectionTitleLabel.textAlignment = .left
        sectionTitleLabel.textColor = UIColor(hex: "1E1E1E")
        sectionTitleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)

        // Section Title Layout
        sectionTitleContainer.addSubview(sectionTitleLabel)
        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: sectionTitleContainer.topAnchor, constant: 0),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: sectionTitleContainer.leadingAnchor, constant: 24),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: sectionTitleContainer.trailingAnchor, constant: -24),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: sectionTitleContainer.bottomAnchor, constant: 32)
        ])

        // Section Title을 가장 위에 추가
        reviewStackView.addArrangedSubview(sectionTitleContainer)

        // 별점 및 후기 정보
        let ratingInfoStackView = createRatingInfoStackView()
        reviewStackView.addArrangedSubview(ratingInfoStackView)

        // 가로 스크롤 가능한 후기 카드
        let reviewCardContainer = UIView()
        reviewCardContainer.translatesAutoresizingMaskIntoConstraints = false

        let reviewCardScrollView = createReviewCardScrollView()
        reviewCardContainer.addSubview(reviewCardScrollView)

        NSLayoutConstraint.activate([
            reviewCardScrollView.topAnchor.constraint(equalTo: reviewCardContainer.topAnchor, constant: 0), // 위쪽 마진
            reviewCardScrollView.leadingAnchor.constraint(equalTo: reviewCardContainer.leadingAnchor, constant: 20), // 왼쪽 마진
            reviewCardScrollView.trailingAnchor.constraint(equalTo: reviewCardContainer.trailingAnchor, constant: -0), // 오른쪽 마진
            reviewCardScrollView.bottomAnchor.constraint(equalTo: reviewCardContainer.bottomAnchor, constant: -40) // 아래쪽 마진
        ])

        reviewStackView.addArrangedSubview(reviewCardContainer)

        return reviewStackView
    }

    // 별점 및 후기 정보
    private func createRatingInfoStackView() -> UIStackView {
        guard let storeData = storeData else { return UIStackView() }
        
        let ratingInfoStackView = UIStackView()
        ratingInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingInfoStackView.axis = .horizontal
        ratingInfoStackView.distribution = .fill
        ratingInfoStackView.alignment = .center
        ratingInfoStackView.spacing = 8
        
        // 마진 설정
        ratingInfoStackView.isLayoutMarginsRelativeArrangement = true
        ratingInfoStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 4, right: 20)

        // 별점 Horizontal StackView
        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.distribution = .fillEqually
        starStackView.alignment = .center
        starStackView.spacing = 4

        // 별점 계산 및 이미지 추가
        let fullStars = Int(storeData.rating) // 정수 부분
        let hasHalfStar = storeData.rating - Double(fullStars) >= 0.5 // 소수점 부분이 0.5 이상이면 true

        // Full stars
        for _ in 0..<fullStars {
            let starImageView = UIImageView(image: UIImage(named: "icon_star"))
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            starStackView.addArrangedSubview(starImageView)
        }

        // Half star
        if hasHalfStar {
            let halfStarImageView = UIImageView(image: UIImage(named: "icon_star_half"))
            halfStarImageView.translatesAutoresizingMaskIntoConstraints = false
            halfStarImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            halfStarImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            starStackView.addArrangedSubview(halfStarImageView)
        }

        // Empty stars
        let emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0)
        for _ in 0..<emptyStars {
            let emptyStarImageView = UIImageView(image: UIImage(named: "icon_star_unfilled"))
            emptyStarImageView.translatesAutoresizingMaskIntoConstraints = false
            emptyStarImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            emptyStarImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            starStackView.addArrangedSubview(emptyStarImageView)
        }

        // 별점 정보
        let ratingLabel = UILabel()
        ratingLabel.text = String(format: "%.1f", storeData.rating)
        ratingLabel.textColor = UIColor(hex: "696969")
        ratingLabel.font = UIFont(name: "Pretendard-Medium", size: 16)

        let maxRatingLabel = UILabel()
        maxRatingLabel.text = "/5"
        maxRatingLabel.textColor = UIColor(hex: "9C9B97")
        maxRatingLabel.font = UIFont(name: "Pretendard-Medium", size: 16)

        // 총 후기 개수
        let reviewCountLabel = UILabel()
        reviewCountLabel.text = "(\(storeData.reviewCount))"
        reviewCountLabel.textColor = UIColor(hex: "9C9B97")
        reviewCountLabel.font = UIFont(name: "Pretendard-Regular", size: 12)

        // 전체 보기 버튼
        let viewAllButton = UIButton()
        viewAllButton.setTitle("전체보기 >", for: .normal)
        viewAllButton.setTitleColor(UIColor(hex: "9C9B97"), for: .normal)
        viewAllButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)

        // 왼쪽 정보 스택
        let leftInfoStackView = UIStackView(arrangedSubviews: [starStackView, ratingLabel, maxRatingLabel, reviewCountLabel])
        leftInfoStackView.axis = .horizontal
        leftInfoStackView.spacing = 6
        leftInfoStackView.alignment = .center

        // 오른쪽 버튼
        ratingInfoStackView.addArrangedSubview(leftInfoStackView)
        ratingInfoStackView.addArrangedSubview(UIView()) // Spacer
        ratingInfoStackView.addArrangedSubview(viewAllButton)

        return ratingInfoStackView
    }

    // 후기 카드 스크롤 뷰
    private func createReviewCardScrollView() -> UIScrollView {
        guard let storeData = storeData else { return UIScrollView() }

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

        // 동적으로 리뷰 데이터를 사용하여 카드 생성
        for review in storeData.reviews {
            let profileUrl = review.profileImageUrl
            let imageUrl = review.images.first ?? "" // 첫 번째 이미지 URL 가져오기
            let imageUrl2 = review.images[1] ?? ""
            let imageUrl3 = review.images[2] ?? ""
            let cardView = createReviewCard(
                profileImage: profileUrl, // 기본 프로필 이미지 사용
                userName: review.username, // 유저 이름 대체
                rating: review.rating,
                reviewText: review.summary,
                images: [
                    imageUrl, imageUrl2, imageUrl3 // 동일한 URL 3번 사용
                ]
            )
            contentView.addArrangedSubview(cardView)
        }
        
        return scrollView
    }

    // 후기 카드 생성
    private func createReviewCard(profileImage: String, userName: String, rating: Double, reviewText: String, images: [String]) -> UIView {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
        cardView.heightAnchor.constraint(equalToConstant: 224).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: 218).isActive = true

        let verticalStackView = UIStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 12
        verticalStackView.alignment = .fill
        cardView.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 0),
            verticalStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0),
            verticalStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -0),
            verticalStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -0)
        ])

        // 1. 유저 정보 (프로필 사진, 유저 이름, 별점)
        let userInfoContainer = UIView() // 컨테이너 뷰 생성
        userInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        userInfoContainer.backgroundColor = UIColor(hex: "DCE7D4")

        let userInfoStackView = UIStackView()
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        userInfoStackView.axis = .horizontal
        userInfoStackView.spacing = 8
        userInfoStackView.alignment = .center // 콘텐츠 가운데 정렬
        userInfoStackView.distribution = .equalSpacing // 내부 콘텐츠 간 간격 균등 배치
        userInfoStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 14
        profileImageView.clipsToBounds = true
        profileImageView.loadImage(from: profileImage)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.widthAnchor.constraint(equalToConstant: 26).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 26).isActive = true

        let userNameLabel = UILabel()
        userNameLabel.text = userName
        userNameLabel.textColor = UIColor(hex: "575754")
        userNameLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        
        // Profile Image와 User Name을 감싸는 StackView 생성
        let profileInfoStackView = UIStackView()
        profileInfoStackView.axis = .horizontal
        profileInfoStackView.spacing = 8
        profileInfoStackView.alignment = .center
        profileInfoStackView.translatesAutoresizingMaskIntoConstraints = false

        // Profile Image 추가
        profileInfoStackView.addArrangedSubview(profileImageView)

        // User Name 추가
        profileInfoStackView.addArrangedSubview(userNameLabel)

        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.spacing = 2
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(named: "icon_star"))
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
            starStackView.addArrangedSubview(starImageView)
        }

        // StackView에 추가
        userInfoStackView.addArrangedSubview(profileInfoStackView)
        userInfoStackView.addArrangedSubview(starStackView)

        // userInfoStackView를 userInfoContainer에 추가
        userInfoContainer.addSubview(userInfoStackView)

        // userInfoStackView 제약 조건 설정 (마진 적용)
        NSLayoutConstraint.activate([
            userInfoStackView.topAnchor.constraint(equalTo: userInfoContainer.topAnchor, constant: 0), // 위쪽 마진
            userInfoStackView.leadingAnchor.constraint(equalTo: userInfoContainer.leadingAnchor, constant: 12), // 왼쪽 마진
            userInfoStackView.trailingAnchor.constraint(equalTo: userInfoContainer.trailingAnchor, constant: -12), // 오른쪽 마진
            userInfoStackView.bottomAnchor.constraint(equalTo: userInfoContainer.bottomAnchor, constant: -4) // 아래쪽 마진
        ])

        // userInfoContainer를 verticalStackView에 추가
        verticalStackView.addArrangedSubview(userInfoContainer)

        // 내부 콘텐츠의 높이에 따라 컨테이너의 높이가 조정되도록 설정
        NSLayoutConstraint.activate([
            userInfoContainer.heightAnchor.constraint(equalTo: userInfoStackView.heightAnchor)
        ])

        // 2. 후기 텍스트와 아이콘 컨테이너
        let reviewTextOuterContainer = UIView()
        reviewTextOuterContainer.translatesAutoresizingMaskIntoConstraints = false
        reviewTextOuterContainer.backgroundColor = .clear // 배경색 필요 시 설정

        // 후기 텍스트와 아이콘을 감쌀 StackView
        let reviewTextContainer = UIStackView()
        reviewTextContainer.translatesAutoresizingMaskIntoConstraints = false
        reviewTextContainer.axis = .vertical
        reviewTextContainer.spacing = 12
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
        reviewTextLabel.textColor = UIColor(hex: "696969")
        reviewTextLabel.font = UIFont(name: "Pretendard-Regular", size: 13)
        reviewTextLabel.numberOfLines = 0
        reviewTextLabel.textAlignment = .left

        // 컨테이너에 아이콘과 텍스트 추가
        reviewTextContainer.addArrangedSubview(reviewIcon)
        reviewTextContainer.addArrangedSubview(reviewTextLabel)

        // Outer Container에 StackView 추가
        reviewTextOuterContainer.addSubview(reviewTextContainer)

        // 제약 조건: Padding 추가
        NSLayoutConstraint.activate([
            reviewTextContainer.topAnchor.constraint(equalTo: reviewTextOuterContainer.topAnchor, constant: 12),
            reviewTextContainer.leadingAnchor.constraint(equalTo: reviewTextOuterContainer.leadingAnchor, constant: 16),
            reviewTextContainer.trailingAnchor.constraint(equalTo: reviewTextOuterContainer.trailingAnchor, constant: -16),
            reviewTextContainer.bottomAnchor.constraint(equalTo: reviewTextOuterContainer.bottomAnchor, constant: -12)
        ])

        // Vertical StackView에 Outer Container 추가
        verticalStackView.addArrangedSubview(reviewTextOuterContainer)


        // 3. 이미지 컨테이너 Outer View
        let imageOuterContainer = UIView()
        imageOuterContainer.translatesAutoresizingMaskIntoConstraints = false
        imageOuterContainer.backgroundColor = .clear // 배경색 필요 시 설정

        // 이미지 컨테이너 StackView
        let imageStackView = UIStackView()
        imageStackView.axis = .horizontal
        imageStackView.spacing = 3
        imageStackView.alignment = .center
        imageStackView.translatesAutoresizingMaskIntoConstraints = false

        for imageUrl in images {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.loadImage(from: imageUrl) // URL로 이미지 로드
            imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            imageStackView.addArrangedSubview(imageView)
        }

        // Outer Container에 StackView 추가
        imageOuterContainer.addSubview(imageStackView)

        // 마진 설정
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: imageOuterContainer.topAnchor, constant: 0),
            imageStackView.leadingAnchor.constraint(equalTo: imageOuterContainer.leadingAnchor, constant: 16),
            imageStackView.trailingAnchor.constraint(equalTo: imageOuterContainer.trailingAnchor, constant: -16),
            imageStackView.bottomAnchor.constraint(equalTo: imageOuterContainer.bottomAnchor, constant: -16)
        ])

        // Vertical StackView에 Outer Container 추가
        verticalStackView.addArrangedSubview(imageOuterContainer)


        return cardView
    }
    
    // 3. 부가 정보 섹션
    private func createAdditionalInfoSection() -> UIStackView {
        guard let storeData = storeData else { return UIStackView() }
        
        let additionalInfoStackView = UIStackView()
        additionalInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalInfoStackView.axis = .vertical
        additionalInfoStackView.distribution = .fill
        additionalInfoStackView.alignment = .fill
        additionalInfoStackView.spacing = 16
        additionalInfoStackView.backgroundColor = .white
        additionalInfoStackView.clipsToBounds = true

        // 1. 영업 상태 (icon_clock + "영업중" + 토글 아이콘)
        let businessStatusStack = createBusinessStatusToggleRow()

        // 2. 전화번호 (icon_phone + "070-8807-1987")
        let phoneNumberStack = wrapWithMargins(view: createHorizontalInfoRow(iconName: "icon_phone", text: storeData.phone), top: 8, leading: 24, trailing: 16, bottom: 4)

        // 3. SNS 링크 (icon_sns + "http://instagram.com/loshuacoffee")
        let snsLinkStack = wrapWithMargins(view: createHorizontalInfoRow(iconName: "icon_sns", text: storeData.homepage), top: 8, leading: 24, trailing: 16, bottom: 20)

        // Add rows to the vertical stack view
        additionalInfoStackView.addArrangedSubview(businessStatusStack)
        additionalInfoStackView.addArrangedSubview(phoneNumberStack)
        additionalInfoStackView.addArrangedSubview(snsLinkStack)

        return additionalInfoStackView
    }
    
    // Helper function to wrap a view with margins
    private func wrapWithMargins(view: UIView, top: CGFloat, leading: CGFloat, trailing: CGFloat, bottom: CGFloat) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: top),
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -trailing),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -bottom)
        ])

        return containerView
    }

    // 영업 상태 행 (토글 기능 포함)
    private func createBusinessStatusToggleRow() -> UIView {
        guard let storeData = storeData else { return UIView() }
        
        // Outer container to handle margins
        let outerContainer = UIView()
        outerContainer.translatesAutoresizingMaskIntoConstraints = false

        // Vertical container stack view
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
        rowStackView.spacing = 16

        // Icon
        let iconImageView = UIImageView(image: UIImage(named: "icon_clock"))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        // Label
        let textLabel = UILabel()
        textLabel.text = storeData.status
        textLabel.textColor = UIColor(hex: "FA9F16")
        textLabel.font = UIFont(name: "Pretendard-Semibold", size: 16)

        // Toggle Button
        let toggleButton = UIButton()
        toggleButton.setImage(UIImage(named: "icon_toggle_down"), for: .normal)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.widthAnchor.constraint(equalToConstant: 13.6).isActive = true
        toggleButton.heightAnchor.constraint(equalToConstant: 6.8).isActive = true

        // Hidden Container (initially hidden)
        let hiddenContainer = UIView()
        hiddenContainer.translatesAutoresizingMaskIntoConstraints = false
        hiddenContainer.backgroundColor = UIColor(hex: "F9F9F9")
        hiddenContainer.clipsToBounds = true
        hiddenContainer.isHidden = true // Initially hidden

        // Add rows for each day
        let scheduleStackView = createScheduleStackView(from: storeData.businessHours)
        view.addSubview(scheduleStackView)

        // Add schedule stack view to hidden container
        hiddenContainer.addSubview(scheduleStackView)
        NSLayoutConstraint.activate([
            scheduleStackView.topAnchor.constraint(equalTo: hiddenContainer.topAnchor, constant: 0),
            scheduleStackView.leadingAnchor.constraint(equalTo: hiddenContainer.leadingAnchor, constant: 0),
            scheduleStackView.trailingAnchor.constraint(equalTo: hiddenContainer.trailingAnchor, constant: -0),
            scheduleStackView.bottomAnchor.constraint(equalTo: hiddenContainer.bottomAnchor, constant: -0)
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

        // Add containerStackView to outer container with margins
        outerContainer.addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: outerContainer.topAnchor, constant: 16),
            containerStackView.leadingAnchor.constraint(equalTo: outerContainer.leadingAnchor, constant: 24),
            containerStackView.trailingAnchor.constraint(equalTo: outerContainer.trailingAnchor, constant: -24),
            containerStackView.bottomAnchor.constraint(equalTo: outerContainer.bottomAnchor, constant: -0)
        ])

        return outerContainer
    }
    
    func createScheduleStackView(from businessHours: [BusinessHour]) -> UIStackView {
        let scheduleStackView = UIStackView()
        scheduleStackView.axis = .vertical
        scheduleStackView.spacing = 8
        scheduleStackView.alignment = .fill
        scheduleStackView.translatesAutoresizingMaskIntoConstraints = false

        populateSchedule(from: businessHours, into: scheduleStackView)

        return scheduleStackView
    }
    
    func populateSchedule(from businessHours: [BusinessHour], into scheduleStackView: UIStackView) {
        for hour in businessHours {
            guard let koreanDay = dayMapping[hour.dayOfWeek] else { continue }

            // 휴무일 처리
            if hour.holiday {
                let dayRowStackView = createHorizontalDayRow(day: koreanDay, time: "휴무")
                scheduleStackView.addArrangedSubview(dayRowStackView)
            } else {
                let time = "\(hour.openTime ?? "-") - \(hour.closeTime ?? "-")"
                let dayRowStackView = createHorizontalDayRow(day: koreanDay, time: time)
                scheduleStackView.addArrangedSubview(dayRowStackView)
            }
        }
    }

    // 하루의 영업 시간을 나타내는 Horizontal Row 생성
    private func createHorizontalDayRow(day: String, time: String) -> UIView {
        // Outer container to handle margins
        let outerContainer = UIView()
        outerContainer.translatesAutoresizingMaskIntoConstraints = false

        // Row stack view
        let rowStackView = UIStackView()
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        rowStackView.axis = .horizontal
        rowStackView.spacing = 16
        rowStackView.alignment = .center

        // Day label
        let dayLabel = UILabel()
        dayLabel.text = day
        dayLabel.textColor = UIColor(hex: "696969")
        dayLabel.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        dayLabel.textAlignment = .left

        // Time label
        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.textColor = UIColor(hex: "696969")
        timeLabel.font = UIFont(name: "Pretendard-Regular", size: 15)
        timeLabel.textAlignment = .right

        // Add views to row stack view
        rowStackView.addArrangedSubview(dayLabel)
        rowStackView.addArrangedSubview(UIView()) // Spacer
        rowStackView.addArrangedSubview(timeLabel)

        // Add row stack view to outer container with margins
        outerContainer.addSubview(rowStackView)
        NSLayoutConstraint.activate([
            rowStackView.topAnchor.constraint(equalTo: outerContainer.topAnchor, constant: 8),
            rowStackView.leadingAnchor.constraint(equalTo: outerContainer.leadingAnchor, constant: 24),
            rowStackView.trailingAnchor.constraint(equalTo: outerContainer.trailingAnchor, constant: -24),
            rowStackView.bottomAnchor.constraint(equalTo: outerContainer.bottomAnchor, constant: -8)
        ])

        return outerContainer
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
        rowStackView.spacing = 16

        // Icon
        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        // Label
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.textColor = UIColor(hex: "575754")
        textLabel.font = UIFont(name: "Pretendard-Regular", size: 14)

        // Add to the row stack view
        rowStackView.addArrangedSubview(iconImageView)
        rowStackView.addArrangedSubview(textLabel)

        return rowStackView
    }
    
    // 4. 상세 정보 섹션
    private func createDetailedInfoSection() -> UIStackView {
        guard let storeData = storeData else { return UIStackView() }
        
        let detailedInfoStackView = UIStackView()
        detailedInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        detailedInfoStackView.axis = .vertical
        detailedInfoStackView.distribution = .fill
        detailedInfoStackView.alignment = .fill
        detailedInfoStackView.spacing = 16
        detailedInfoStackView.backgroundColor = UIColor(hex: "F8F7F0")
        detailedInfoStackView.clipsToBounds = true

        // 1. 이미지
        let imageView = UIImageView() // "image1" 에셋 이미지
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let imageUrl = URL(string: storeData.imageUrl) {
            imageView.loadImage(from: imageUrl)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 246).isActive = true

        // 2. 텍스트
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = storeData.content
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor(hex: "696969")
        descriptionLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
        descriptionLabel.textAlignment = .center
        
        let descriptionLabelView = wrapWithMargins(view: descriptionLabel, top: 36, leading: 32, trailing: 32, bottom: 48)
        
        // 3. 하단 경계선
        let bottomBorder = UIView()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.backgroundColor = UIColor(hex: "9C9B97").withAlphaComponent(0.21)
        bottomBorder.heightAnchor.constraint(equalToConstant: 5).isActive = true

        // Add components to the stack view
        detailedInfoStackView.addArrangedSubview(imageView)
        detailedInfoStackView.addArrangedSubview(descriptionLabelView)
        detailedInfoStackView.addArrangedSubview(bottomBorder)

        return detailedInfoStackView
    }
    
    // 5. 위치 안내 섹션
    private func createLocationSection() -> UIStackView {
        guard let storeData = storeData else { return UIStackView() }
        
        let locationSectionStackView = UIStackView()
        locationSectionStackView.translatesAutoresizingMaskIntoConstraints = false
        locationSectionStackView.axis = .vertical
        locationSectionStackView.spacing = 16
        locationSectionStackView.backgroundColor = UIColor(hex: "F8F7F0")
        locationSectionStackView.alignment = .fill

        // 1. "위치 안내" 레이블
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.text = "위치 안내"
        sectionTitleLabel.textColor = UIColor(hex: "1E1E1E")
        sectionTitleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        sectionTitleLabel.textAlignment = .left
        
        let sectionTitleLabelView = wrapWithMargins(view: sectionTitleLabel, top: 24, leading: 20, trailing: 20, bottom: 0)

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
        whiteContainerView.layoutMargins = UIEdgeInsets(top:16, left: 16, bottom: 16, right: 16)

        let whiteContainerViewView = wrapWithMargins(view: whiteContainerView, top: 0, leading: 20, trailing: 20, bottom: 24)
        
        // 2-1. 지도 이미지
        let mapImageView = UIImageView(image: UIImage(named: "pseudo_map")) // "map_sample" 에셋 이미지
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
        locationIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        locationIcon.heightAnchor.constraint(equalToConstant: 13).isActive = true

        let addressLabel = UILabel()
        addressLabel.text = storeData.address
        addressLabel.textColor = UIColor(hex: "333332")
        addressLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        addressLabel.numberOfLines = 0

        addressStackView.addArrangedSubview(locationIcon)
        addressStackView.addArrangedSubview(addressLabel)

        // 길찾기 버튼
        let directionButton = UIButton(type: .system)
        directionButton.setTitle("길찾기", for: .normal)
        directionButton.setTitleColor(.white, for: .normal)
        directionButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12) // 폰트 이름과 크기 설정
        directionButton.backgroundColor = UIColor(hex: "365C16") // 녹색
        directionButton.layer.cornerRadius = 12
        directionButton.clipsToBounds = true
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        directionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        directionButton.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // 주소지 + 버튼 추가
        addressAndButtonStackView.addArrangedSubview(addressStackView)
        addressAndButtonStackView.addArrangedSubview(UIView()) // Spacer
        addressAndButtonStackView.addArrangedSubview(directionButton)

        // 흰색 컨테이너에 추가
        whiteContainerView.addArrangedSubview(mapImageView)
        whiteContainerView.addArrangedSubview(addressAndButtonStackView)

        // 섹션에 추가
        locationSectionStackView.addArrangedSubview(sectionTitleLabelView)
        locationSectionStackView.addArrangedSubview(whiteContainerViewView)

        return locationSectionStackView
    }

    // 6. 주변 가볼만한 곳 섹션
    private func createNearbyPlacesSection() -> UIStackView {
        guard let storeData = storeData else { return UIStackView() }
        
        let nearbyPlacesStackView = UIStackView()
        nearbyPlacesStackView.translatesAutoresizingMaskIntoConstraints = false
        nearbyPlacesStackView.axis = .vertical
        nearbyPlacesStackView.spacing = 16
        nearbyPlacesStackView.backgroundColor = UIColor(hex: "F8F7F0")
        nearbyPlacesStackView.alignment = .fill

        // 1. "주변 가볼만한 곳" 제목 레이블
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.text = "주변 가볼만한 곳"
        sectionTitleLabel.textColor = UIColor(hex: "1E1E1E")
        sectionTitleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        sectionTitleLabel.textAlignment = .left
        
        let sectionTitleLabelView = wrapWithMargins(view: sectionTitleLabel, top: 24, leading: 20, trailing: 20, bottom: 0)

        // 2. 스크롤 뷰
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true

        // 3. 콘텐츠 뷰
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 0
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

        // 5. 가게 정보 카드 생성
        for store in storeData.nearbyStores {
            if let storeCard = createStoreCard(from: store) {
                contentView.addArrangedSubview(storeCard)
            }
        }

        // 6. 섹션에 추가
        nearbyPlacesStackView.addArrangedSubview(sectionTitleLabelView)
        nearbyPlacesStackView.addArrangedSubview(scrollView)

        // 스크롤뷰의 높이 고정 (화면 크기에 따라 조정 가능)
        scrollView.heightAnchor.constraint(equalToConstant: 400).isActive = true

        return nearbyPlacesStackView
    }

    // 가게 정보 카드 생성
    private func createStoreCard(from store: NearbyStore) -> UIView? {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(hex: "111111").withAlphaComponent(0.1).cgColor
        cardView.layer.borderWidth = 0.5
        cardView.layer.masksToBounds = true
        cardView.backgroundColor = .white

        // 1. 상단 레이블 + 북마크 버튼
        let nameLabel = UILabel()
        nameLabel.text = store.name
        nameLabel.font = UIFont(name: "Pretendard-Bold", size: 18)
        nameLabel.textColor = UIColor(hex: "111111")

        let bookmarkButton = UIButton(type: .custom)
        bookmarkButton.setImage(UIImage(named: store.bookmarked ? "icon_scrape" : "icon_scrape_unfilled"), for: .normal)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false

        // 버튼 액션에 storeId 전달
        bookmarkButton.tag = store.storeId // storeId를 버튼의 tag에 저장
        bookmarkButton.addTarget(self, action: #selector(toggleNearBookmark(_:)), for: .touchUpInside)

        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, bookmarkButton])
        nameStackView.axis = .horizontal
        nameStackView.spacing = 8
        nameStackView.alignment = .center

        // 북마크 버튼 크기 설정
        NSLayoutConstraint.activate([
            bookmarkButton.widthAnchor.constraint(equalToConstant: 21),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 25)
        ])

        // 2. 상태 + 종료 시간 (왼쪽 정렬)
        let statusLabel = UILabel()
        statusLabel.text = store.businessStatus
        statusLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        statusLabel.textColor = UIColor(hex: "3F8008")

        let closeTimeLabel = UILabel()
        closeTimeLabel.text = store.closeTime != nil ? "\(store.closeTime)에 영업 종료" : ""
        closeTimeLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        closeTimeLabel.textColor = UIColor(hex: "696969")

        let statusStackView = UIStackView(arrangedSubviews: [statusLabel, closeTimeLabel])
        statusStackView.axis = .horizontal
        statusStackView.spacing = 8
        statusStackView.alignment = .trailing
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
        let starIcon = UIImageView(image: UIImage(named: "icon_star"))
        starIcon.translatesAutoresizingMaskIntoConstraints = false
        starIcon.widthAnchor.constraint(equalToConstant: 12).isActive = true
        starIcon.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let starLabel = UILabel()
        starLabel.text = "\(store.rating)"
        starLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        starLabel.textColor = UIColor(hex: "696969")

        let reviewNumLabel = UILabel()
        reviewNumLabel.text = "(\(store.reviewCount))"
        reviewNumLabel.font = UIFont(name: "Pretendard-Regular", size: 10)
        reviewNumLabel.textColor = UIColor(hex: "9C9B97")

        let starStackView = UIStackView(arrangedSubviews: [starIcon, starLabel, reviewNumLabel])
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        starStackView.alignment = .center
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

        for imageName in store.images {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            if let imageUrl = URL(string: imageName) {
                imageView.loadImage(from: imageUrl)
            }
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageStackView.addArrangedSubview(imageView)
        }

        NSLayoutConstraint.activate([
            imageStackView.heightAnchor.constraint(equalToConstant: 154)
        ])
        
        let imageStackViewView = wrapWithMargins(view: imageStackView, top: 8, leading: 0, trailing: 0, bottom: 12)

        // 5. 설명
        let descriptionLabel = UILabel()
        descriptionLabel.text = store.content
        descriptionLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = UIColor(hex: "575754")

        let reviewIcon = UIImageView(image: UIImage(named: "icon_review"))
        reviewIcon.contentMode = .scaleAspectFit
        reviewIcon.translatesAutoresizingMaskIntoConstraints = false

        let descriptionStackView = UIStackView(arrangedSubviews: [reviewIcon, descriptionLabel])
        descriptionStackView.axis = .horizontal
        descriptionStackView.spacing = 12
        descriptionStackView.alignment = .leading

        // 리뷰 아이콘 크기 설정
        NSLayoutConstraint.activate([
            reviewIcon.widthAnchor.constraint(equalToConstant: 20),
            reviewIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        // 6. 전체 스택 뷰
        let verticalStackView = UIStackView(arrangedSubviews: [nameStackView, statusContainer, starContainer, imageStackViewView, descriptionStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 28),
            verticalStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            verticalStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -28)
        ])

        return cardView
    }
    
    @objc private func handleBackButton() {
        // 모달로 표시된 현재 ViewController 닫기
            self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func toggleBookmark() {
        guard let storeId = storeId else {
            print("❌ storeId가 nil입니다.")
            return
        }
        print("storeId: \(storeId)")
        let url = URL(string: "http://13.209.85.14/api/v1/stores/\(storeId)/bookmark/toggle")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Error toggling bookmark: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ToggleBookmarkResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.storeData?.bookmarked = response.data.bookmarked
                    let updatedImage = UIImage(named: response.data.bookmarked ? "icon_scrape" : "icon_scrap_unselected")
                    self.scrapButton.setImage(updatedImage, for: .normal)
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }
        task.resume()
    }
    
    @objc public func toggleNearBookmark(_ sender: UIButton) {
        let storeId = sender.tag // 버튼의 tag에서 storeId 가져오기
        let url = URL(string: "http://13.209.85.14/api/v1/stores/\(storeId)/bookmark/toggle")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Error toggling bookmark: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ToggleBookmarkResponse.self, from: data)
                
                DispatchQueue.main.async {
                    let updatedBookmarked = response.data.bookmarked
                    sender.setImage(
                        UIImage(named: updatedBookmarked ? "icon_scrape" : "icon_scrape_unfilled"),
                        for: .normal
                    )
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }
        task.resume()
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

extension UIImageView {
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image data")
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }

    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }
        loadImage(from: url)
    }
}

// MARK: 모델 구조체
struct StoreDetailResponse: Codable {
    let code: String
    let data: StoreData
}

struct StoreData: Codable {
    let storeName: String
    let category: String
    let address: String
    let phone: String
    let imageUrl: String
    let openTime: String?
    let closeTime: String?
    let status: String
    let homepage: String
    let rating: Double
    let reviewCount: Int
    let content: String?
    let businessHours: [BusinessHour]
    let reviews: [StoreReview]
    let nearbyStores: [NearbyStore]
    var bookmarked: Bool
}

struct BusinessHour: Codable {
    let dayOfWeek: String
    let openTime: String?
    let closeTime: String?
    let holiday: Bool
}

struct StoreReview: Codable {
    let reviewId: Int
    let profileImageUrl: String
    let username: String
    let rating: Double
    let summary: String
    let images: [String]
}

struct NearbyStore: Codable {
    let storeId: Int
    let name: String
    let content: String
    let category: String
    let images: [String]
    let rating: Double
    let reviewCount: Int
    let openTime: String?
    let closeTime: String?
    let businessStatus: String
    let bookmarked: Bool
}

struct ToggleBookmarkResponse: Codable {
    let code: String
    let data: StoreBookmarkData // 이름 변경
}

struct StoreBookmarkData: Codable {
    let count: Int
    let bookmarked: Bool
}

struct ToggleNearBookmarkResponse: Decodable {
    let code: String
    let message: String
    let data: StoreBookmarkData
}
