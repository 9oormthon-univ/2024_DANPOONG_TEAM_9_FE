//
//  MapViewController.swift
//  LOCC_FE
//
//  Created by 우은진 on 11/19/24.
//

import Foundation
import UIKit
//import KakaoMapsSDK

class MapViewController: UIViewController, UIScrollViewDelegate {
    
    // UI 요소 선언
    private var bottomSheetTopConstraint: NSLayoutConstraint!
    private let bottomSheetHeightRatio: CGFloat = 0.4 // 화면의 40%를 차지하도록 설정
    private let dimmingView = UIView() // 배경을 어둡게 할 뷰
    
    private let messageLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let bottomSheet = UIView()
    
//    private var mapController: KMController?
    
    // 검색 필드 컨테이너 뷰와 내부 요소들
    private let searchContainerView = UIView()
    private let searchIconView = UIImageView(image: UIImage(named: "icon_search"))
    private let searchTextField = UITextField()
    private let clearButton = UIButton(type: .custom)
    
    // 필터 컨테이너와 아이콘
    private let filterContainerView = UIView()
    private let filterIconView = UIImageView(image: UIImage(named: "icon_filter"))
    private let sortButton = createFilterButton(title: "추천순", fontWeight: "Medium")
    private let categoryButton = createFilterButton(title: "카테고리", fontWeight: "Regular")
    private let locationButton = createFilterButton(title: "지역", fontWeight: "Regular")
    
    private var shouldAllowScroll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFont()
        setupUI()
        
