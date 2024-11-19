import UIKit

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // 기본 Back Button 비활성화
        navigationItem.hidesBackButton = true

        // 네비게이션 바의 커스텀 뷰 추가
        setupNavigationBarContent()
    }

    // 네비게이션 바 콘텐츠 설정
    private func setupNavigationBarContent() {
        // 커스텀 Back Button 생성
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "icon_back"), for: .normal) // 아이콘 설정
        backButton.tintColor = .black // 아이콘 색상 설정
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside) // 액션 연결
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true

        // 검색 바 컨테이너 뷰 생성
        let searchContainerView = UIView()
        searchContainerView.layer.cornerRadius = 18
        searchContainerView.backgroundColor = UIColor(hex: "#111111").withAlphaComponent(0.06)
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false

        // 검색 아이콘 설정
        let searchIconView = UIImageView(image: UIImage(named: "icon_search"))
        searchIconView.contentMode = .scaleAspectFit
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchIconView)

        // 텍스트 필드 설정
        let searchTextField = UITextField()
        searchTextField.placeholder = "지역, 공간, 메뉴 검색"
        searchTextField.borderStyle = .none
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchTextField)

        // Clear 버튼 설정
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "icon_search_x"), for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(clearButton)

        // 검색 바 내부 레이아웃 설정
        NSLayoutConstraint.activate([
            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 12),
            searchIconView.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 20),

            searchTextField.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: 8),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),

            clearButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 8),
            clearButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -12),
            clearButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 20),

            searchContainerView.heightAnchor.constraint(equalToConstant: 36)
        ])

        // StackView 생성
        let stackView = UIStackView(arrangedSubviews: [backButton, searchContainerView])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // 네비게이션 바에 추가
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(stackView)
        navigationItem.titleView = titleView

        // StackView 및 TitleView 제약 설정
        NSLayoutConstraint.activate([
            // StackView가 TitleView에 딱 맞게 위치
            stackView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: titleView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),

            // 검색 바의 너비가 Back Button을 제외한 남은 공간을 차지하도록 설정
            searchContainerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 25 - 16) // 25px은 Back Button 크기, 16은 좌우 패딩
        ])
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
