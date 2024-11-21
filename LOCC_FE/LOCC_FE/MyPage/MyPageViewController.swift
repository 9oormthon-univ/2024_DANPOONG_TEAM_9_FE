//
//  MyPageViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/19/24.
//

import UIKit
import Alamofire

class MyPageViewController: UIViewController {
    
    // image
    @IBOutlet weak var profileImg: UIImageView!
    
    // label
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    // MARK: - Constants
    private enum Constants {
        static let segmentedControlHeight: CGFloat = 40
        static let underlineViewColor: UIColor = .selectedGreen
        static let underlineViewHeight: CGFloat = 4
        static let topOffset: CGFloat = 194
    }

    // MARK: - Views
    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.background
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.backgroundColor = UIColor.background
        control.insertSegment(withTitle: "큐레이션", at: 0, animated: true)
        control.insertSegment(withTitle: "내 리스트", at: 1, animated: true)
        control.selectedSegmentIndex = 0
        configureSegmentedControlStyle(for: control)
        control.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Constants.underlineViewColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()

    private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
        return bottomUnderlineView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControlLayout()
        getMyInfo()
    }
    
    func getMyInfo() {
        // UserDefaults에서 서버 AccessToken 가져오기
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Error: No access token found.")
            return
        }

        // API 엔드포인트 설정
        let endpoint = "/api/v1/users/me/profile"

        // APIClient를 사용하여 GET 요청
        APIClient.getRequest(endpoint: endpoint, token: token, headerType: .authorization) { (result: Result<MyPageResponse, AFError>) in
            switch result {
            case .success(let myPageResponse):
                guard let userData = myPageResponse.data else {
                    print("API 응답은 성공했으나 데이터가 없습니다.")
                    print("전체 응답: \(myPageResponse)")
                    return
                }
                
                // UI 업데이트
                DispatchQueue.main.async {
                    self.nameLabel.text = userData.username
                }

                print("Username: \(userData.username)")

            case .failure(let error):
                print("API 호출 실패: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Layout and Style
    private func setupSegmentedControlLayout() {
        view.addSubview(segmentedControlContainerView)
        segmentedControlContainerView.addSubview(segmentedControl)
        segmentedControlContainerView.addSubview(bottomUnderlineView)

        NSLayoutConstraint.activate([
            // Container constraints
            segmentedControlContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            segmentedControlContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControlContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            segmentedControlContainerView.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight),
            
            // Segmented control constraints
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainerView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainerView.leadingAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: segmentedControlContainerView.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControlContainerView.centerYAnchor),
            
            // Underline constraints
            bottomUnderlineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
            leadingDistanceConstraint,
            bottomUnderlineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments))
        ])
    }

    private func configureSegmentedControlStyle(for control: UISegmentedControl) {
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.segmentedGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ], for: .normal)
        
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.labelGreen,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ], for: .selected)
        
        let backgroundImage = UIImage(color: UIColor.background)
        control.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        control.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        control.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        control.setDividerImage(backgroundImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    // MARK: - Actions
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        changeSegmentedControlLinePosition()
    }

    private func changeSegmentedControlLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.leadingDistanceConstraint.constant = leadingDistance
            self?.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIImage Extension
extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImageView {
    func load(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
