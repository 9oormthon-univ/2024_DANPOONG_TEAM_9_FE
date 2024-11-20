//
//  HomeViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // view
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var curateView: UICollectionView!
    @IBOutlet weak var benefitView: UICollectionView!
    @IBOutlet weak var provinceView: UICollectionView!
    @IBOutlet weak var adView: UICollectionView!
    @IBOutlet weak var reviewView: UICollectionView!
    
    // button
    @IBOutlet weak var logoBtn: UIButton!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var allBtn1: UIButton!
    @IBOutlet weak var allBtn2: UIButton!
    
    // label
    @IBOutlet weak var todayCurate: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var loccLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var watchReviewLabel: UILabel!
    
    // instance
    let curateLayout = UICollectionViewFlowLayout()
    let benefitLayout = UICollectionViewFlowLayout()
    let provinceLayout = UICollectionViewFlowLayout()
    let adLayout = UICollectionViewFlowLayout()
    let reviewLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBtn()
        setupConstraints()
        registerNib()
        setupLayout()
        
        self.curateView.delegate = self
        self.curateView.dataSource = self
        
        self.benefitView.delegate = self
        self.benefitView.dataSource = self
        
        self.provinceView.delegate = self
        self.provinceView.dataSource = self
        
        self.adView.delegate = self
        self.adView.dataSource = self
        
        self.reviewView.delegate = self
        self.reviewView.dataSource = self
    }
    
    private func setupLayout() {
        curateLayout.scrollDirection = .horizontal
        curateView.collectionViewLayout = curateLayout
        
        benefitLayout.scrollDirection = .horizontal
        benefitView.collectionViewLayout = benefitLayout
        
        provinceLayout.scrollDirection = .horizontal
        provinceView.collectionViewLayout = provinceLayout
        
        adLayout.scrollDirection = .horizontal
        adView.collectionViewLayout = adLayout
        
        reviewView.collectionViewLayout = reviewLayout
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
        regionBtn.setTitle("전국", for: .normal)
        regionBtn.setTitleColor(.selectedGreen, for: .normal)
        regionBtn.backgroundColor = UIColor.buttonBackground
        regionBtn.layer.borderWidth = 1
        regionBtn.layer.borderColor = UIColor.selectedGreen.cgColor
        regionBtn.layer.cornerRadius = 15

        // 왼쪽 이미지 (icon_location)
        let leftImage = UIImage(named: "icon_location")
        let leftImageView = UIImageView(image: leftImage)
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.frame = CGRect(x: 9, y: (regionBtn.frame.height - 13.61) / 2, width: 10.67, height: 13.61)
        regionBtn.addSubview(leftImageView)
        
        // 오른쪽 이미지 (down)
        let rightImage = UIImage(named: "down")
        let rightImageView = UIImageView(image: rightImage)
        rightImageView.contentMode = .scaleAspectFit
        rightImageView.frame = CGRect(x: regionBtn.frame.width - 9 - 9, y: (regionBtn.frame.height - 6) / 2, width: 11, height: 8)
        regionBtn.addSubview(rightImageView)
    }

    private func setupConstraints() {
        // Auto Layout 제약 조건 비활성화
        logoBtn.translatesAutoresizingMaskIntoConstraints = false
        regionBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // dropDownBtn 상단 위치 설정
            regionBtn.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            
            // dropDownBtn 크기 설정
            regionBtn.widthAnchor.constraint(equalToConstant: 73),
            regionBtn.heightAnchor.constraint(equalToConstant: 30),
            
            // dropDownBtn과 logoBtn 사이의 간격 설정
            regionBtn.leadingAnchor.constraint(equalTo: logoBtn.trailingAnchor, constant: 190),
            
            // dropDownBtn의 오른쪽 여백 설정
            regionBtn.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20)
        ])
    }
    
    private func registerNib() {
        let curateNib = UINib(nibName: "CurateCollectionViewCell", bundle: nil)
        curateView.register(curateNib, forCellWithReuseIdentifier: "curateCell")
        
        let benefitNib = UINib(nibName: "BenefitCollectionViewCell", bundle: nil)
        benefitView.register(benefitNib, forCellWithReuseIdentifier: "benefitCell")
        
        let provinceNib = UINib(nibName: "ProvinceCollectionViewCell", bundle: nil)
        provinceView.register(provinceNib, forCellWithReuseIdentifier: "provinceCell")
        
        let adNib = UINib(nibName: "AdCollectionViewCell", bundle: nil)
        adView.register(adNib, forCellWithReuseIdentifier: "adCell")
        
        let reviewNib = UINib(nibName: "ReviewCollectionViewCell", bundle: nil)
        reviewView.register(reviewNib, forCellWithReuseIdentifier: "reviewCell")
    }
}

