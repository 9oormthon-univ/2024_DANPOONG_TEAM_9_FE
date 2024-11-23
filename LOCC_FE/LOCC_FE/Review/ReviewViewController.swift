import UIKit

class ReviewViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private var reviews: [Review] = [] // 리뷰 데이터
    
    // 점들을 담을 스택뷰
    private let dotsStackView = UIStackView()
    private var dotViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchReviews(storeId: 1)
        
        setupData()
        setupUI()
        setupSwipeGesture() // 스와이프 제스처 추가
    }
    
    private func fetchReviews(storeId: Int) {
        let urlString = "http://13.209.85.14/api/v1/reviews?storeId=\(storeId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let jwtToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjaGFlaW5nZUBrYWthby5jb20iLCJ1c2VybmFtZSI6IuyehOyxhOyYgSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMyMTgzNDMzLCJleHAiOjE3MzMwNDc0MzN9.EfZBwT15UZxcXGoa3YXR4TbnhP8rGqK1aYBAE5IrvWA"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching reviews: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)") // 상태 코드 출력
                if !(200...299).contains(httpResponse.statusCode) {
                    print("Invalid response or status code")
                    return
                }
            }

            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("Fetched Data: \(jsonString)")
            } else {
                print("No data received or data is corrupted.")
            }
        }
        task.resume()
    }

    // 1. 리뷰 데이터 설정
    private func setupData() {
        reviews = [
            Review(image: UIImage(named: "image1"), title: "로슈아커피", date: "2024년 11월 2일 방문", description: "커다란 은행 나무가 테라스에 있어 멋진 뷰와 함께 여유롭게 커피를 마실 수 있는 카페입니다."),
            Review(image: UIImage(named: "image2"), title: "카페 비안코", date: "2024년 10월 15일 방문", description: "아늑한 분위기와 따뜻한 조명에서 특별한 브런치를 즐길 수 있는 카페."),
            Review(image: UIImage(named: "image3"), title: "가을 카페", date: "2024년 9월 21일 방문", description: "가을 풍경을 느낄 수 있는 멋진 카페입니다."),
            Review(image: UIImage(named: "image4"), title: "겨울 커피집", date: "2024년 12월 1일 방문", description: "따뜻한 겨울 느낌을 살릴 수 있는 카페입니다."),
            Review(image: UIImage(named: "image5"), title: "겨울 커피집", date: "2024년 12월 1일 방문", description: "따뜻한 겨울 느낌을 살릴 수 있는 카페입니다."),
        ]
    }
    
    // 2. UI 구성
    private func setupUI() {
        view.backgroundColor = .black // 배경색 설정
        
        // ScrollView 설정
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 리뷰 페이지 추가
        setupReviewPages()
        
        // Custom PageControl 설정
        setupCustomPageControl()
    }
    
    // 3. 리뷰 페이지 추가
    private func setupReviewPages() {
        for (index, review) in reviews.enumerated() {
            let reviewView = createReviewView(for: review)
            reviewView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(reviewView)
            
            // 각 페이지 위치 설정
            NSLayoutConstraint.activate([
                reviewView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                reviewView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                reviewView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * view.bounds.width),
                reviewView.topAnchor.constraint(equalTo: scrollView.topAnchor)
            ])
        }
        
        // ScrollView 콘텐츠 크기 설정
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(reviews.count), height: view.bounds.height)
    }
    
    // 4. Custom PageControl 설정
    private func setupCustomPageControl() {
        // StackView 설정
        dotsStackView.axis = .horizontal
        dotsStackView.alignment = .center
        dotsStackView.distribution = .fillEqually
        dotsStackView.spacing = 4 // 점 사이 간격
        dotsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dotsStackView)
        
        NSLayoutConstraint.activate([
            dotsStackView.heightAnchor.constraint(equalToConstant: 4), // 점 높이
            dotsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dotsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dotsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        // 점(dot) 뷰 생성
        for _ in 0..<reviews.count {
            let dotView = UIView()
            dotView.layer.cornerRadius = 2 // 점의 반지름 (동그랗게 만들기)
            dotView.backgroundColor = UIColor.white.withAlphaComponent(0.5) // 비활성화된 점 색상
            dotView.translatesAutoresizingMaskIntoConstraints = false
            dotsStackView.addArrangedSubview(dotView)
            
            // 각 점의 가로 길이를 계산하여 설정
            let dotWidth = (view.bounds.width - 40 - CGFloat(reviews.count - 1) * 12) / CGFloat(reviews.count)
            NSLayoutConstraint.activate([
                dotView.widthAnchor.constraint(equalToConstant: dotWidth), // 동적으로 계산된 너비
                dotView.heightAnchor.constraint(equalToConstant: 4) // 고정된 높이
            ])
            
            dotViews.append(dotView)
        }
        
        // 첫 번째 점 활성화
        if let firstDot = dotViews.first {
            firstDot.backgroundColor = .white // 활성화된 점 색상
        }
    }
    
    // 5. 리뷰 뷰 생성
    private func createReviewView(for review: Review) -> UIView {
        let reviewView = UIView()
        
        // 배경 이미지
        let imageView = UIImageView(image: review.image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        reviewView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: reviewView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: reviewView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: reviewView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: reviewView.bottomAnchor)
        ])
        
        // Gradient View 추가
        let gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        reviewView.addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: reviewView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: reviewView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: reviewView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: reviewView.bottomAnchor)
        ])
        
        // Gradient Layer 설정
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.444).cgColor,
            UIColor.black.withAlphaComponent(0.6).cgColor
        ]
        gradientLayer.locations = [0.0, 0.82, 1.0]
        
        // Gradient Layer 크기 업데이트
        DispatchQueue.main.async {
            gradientLayer.frame = gradientView.bounds
            gradientView.layer.addSublayer(gradientLayer)
        }
        
        // 텍스트 오버레이 StackView
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 8
        textStack.translatesAutoresizingMaskIntoConstraints = false

        // Title Stack (아이콘 + 타이틀)
        let titleStack = UIStackView()
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        titleStack.spacing = 8
        titleStack.translatesAutoresizingMaskIntoConstraints = false

        // Icon for Location
        let locationIcon = UIImageView(image: UIImage(named: "icon_location_orange"))
        locationIcon.contentMode = .scaleAspectFit
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true // 아이콘 크기 설정
        locationIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = review.title
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 18)
        titleLabel.textColor = .white

        // Add Icon and Title to Title Stack
        titleStack.addArrangedSubview(locationIcon)
        titleStack.addArrangedSubview(titleLabel)

        // Date Label
        let dateLabel = UILabel()
        dateLabel.text = review.date
        dateLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        dateLabel.textColor = UIColor(hex: "FFFFFF").withAlphaComponent(0.8)

        // Description Label
        let descriptionLabel = UILabel()
        descriptionLabel.text = review.description
        descriptionLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
        descriptionLabel.textColor = UIColor(hex: "FFFFFF").withAlphaComponent(0.9)
        descriptionLabel.numberOfLines = 2

        // Add Title Stack, Date, and Description to Text Stack
        textStack.addArrangedSubview(titleStack)
        textStack.addArrangedSubview(dateLabel)
        textStack.addArrangedSubview(descriptionLabel)

        
        // 아이콘 StackView
        let iconStack = UIStackView()
        iconStack.axis = .vertical
        iconStack.alignment = .center
        iconStack.spacing = 12
        iconStack.translatesAutoresizingMaskIntoConstraints = false

        // Like Icon + 좋아요 개수 Stack
        let likeStack = UIStackView()
        likeStack.axis = .vertical
        likeStack.alignment = .center
        likeStack.spacing = 4
        likeStack.translatesAutoresizingMaskIntoConstraints = false

        let likeIcon = UIImageView(image: UIImage(named: "icon_like_stroke"))
        likeIcon.contentMode = .scaleAspectFit
        likeIcon.translatesAutoresizingMaskIntoConstraints = false
        likeIcon.widthAnchor.constraint(equalToConstant: 32).isActive = true
        likeIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // Add Tap Gesture to likeIcon
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLikeIconTap))
        likeIcon.isUserInteractionEnabled = true // Enable user interaction
        likeIcon.addGestureRecognizer(tapGesture)

        let likeCountLabel = UILabel()
        likeCountLabel.text = "827" // 좋아요 개수
        likeCountLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        likeCountLabel.textColor = .white
        likeCountLabel.textAlignment = .center
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false

        likeStack.addArrangedSubview(likeIcon)
        likeStack.addArrangedSubview(likeCountLabel)

        // Share Icon + 공유 텍스트 Stack
        let shareStack = UIStackView()
        shareStack.axis = .vertical
        shareStack.alignment = .center
        shareStack.spacing = 4
        shareStack.translatesAutoresizingMaskIntoConstraints = false

        let shareIcon = UIImageView(image: UIImage(named: "icon_share"))
        shareIcon.contentMode = .scaleAspectFit
        shareIcon.translatesAutoresizingMaskIntoConstraints = false
        shareIcon.widthAnchor.constraint(equalToConstant: 32).isActive = true
        shareIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true

        let shareLabel = UILabel()
        shareLabel.text = "공유" // 공유 텍스트
        shareLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        shareLabel.textColor = .white
        shareLabel.textAlignment = .center
        shareLabel.translatesAutoresizingMaskIntoConstraints = false

        shareStack.addArrangedSubview(shareIcon)
        shareStack.addArrangedSubview(shareLabel)

        // Add to Icon Stack
        iconStack.addArrangedSubview(likeStack)
        iconStack.addArrangedSubview(shareStack)
        
        // Horizontal StackView
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 16 // 두 스택 사이 간격 설정
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        reviewView.addSubview(horizontalStack)

        // textStack 추가
        textStack.setContentHuggingPriority(.defaultLow, for: .horizontal) // textStack이 남은 공간을 채우도록 설정
        textStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal) // 압축에 대한 저항 우선순위 낮게 설정
        horizontalStack.addArrangedSubview(textStack)

        // iconStack 추가
        iconStack.setContentHuggingPriority(.required, for: .horizontal) // iconStack의 크기가 고정되도록 설정
        iconStack.setContentCompressionResistancePriority(.required, for: .horizontal) // 압축되지 않도록 설정
        horizontalStack.addArrangedSubview(iconStack)

        // iconStack 너비 고정
        NSLayoutConstraint.activate([
            iconStack.widthAnchor.constraint(equalToConstant: 32), // iconStack 너비를 32로 고정
            horizontalStack.leadingAnchor.constraint(equalTo: reviewView.leadingAnchor, constant: 20),
            horizontalStack.trailingAnchor.constraint(equalTo: reviewView.trailingAnchor, constant: -20),
            horizontalStack.bottomAnchor.constraint(equalTo: reviewView.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])

        
        return reviewView
    }

    // 6. ScrollView Delegate 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        
        // 모든 점을 비활성화 색상으로 설정
        dotViews.forEach { $0.backgroundColor = UIColor.white.withAlphaComponent(0.5) }
        
        // 현재 활성화된 점을 활성화 색상으로 설정
        if pageIndex < dotViews.count {
            dotViews[pageIndex].backgroundColor = .white
        }
    }
    
    private func setupSwipeGesture() {
        // UISwipeGestureRecognizer 설정
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .right // 오른쪽으로 스와이프
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        // 이전 화면으로 돌아가기
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleLikeIconTap(_ sender: UITapGestureRecognizer) {
        // Check if the tapped view is likeIcon
        if let likeIcon = sender.view as? UIImageView {
            // Toggle the image between `icon_like_stroke` and `icon_like`
            if likeIcon.image == UIImage(named: "icon_like_stroke") {
                likeIcon.image = UIImage(named: "icon_like")
                print("like icon 활성화")
            } else {
                likeIcon.image = UIImage(named: "icon_like_stroke")
                print("like icon 비활성화")
            }
        }
    }

}

// 리뷰 데이터 모델
struct Review {
    let image: UIImage?
    let title: String
    let date: String
    let description: String
}
