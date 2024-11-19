//
//  HomeViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import UIKit
import DropDown

class HomeViewController: UIViewController {
    
    // view
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // button
    @IBOutlet weak var logoBtn: UIButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var allBtn1: UIButton!
    @IBOutlet weak var allBtn2: UIButton!
    
    
    // label
    @IBOutlet weak var todayCurate: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var loccLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var watchReviewLabel: UILabel!
    
    
    // instance
    let dropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBtn()
        setupConstraints()
        
    }
    
    private func setupUI() {
        todayCurate.font = UIFont(name: "Pretendard-Bold", size: 16)
        rewardLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        loccLabel.font = UIFont(name: "Pretendard-Medium", size: 15)
        loccLabel.textColor = UIColor.subLabel
        reviewLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        watchReviewLabel.font = UIFont(name: "Pretendard-Medium", size: 15)
        watchReviewLabel.textColor = UIColor.subLabel
    }

    private func setupBtn() {
        // 버튼 스타일 설정
        dropDownBtn.setTitle("전국", for: .normal)
        dropDownBtn.setTitleColor(.selectedGreen, for: .normal)
        dropDownBtn.backgroundColor = UIColor.buttonBackground
        dropDownBtn.layer.borderWidth = 1
        dropDownBtn.layer.borderColor = UIColor.selectedGreen.cgColor
        dropDownBtn.layer.cornerRadius = 15
        dropDownBtn.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)

        // 왼쪽 이미지 (icon_location)
        let leftImage = UIImage(named: "icon_location")
        let leftImageView = UIImageView(image: leftImage)
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.frame = CGRect(x: 9, y: (dropDownBtn.frame.height - 13.61) / 2, width: 10.67, height: 13.61)
        dropDownBtn.addSubview(leftImageView)
        
        // 오른쪽 이미지 (down)
        let rightImage = UIImage(named: "down")
        let rightImageView = UIImageView(image: rightImage)
        rightImageView.contentMode = .scaleAspectFit
        rightImageView.frame = CGRect(x: dropDownBtn.frame.width - 9 - 9, y: (dropDownBtn.frame.height - 6) / 2, width: 11, height: 8)
        dropDownBtn.addSubview(rightImageView)

        // 드롭다운 설정
        dropDown.anchorView = dropDownBtn
        dropDown.dataSource = ["전국", "서울", "경기도", "인천", "강원도", "대전", "충청도", "전라도", "광주", "경상도", "대구", "부산", "울산", "제주도"]
        
        // 드롭다운 항목을 선택했을 때의 동작
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.dropDownBtn.setTitle(item, for: .normal)
        }
        
        // 드롭다운 위치 설정 (버튼 아래)
        dropDown.bottomOffset = CGPoint(x: 0, y: dropDownBtn.frame.size.height)
    }

    private func setupConstraints() {
        // Auto Layout 제약 조건 비활성화
        logoBtn.translatesAutoresizingMaskIntoConstraints = false
        dropDownBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // dropDownBtn 상단 위치 설정
            dropDownBtn.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            
            // dropDownBtn 크기 설정
            dropDownBtn.widthAnchor.constraint(equalToConstant: 73),
            dropDownBtn.heightAnchor.constraint(equalToConstant: 30),
            
            // dropDownBtn과 logoBtn 사이의 간격 설정
            dropDownBtn.leadingAnchor.constraint(equalTo: logoBtn.trailingAnchor, constant: 190),
            
            // dropDownBtn의 오른쪽 여백 설정
            dropDownBtn.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20)
        ])
    }

    // 드롭다운 메뉴 표시
    @objc func showDropDown() {
        dropDown.show()
    }
}