        // searchField를 비활성화하고 클릭 시 액션 설정
        searchTextField.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchFieldTapped))
        searchContainerView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 'BottomBorder' 레이어를 찾아 크기 업데이트
        if let border = bottomSheet.layer.sublayers?.first(where: { $0.name == "BottomBorder" }) {
            let borderWidth = bottomSheet.bounds.width // bottomSheet의 전체 너비 사용
            border.frame = CGRect(x: 0, y: filterContainerView.frame.maxY, width: borderWidth, height: 0.75)
        }
    }
    
    // 폰트 설정 메서드
    private func setupFont() {
        searchTextField.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    // UI 설정 메서드
    private func setupUI() {
        setupDimmingView()
        setupKakaoMap()
        setupBackButton()
        setupBottomSheet()
    }
    
    // kakaomap 추가
    private func setupKakaoMap() {
//        let mapContainer = KMViewContainer(frame: self.view.bounds)
//        mapContainer.translatesAutoresizingMaskIntoConstraints = false
//        mapContainer.backgroundColor = .red
//
//        view.addSubview(mapContainer)
//        
//        self.mapController = KMController(viewContainer: mapContainer)
//        mapController?.prepareEngine()
//        mapController?.activateEngine()
//        
//        // 지도 추가
//        let defaultPosition = MapPoint(longitude: 127.108678, latitude: 37.402001)
//        let mapViewInfo = MapviewInfo(
//            viewName: "mapview",
//            viewInfoName: "map",
//            defaultPosition: defaultPosition,
//            defaultLevel: 7
//        )
//        mapController?.addView(mapViewInfo)
//        
//        NSLayoutConstraint.activate([
//            mapContainer.topAnchor.constraint(equalTo: view.topAnchor),
//            mapContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mapContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            mapContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        print("mapContainer frame: \(mapContainer.frame)")

    }
    
    
    // 뒤로 가기 버튼 설정
    private func setupBackButton() {
        backButton.setImage(UIImage(named: "icon_back"), for: .normal)
        backButton.tintColor = UIColor(hex: "#333332")
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // 배경을 어둡게 할 dimmingView 설정
    private func setupDimmingView() {
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimmingView)
        
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // 바텀 시트 설정
    private func setupBottomSheet() {
        bottomSheet.backgroundColor = .white
        bottomSheet.layer.cornerRadius = 16
        bottomSheet.layer.shadowColor = UIColor.black.cgColor
        bottomSheet.layer.shadowOpacity = 0.3
        bottomSheet.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottomSheet.layer.shadowRadius = 11.5
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSheet)
        
        // 바텀 시트의 기본 위치 설정
        bottomSheetTopConstraint = bottomSheet.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * (1 - bottomSheetHeightRatio))
        
        NSLayoutConstraint.activate([
            bottomSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetTopConstraint,
            bottomSheet.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        bottomSheet.addGestureRecognizer(panGesture)
        
        setupBottomSheetContents()
    }
    
    // 바텀 시트 내부 요소 설정
    private func setupBottomSheetContents() {
        setupSearchBar()
        setupFilterButtons()
        setupBottomBorder()
        setupStoreDetailsSection()
    }
    
    // 바텀 시트 내부 검색 바
    private func setupSearchBar() {
        searchContainerView.layer.cornerRadius = 18
        searchContainerView.backgroundColor = UIColor(hex: "#111111").withAlphaComponent(0.06)
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheet.addSubview(searchContainerView)
        
        searchIconView.contentMode = .scaleAspectFit
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchIconView)
        
        searchTextField.placeholder = "지역, 공간, 메뉴 검색"
        searchTextField.borderStyle = .none
        searchTextField.isUserInteractionEnabled = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchTextField)
        
        clearButton.setImage(UIImage(named: "icon_search_x"), for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            searchContainerView.topAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 16),
            searchContainerView.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor, constant: -20),
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
    
    // searchField 클릭 시 다른 페이지로 이동하는 액션
    @objc private func searchFieldTapped() {
        print("move to search page")
    }
    
    private func setupFilterButtons() {
        // 필터 컨테이너 설정
        filterContainerView.backgroundColor = .clear
        filterContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheet.addSubview(filterContainerView)
        
        // 필터 아이콘을 감쌀 둥근 뷰 설정
        let filterIconBackgroundView = UIView()
        filterIconBackgroundView.backgroundColor = .clear
        filterIconBackgroundView.layer.cornerRadius = 16
        filterIconBackgroundView.layer.borderWidth = 0.75 // 테두리 두께
        filterIconBackgroundView.layer.borderColor = UIColor(hex: "#111111").withAlphaComponent(0.3).cgColor // 테두리 색상
        filterIconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        filterContainerView.addSubview(filterIconBackgroundView)
        
        // 필터 아이콘 설정
        filterIconView.contentMode = .scaleAspectFit
        filterIconView.translatesAutoresizingMaskIntoConstraints = false
        filterContainerView.addSubview(filterIconView)
        
        // 추천순 버튼 옆 세로 라인 추가
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(hex: "#111111").withAlphaComponent(0.2)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        // 필터 버튼들 스택뷰 설정
        let filterStackView = UIStackView(arrangedSubviews: [sortButton, separatorView, categoryButton, locationButton])
        filterStackView.axis = .horizontal
        filterStackView.spacing = 8
        filterStackView.alignment = .center // 세로로 가운데 정렬
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        filterContainerView.addSubview(filterStackView)
        
        // 레이아웃 제약 조건 설정
        NSLayoutConstraint.activate([
            // 필터 컨테이너 위치 설정
            filterContainerView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 16),
            filterContainerView.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor, constant: 16),
            filterContainerView.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor, constant: -16),
            filterContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            // 필터 스택뷰 위치 설정
            filterStackView.leadingAnchor.constraint(equalTo: filterContainerView.leadingAnchor),
            filterStackView.centerYAnchor.constraint(equalTo: filterContainerView.centerYAnchor),
            
            // 필터 아이콘 배경 뷰 위치 및 크기 설정
            filterIconBackgroundView.trailingAnchor.constraint(equalTo: filterContainerView.trailingAnchor),
            filterIconBackgroundView.centerYAnchor.constraint(equalTo: filterContainerView.centerYAnchor),
            filterIconBackgroundView.widthAnchor.constraint(equalToConstant: 32), // 원의 지름
            filterIconBackgroundView.heightAnchor.constraint(equalToConstant: 32), // 원의 지름
            
            // 필터 아이콘 위치 및 크기 설정
            filterIconView.centerXAnchor.constraint(equalTo: filterIconBackgroundView.centerXAnchor),
            filterIconView.centerYAnchor.constraint(equalTo: filterIconBackgroundView.centerYAnchor),
            filterIconView.widthAnchor.constraint(equalToConstant: 18), // 아이콘 크기
            filterIconView.heightAnchor.constraint(equalToConstant: 18), // 아이콘 크기
            
            // 세로 라인 높이를 버튼과 동일하게 설정
            separatorView.heightAnchor.constraint(equalTo: sortButton.heightAnchor, constant: -8)
        ])
    }
    
    private func setupBottomBorder() {
        // bottomBorder 생성 및 설정
        let border = CALayer()
        border.name = "BottomBorder" // 이름 설정
        border.backgroundColor = UIColor(hex: "#111111").withAlphaComponent(0.2).cgColor
        
        // 초기 프레임 (실제 크기는 viewDidLayoutSubviews에서 조정)
        border.frame = CGRect(x: 0, y: 0, width: bottomSheet.bounds.width, height: 0.75)
        
        // bottomBorder를 bottomSheet에 추가
        bottomSheet.layer.addSublayer(border)
    }

    private func setupStoreDetailsSection() {
        // 스크롤 뷰 생성
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .white
        scrollView.delegate = self // ScrollView Delegate 설정
        bottomSheet.addSubview(scrollView)

        // 콘텐츠 뷰 생성
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // 탭 바 높이 계산 (기본 높이 83으로 설정, 필요 시 확인)
        let tabBarHeight: CGFloat = 83

        // 스크롤 뷰와 콘텐츠 뷰의 제약 조건 설정
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: filterContainerView.bottomAnchor, constant: 4),
            scrollView.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomSheet.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // 폭 고정
        ])

        // 서버에서 제공되는 더미 데이터
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

        var lastView: UIView? = nil

        for data in storeData {
            if let storeCard = createStoreCard(from: data) {
                contentView.addSubview(storeCard)

                NSLayoutConstraint.activate([
                    storeCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0), // 카드 좌측 여백
                    storeCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0), // 카드 우측 여백
                    storeCard.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? contentView.topAnchor, constant: 0) // 카드 상단 여백
                ])

                lastView = storeCard
            }
        }

        // 빈 공간 뷰 추가
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spacerView)

        NSLayoutConstraint.activate([
            spacerView.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? contentView.topAnchor, constant: 0),
            spacerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacerView.heightAnchor.constraint(equalToConstant: tabBarHeight), // 탭바 높이만큼 공간 설정
            spacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) // 콘텐츠 뷰의 마지막
        ])
    }

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
        cardView.layer.cornerRadius = 0
        cardView.layer.borderWidth = 0
        cardView.layer.borderColor = UIColor.clear.cgColor
        cardView.layer.masksToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        // 하단 선 추가
        let cardBottomLine = UIView()
        cardBottomLine.backgroundColor = UIColor(white: 0.067, alpha: 0.2) // #111111 20% 투명도
        cardBottomLine.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(cardBottomLine)
        
        // 북마크 버튼 추가
        let bookmarkButton = UIButton(type: .custom)
        bookmarkButton.setImage(UIImage(named: "icon_scrape_unfilled"), for: .normal) // 북마크 안 된 상태
        bookmarkButton.setImage(UIImage(named: "icon_scrape"), for: .selected) // 북마크 된 상태
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false

        // 북마크 버튼 클릭 액션 추가
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped(_:)), for: .touchUpInside)

        // Store Name Label
        let nameLabel = UILabel()
        nameLabel.text = storeName
        nameLabel.font = UIFont(name: "Pretendard-Bold", size: 18)
        nameLabel.textColor = UIColor(hex: "#111111")

        // Status Label
        let statusLabel = UILabel()
        statusLabel.text = isClosed
        statusLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        statusLabel.textColor = UIColor(hex: "#3F8008")
        statusLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        statusLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        // Close Time Label
        let closeTimeLabel = UILabel()
        closeTimeLabel.text = closeTime
        closeTimeLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        closeTimeLabel.textColor = UIColor(hex: "#696969")
        closeTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        closeTimeLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // Status and Close Time Stack
        let statusStack = UIStackView(arrangedSubviews: [statusLabel, closeTimeLabel])
        statusStack.axis = .horizontal
        statusStack.alignment = .bottom
        statusStack.spacing = 4 // 딱 붙이기 위한 간격
        statusStack.translatesAutoresizingMaskIntoConstraints = false

        // Star Rating Section
        let starIcon = UIImageView(image: UIImage(named: "icon_star"))
        starIcon.contentMode = .scaleAspectFit
        starIcon.translatesAutoresizingMaskIntoConstraints = false

        let starRateLabel = UILabel()
        starRateLabel.text = String(format: "%.2f", starRate)
        starRateLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        starRateLabel.textColor = UIColor(hex: "#696969")
        // Hugging 및 Compression 설정
        starRateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        starRateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let reviewNumLabel = UILabel()
        reviewNumLabel.text = "(\(reviewNum))"
        reviewNumLabel.font = UIFont(name: "Pretendard-Regular", size: 10)
        reviewNumLabel.textColor = UIColor(hex: "#9C9B97")
        // Hugging 및 Compression 설정
        reviewNumLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        reviewNumLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        // Star Rating Stack
        let starStack = UIStackView(arrangedSubviews: [starIcon, starRateLabel, reviewNumLabel])
        starStack.axis = .horizontal
        starStack.spacing = 2 // 딱 붙이기 위한 간격
        starStack.alignment = .center
        starStack.translatesAutoresizingMaskIntoConstraints = false

        // Image Container
        let imageContainer = UIStackView()
        imageContainer.axis = .horizontal
        imageContainer.spacing = 8
        imageContainer.distribution = .fillEqually
        imageContainer.translatesAutoresizingMaskIntoConstraints = false

        for imageName in reviewsImage {
            if let image = UIImage(named: imageName) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 8
                imageContainer.addArrangedSubview(imageView)
            } else {
                print("❌ 이미지 로드 실패: \(imageName)")
            }
        }
        
        // Reviews Summary Label
        let descriptionLabel = UILabel()
        descriptionLabel.text = reviewsSummary
        descriptionLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = UIColor(hex: "#575754")
        
        // Reviews Summary Icon
        let reviewIcon = UIImageView(image: UIImage(named: "icon_review"))
        reviewIcon.contentMode = .scaleAspectFit
        reviewIcon.translatesAutoresizingMaskIntoConstraints = false

        // Horizontal Stack for Icon and Description Label
        let descriptionStack = UIStackView(arrangedSubviews: [reviewIcon, descriptionLabel])
        descriptionStack.axis = .horizontal
        descriptionStack.spacing = 4 // 아이콘과 텍스트 간 간격
        descriptionStack.alignment = .top // 수직 상단 정렬
        descriptionStack.translatesAutoresizingMaskIntoConstraints = false

        // Vertical Stack
        let verticalStack = UIStackView(arrangedSubviews: [nameLabel, statusStack, starStack, imageContainer, descriptionStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = 6
        verticalStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(verticalStack)
        cardView.addSubview(bookmarkButton)

        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            verticalStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            verticalStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),
            
            statusStack.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
            starStack.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
            starStack.bottomAnchor.constraint(equalTo: imageContainer.topAnchor, constant: -16), // starStack 하단 여백 (이미지 컨테이너 상단 여백)

            imageContainer.heightAnchor.constraint(equalToConstant: 154), // 이미지 섹션 높이 고정
            imageContainer.bottomAnchor.constraint(equalTo: descriptionStack.topAnchor, constant: -20), // 이미지 컨테이너 하단 여백

            // 북마크 버튼 위치 설정
            bookmarkButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            bookmarkButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 21),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 25),

            // Star Icon 크기
            starIcon.widthAnchor.constraint(equalToConstant: 14),
            starIcon.heightAnchor.constraint(equalToConstant: 14),
            
            // Review Icon 크기
            reviewIcon.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: 4),
            reviewIcon.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -8), // 오른쪽 여백
            reviewIcon.widthAnchor.constraint(equalToConstant: 20),
            reviewIcon.heightAnchor.constraint(equalToConstant: 20),
            
            // 하단 선
            cardBottomLine.heightAnchor.constraint(equalToConstant: 0.5), // 선 두께
            cardBottomLine.leadingAnchor.constraint(equalTo: cardView.leadingAnchor), // 카드뷰 왼쪽 끝
            cardBottomLine.trailingAnchor.constraint(equalTo: cardView.trailingAnchor), // 카드뷰 오른쪽 끝
            cardBottomLine.bottomAnchor.constraint(equalTo: cardView.bottomAnchor) // 카드뷰 하단에 고정
        ])
        
        return cardView
    }

    @objc private func bookmarkButtonTapped(_ sender: UIButton) {
        // 상태를 토글
        sender.isSelected.toggle()

        if sender.isSelected {
            print("북마크 추가")
            // 북마크 추가 로직 (예: 서버에 API 호출)
        } else {
            print("북마크 삭제")
            // 북마크 삭제 로직 (예: 서버에 API 호출)
        }
    }

    // 필터 버튼 생성 메서드
    private static func createFilterButton(title: String, fontWeight: String) -> UIButton {
        let button = UIButton(type: .system)
        
        // 텍스트 및 폰트 설정
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-\(fontWeight)", size: 15) ?? UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor(hex: "#111111").withAlphaComponent(0.5), for: .normal)
        
        // 내용 패딩 설정
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        
        // 버튼 모양 및 테두리 설정
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 16 // 36의 절반인 18로 설정
        button.layer.borderWidth = 0.75
        button.layer.borderColor = UIColor(hex: "#111111").withAlphaComponent(0.2).cgColor
        button.layer.masksToBounds = true
        
        return button
    }
    
    // ScrollView Delegate Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !shouldAllowScroll {
            // 스크롤을 막고, BottomSheet 드래그를 대신 처리
            scrollView.contentOffset = .zero
        }
    }

    // 바텀 시트 드래그 제스처 처리
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        // BottomSheet 상태 계산
        let expandedPosition = view.frame.height * 0.1
        let collapsedPosition = view.frame.height * 0.6
        
        switch recognizer.state {
        case .changed:
            let newTopConstant = bottomSheetTopConstraint.constant + translation.y
            
            if newTopConstant >= expandedPosition && newTopConstant <= collapsedPosition {
                bottomSheetTopConstraint.constant = newTopConstant
                recognizer.setTranslation(.zero, in: view)
            }
            
        case .ended:
            // 스크롤 속도에 따라 위치 결정
            if velocity.y > 0 {
                // 내려가기
                bottomSheetTopConstraint.constant = collapsedPosition
                shouldAllowScroll = false // 내부 스크롤 비활성화
            } else {
                // 올라가기
                bottomSheetTopConstraint.constant = expandedPosition
                shouldAllowScroll = true // 내부 스크롤 활성화
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        default:
            break
        }
    }

}

// UIColor 확장: HEX 색상 지원
extension UIColor {
    convenience init(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
