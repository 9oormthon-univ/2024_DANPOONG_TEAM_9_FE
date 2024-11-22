//
//  CurateViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/20/24.
//

import UIKit
import Alamofire

class CurateViewController: UIViewController {

    // view
    @IBOutlet weak var curationView: UICollectionView!
    
    // image
    @IBOutlet weak var curateImg: UIImageView!
    
    // label
    @IBOutlet weak var curationTitle: UILabel!
    @IBOutlet weak var curationSubTitle: UILabel!
    @IBOutlet weak var content: UILabel!
    
    // button
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    // instance
    let curationLayout = UICollectionViewFlowLayout()
    var curationId: Int?
    private var stores: [CurationStore] = [] // 서버에서 가져올 가게 데이터 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        registerNib()
        fetchCurationDetail()
        
        self.curationView.delegate = self
        self.curationView.dataSource = self
    }
    
    private func setupUI() {
        curationTitle.font = UIFont(name: "Pretendard-Bold", size: 28)
        curationSubTitle.font = UIFont(name: "Pretendard-Regular", size: 18)
        content.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    private func setupLayout() {
        curationLayout.scrollDirection = .vertical
        curationView.collectionViewLayout = curationLayout
    }
    
    private func registerNib() {
        let curationNib = UINib(nibName: "CurationCollectionViewCell", bundle: nil)
        curationView.register(curationNib, forCellWithReuseIdentifier: "curationCell")
    }
    
    private func fetchCurationDetail() {
        guard let curationId = curationId else { return }
        
        // UserDefaults에서 서버 AccessToken 가져오기
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Error: No access token found.")
            return
        }
        
        // API 엔드포인트 설정
        let endpoint = "/api/v1/curations/\(curationId)"
        
        // GET 요청 호출
        APIClient.getRequest(endpoint: endpoint, parameters: nil, token: token, headerType: .authorization) { (result: Result<CurationDetailResponse, AFError>) in
            switch result {
            case .success(let response):
                let curationInfo = response.data.curationInfo
                self.stores = response.data.stores
                
                DispatchQueue.main.async {
                    // UI 업데이트
                    self.curationTitle.text = curationInfo.title
                    self.curationSubTitle.text = curationInfo.subtitle
                    self.curateImg.load(from: curationInfo.imageUrl)
                    self.curationView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching curation detail: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func toggleBookmark(for storeId: Int, at indexPath: IndexPath) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Error: No access token found.")
            return
        }

        // API 엔드포인트 설정
        let endpoint = "/api/v1/curations/\(storeId)/bookmark/toggle"

        // PUT 요청 호출
        APIClient.putRequest(endpoint: endpoint, token: token, headerType: .authorization) { (result: Result<BookmarkToggleResponse, AFError>) in
            switch result {
            case .success(let response):
                // 응답 데이터 처리
                let isBookmarked = response.data.bookmarked
                print("Bookmark toggled successfully: \(isBookmarked)")

                // 데이터 업데이트
                DispatchQueue.main.async {
                    // 상태 업데이트 및 즉시 UI 반영
                    self.stores[indexPath.row].isBookmarked = isBookmarked

                    if let cell = self.curationView.cellForItem(at: indexPath) as? CurationCollectionViewCell {
                        cell.bookmarkBtn.isSelected = isBookmarked
                        cell.bookmarkBtn.setImage(
                            UIImage(named: isBookmarked ? "icon_scrap" : "icon_scrap_unselected"),
                            for: .normal
                        )
                    }
                }
            case .failure(let error):
                // 에러 디버깅
                print("Error toggling bookmark: \(error.localizedDescription)")
            }
        }
    }
}

extension CurateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stores.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "curationCell", for: indexPath) as? CurationCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let store = stores[indexPath.item]
        
        // 데이터 설정
        cell.curationImg1.load(from: store.storeInfo.imageUrl)
        cell.storeName.text = store.storeInfo.name
        cell.summary.text = store.summary
        cell.category.text = store.storeInfo.category
        cell.rating.text = "\(store.storeInfo.rating)"
        cell.reviewCount.text = "(\(store.storeInfo.reviewCount))"
        cell.onSale.text = store.storeInfo.businessStatus
        cell.closeTime.text = store.storeInfo.closeTime ?? "N/A"
        
        // 북마크 버튼 상태 설정
        cell.bookmarkBtn.isSelected = store.isBookmarked
        cell.bookmarkBtn.setImage(UIImage(named: "icon_scrap"), for: .selected) // 북마크된 상태 이미지
        cell.bookmarkBtn.setImage(UIImage(named: "icon_scrap_unselected"), for: .normal)    // 북마크되지 않은 상태 이미지
        
        cell.toggleBookmark = { [weak self] in
        guard let self = self else { return }
        print("Toggling bookmark for Store ID: \(store.storeInfo.storeId)")

        // API 호출 및 상태 업데이트
        self.toggleBookmark(for: store.storeInfo.storeId, at: indexPath)
    }
        
        // UI 스타일 설정
        cell.category.layer.cornerRadius = 9
        cell.category.layer.borderWidth = 1
        cell.category.layer.borderColor = UIColor.category.cgColor
        cell.category.layer.masksToBounds = true
        cell.category.font = UIFont(name: "Pretendard-Medium", size: 12)
        
        cell.bookmarkBtn.setImage(UIImage(named: "icon_scrape"), for: .selected)
        cell.bookmarkBtn.setImage(UIImage(named: "icon_scrap_unselected"), for: .normal)
        
        cell.storeName.font = UIFont(name: "Pretendard-Bold", size: 18)
        cell.onSale.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        cell.closeTime.font = UIFont(name: "Pretendard-Regular", size: 10)
        cell.rating.font = UIFont(name: "Pretendard-Regular", size: 12)
        cell.reviewCount.font = UIFont(name: "Pretendard-Regular", size: 9)
        cell.summary.font = UIFont(name: "Pretendard-Regular", size: 16)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight = collectionView.bounds.height
        let cellHeight = (collectionViewHeight - (20 * 6)) / 5 // 20은 셀 간격
        return CGSize(width: collectionView.bounds.width - 40, height: cellHeight) // 40은 좌우 여백
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
