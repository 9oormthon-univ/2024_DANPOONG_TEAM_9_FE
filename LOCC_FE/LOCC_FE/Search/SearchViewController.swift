import UIKit

class SearchViewController: UIViewController {
    // UI 요소 선언
    private let searchTextField = UITextField() // searchTextField를 클래스 멤버로 선언

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 기본 네비게이션 바 숨기기
        navigationController?.isNavigationBarHidden = true
        
        // 폰트 및 UI 설정
        setupFont()
        setupUI()
    }
    
    private func setupFont() {
        searchTextField.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    private func setupUI() {
        setupCustomNavigationBar()
    }

    private func setupCustomNavigationBar() {
        // 커스텀 네비게이션 바 생성
        let customNavBar = UIView()
        customNavBar.backgroundColor = .white
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavBar)
        
        // Back 버튼 생성
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "icon_back"), for: .normal)
        backButton.tintColor = UIColor(hex: "#8C8D90")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.addSubview(stackView)
        
        // Border 추가
        let border = UIView()
        border.backgroundColor = UIColor(hex: "#111111").withAlphaComponent(0.2)
        border.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.addSubview(border)
        
        // 커스텀 네비게이션 바 및 StackView 레이아웃 설정
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            searchContainerView.widthAnchor.constraint(equalTo: customNavBar.widthAnchor, multiplier: 0.8),
            
            // Border 레이아웃 설정
            border.heightAnchor.constraint(equalToConstant: 0.75),
            border.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor),
            border.bottomAnchor.constraint(equalTo: customNavBar.bottomAnchor)
        ])
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