// extension
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == curateView {
            return 3
        } else if collectionView == benefitView {
            return 4
        } else if collectionView == provinceView {
            return 14
        } else if collectionView == adView {
            return 3
        } else if collectionView == reviewView {
            return 2
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == curateView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "curateCell", for: indexPath) as? CurateCollectionViewCell else {
                return UICollectionViewCell()
            }

            // 임시 데이터 설정 (curateView용)
            let images = ["test_image", "test_image", "test_image"]
            let titles = ["강원도 감자 특선 3곳", "강원도 감자 특선 3곳", "강원도 감자 특선 3곳"]
            let subtitles = ["강원도 감자 코스\n모든 게 감자 감자 감자", "강원도 감자 코스\n모든 게 감자 감자 감자", "강원도 감자 코스\n모든 게 감자 감자 감자"]

            cell.curateImg.image = UIImage(named: images[indexPath.item])
            cell.curateTitle.text = titles[indexPath.item]
            cell.curateSubTitle.text = subtitles[indexPath.item]

            cell.curateTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
            cell.curateSubTitle.font = UIFont(name: "Pretendard-Regular", size: 16)
            
            cell.curateImg.layer.cornerRadius = 32
            cell.curateImg.layer.masksToBounds = true
            
            return cell
        } else if collectionView == benefitView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "benefitCell", for: indexPath) as? BenefitCollectionViewCell else {
                return UICollectionViewCell()
            }

            // 여기에 benefitView용 데이터 및 스타일 설정
            let images = ["test_image", "test_image", "test_image", "test_image"] // 이미지 이름 배열
            let storeNames = ["까사부사노", "웨스턴조선서울 라운지", "까사부사노", "웨스턴조선서울 라운지"] // 상점 이름 배열
            let storeCities = ["서울", "부산", "대구", "광주"] // 상점 도시 배열
            let storeRates = ["4.5", "4.0", "4.8", "3.9"] // 별점 배열
            
            cell.benefitImg.image = UIImage(named: images[indexPath.item]) // 이미지 설정
            cell.storeName.text = storeNames[indexPath.item] // 상점 이름 설정
            cell.storeCity.text = storeCities[indexPath.item] // 상점 도시 설정
            cell.storeRate.text = storeRates[indexPath.item] // 별점 설정
            
            // 셀의 UI 스타일 설정
            cell.storeName.font = UIFont(name: "Pretendard-SemiBold", size: 14)
            cell.storeCity.font = UIFont(name: "Pretendard-Medium", size: 12)
            cell.storeRate.font = UIFont(name: "Pretendard-Medium", size: 12)
            
            // cornerRadius 설정
            cell.benefitImg.layer.cornerRadius = 5
            cell.benefitImg.layer.masksToBounds = true // 경계가 둥글게 잘리도록 설정

            return cell
        } else if collectionView == provinceView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "provinceCell", for: indexPath) as? ProvinceCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            // 여기에 benefitView용 데이터 및 스타일 설정
            let images = ["test_image", "test_image", "test_image", "test_image", "test_image", "test_image", "test_image", "test_image", "test_image", "test_image", "test_image", "test_image", "test_image", "test_image"] // 이미지 이름 배열
            
            cell.provinceImg.image = UIImage(named: images[indexPath.item]) // 이미지 설정
            
            cell.provinceImg.layer.cornerRadius = 19.26
            cell.provinceImg.layer.masksToBounds = true // 경계가 둥글게 잘리도록 설정

            return cell
        } else if collectionView == adView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath) as? AdCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            // 여기에 benefitView용 데이터 및 스타일 설정
            let images = ["test_image", "test_image", "test_image"] // 이미지 이름 배열
            let adTitle = ["쏘카 3시간 할인 지역 보기", "쏘카 3시간 할인 지역 보기", "쏘카 3시간 할인 지역 보기"] // 상점 이름 배열
            let adSubTitle = ["이동할 때부터 지칠 수는 없으니까\n친구들이랑 편하게", "이동할 때부터 지칠 수는 없으니까\n친구들이랑 편하게", "이동할 때부터 지칠 수는 없으니까\n친구들이랑 편하게"]
            
            cell.adImg.image = UIImage(named: images[indexPath.item]) // 이미지 설정
            cell.adTitle.text = adTitle[indexPath.item] // 상점 이름 설정
            cell.adSubTitle.text = adSubTitle[indexPath.item] // 상점 이름 설정
            
            cell.adTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
            cell.adSubTitle.font = UIFont(name: "Pretendard-Regular", size: 16)
            
            return cell
        } else if collectionView == reviewView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as? ReviewCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            // 여기에 benefitView용 데이터 및 스타일 설정
            let images = ["test_image", "test_image"]
            let names = ["우수한탐방러_457", "우수한탐방러_457"]
            let reviewStoreNames = ["양지경성 광안 본점", "양지경성 광안 본점"]
            let reviewCategorys = ["카페", "카페"]
            let reviewRates = ["4.4", "4.4"]
            let reviewCnts = ["(274)", "(274)"]
            
            cell.reviewImg.image = UIImage(named: images[indexPath.item])
            cell.userName.text = names[indexPath.item]
            cell.reviewStoreName.text = reviewStoreNames[indexPath.item]
            cell.category.text = reviewCategorys[indexPath.item]
            cell.reviewRate.text = reviewRates[indexPath.item]
            cell.reviewCnt.text = reviewCnts[indexPath.item]
            
            cell.userName.font = UIFont(name: "Pretendard-SemiBold", size: 10)
            cell.reviewStoreName.font = UIFont(name: "Pretendard-SemiBold", size: 14)
            cell.category.font = UIFont(name: "Pretendard-Medium", size: 12)
            cell.reviewRate.font = UIFont(name: "Pretendard-Medium", size: 10)
            cell.reviewCnt.font = UIFont(name: "Pretendard-Medium", size: 8)
            
            cell.baseView.layer.cornerRadius = 20
            cell.baseView.layer.masksToBounds = true // 경계가 둥글게 잘리도록 설정
            
            cell.nameView.layer.cornerRadius = 4
            cell.nameView.layer.masksToBounds = true
            
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == curateView {
            return CGSize(width: 274, height: 371)
        } else if collectionView == benefitView {
            return CGSize(width: 149, height: 139)
        } else if collectionView == provinceView {
            return CGSize(width: 61, height: 61)
        } else if collectionView == adView {
            return CGSize(width: 393, height: 204)
        } else if collectionView == reviewView {
            return CGSize(width: 169, height: 188)
        }
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == curateView {
            return 20
        } else if collectionView == benefitView {
            return 10
        } else if collectionView == provinceView {
            return 10.7
        } else if collectionView == adView {
            return 0
        } else if collectionView == reviewView {
            return 15
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == curateView {
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else if collectionView == benefitView {
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else if collectionView == provinceView {
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else if collectionView == adView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else if collectionView == reviewView {
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
        return UIEdgeInsets.zero
    }

}
