//
//  HomeViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import UIKit
import Alamofire

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
    
    // property
    private var curations: [HomeCuration] = []
    private var benefits: [HomeBenefit] = []
    private var provinces: [HomeProvince] = []
    private var advertisements: [HomeAdvertisement] = []
    private var reviews: [HomeReview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBtn()
        setupConstraints()
        registerNib()
        setupLayout()
        
        fetchHome()
        
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
    
    // MARK: - 큐레이션 데이터 가져오기
    private func fetchHome() {
        // UserDefaults에서 서버 AccessToken 가져오기
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Error: No access token found.")
            return
        }

        // API 엔드포인트 설정
        let endpoint = "/api/v1/home"

        APIClient.getRequest(endpoint: endpoint, token: token, headerType: .authorization) { (result: Result<HomeResponse, AFError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.curations = response.data.curations
                    self.benefits = response.data.benefits
                    self.provinces = response.data.provinces
                    self.advertisements = response.data.advertisements
                    self.reviews = response.data.reviews
                    
                    self.curateView.reloadData()
                    self.benefitView.reloadData()
                    self.provinceView.reloadData()
                    self.adView.reloadData()
                    self.reviewView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching home data: \(error.localizedDescription)")
                }
            }
        }
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
        
        reviewLayout.scrollDirection = .horizontal
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
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

// extension
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == curateView {
            return curations.count
        } else if collectionView == benefitView {
            return benefits.count
        } else if collectionView == provinceView {
            return provinces.count
        } else if collectionView == adView {
            return advertisements.count
        } else if collectionView == reviewView {
            return reviews.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == curateView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "curateCell", for: indexPath) as? CurateCollectionViewCell else {
                return UICollectionViewCell()
            }
            let curation = curations[indexPath.item]
            cell.curateTitle.text = curation.title
            cell.curateSubTitle.text = curation.subtitle
            cell.curateImg.load(from: curation.imageUrl)

            // 스타일 적용
            cell.curateTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
            cell.curateSubTitle.font = UIFont(name: "Pretendard-Regular", size: 16)
            cell.curateImg.layer.cornerRadius = 32
            cell.curateImg.layer.masksToBounds = true

            return cell
        }
        else if collectionView == benefitView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "benefitCell", for: indexPath) as? BenefitCollectionViewCell else {
                    return UICollectionViewCell()
                }

                // benefits 배열에서 데이터 가져오기
                let benefit = benefits[indexPath.item]
                cell.storeName.text = benefit.name
                cell.storeRate.text = String(format: "%.1f", benefit.rating)
                cell.storeProvince.text = benefit.province
                cell.storeCity.text = benefit.city
                cell.benefitImg.load(from: benefit.imageUrl) // URL에서 이미지 로드

                // 스타일 적용
                cell.storeName.font = UIFont(name: "Pretendard-SemiBold", size: 14)
                cell.storeRate.font = UIFont(name: "Pretendard-Medium", size: 12)
                cell.storeProvince.font = UIFont(name: "Pretendard-Medium", size: 12)
                cell.storeCity.font = UIFont(name: "Pretendard-Medium", size: 12)
                cell.benefitImg.layer.cornerRadius = 5
                cell.benefitImg.layer.masksToBounds = true

                return cell
        }
        else if collectionView == provinceView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "provinceCell", for: indexPath) as? ProvinceCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let province = provinces[indexPath.item]
            cell.provinceImg.load(from: province.imageUrl)
            
            cell.provinceImg.layer.cornerRadius = 19.26
            cell.provinceImg.layer.masksToBounds = true // 경계가 둥글게 잘리도록 설정

            return cell
        }
        else if collectionView == adView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath) as? AdCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let advertisement = advertisements[indexPath.item]
            cell.adTitle.text = advertisement.title
            cell.adSubTitle.text = advertisement.subtitle
            cell.adImg.load(from: advertisement.imageUrl) // URL에서 이미지 로드
            
            cell.adTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
            cell.adSubTitle.font = UIFont(name: "Pretendard-Regular", size: 16)
            
            return cell
        }
        else if collectionView == reviewView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as? ReviewCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let review = reviews[indexPath.item]
            cell.reviewImg.load(from: review.imageUrl)
            cell.userName.text = review.reviewerName
            cell.reviewStoreName.text = review.storeName
            cell.category.text = review.category
            cell.reviewRate.text = String(review.rating)
            cell.reviewCnt.text = String(format: "(%d)", review.reviewCount)
            
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
            return CGSize(width: 403, height: 204)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == curateView {
            print("curateView 셀이 선택되었습니다.") // 디버깅용 로그
            // 선택한 큐레이션의 ID 가져오기
            let selectedCuration = curations[indexPath.item]
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Storyboard 이름이 "Main"이라고 가정
            guard let detailVC = storyboard.instantiateViewController(withIdentifier: "CurateViewController") as? CurateViewController else { return }
            
            // curationId 전달
            detailVC.curationId = selectedCuration.curationId
            
            // 화면 전환 (모달 방식)
            detailVC.modalPresentationStyle = .fullScreen // 전체 화면 모달
            self.present(detailVC, animated: true, completion: nil)
        }
    }

}

extension UIImageView {
    func load(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = nil // 기본 이미지를 설정하거나 초기화
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
