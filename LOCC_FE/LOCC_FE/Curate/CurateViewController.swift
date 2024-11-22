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
    private var stores: [CurationStore] = []

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
        curationSubTitle.lineBreakMode = .byWordWrapping
        curationSubTitle.numberOfLines = 2
        content.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    private func splitSubtitleIntoTwoLines(_ subtitle: String) -> String {
        let words = subtitle.split(separator: " ")
        let midpoint = words.count / 2
        
        guard midpoint > 0 else { return subtitle }
        
        let firstLine = words.prefix(midpoint).joined(separator: " ")
        let secondLine = words.suffix(from: midpoint).joined(separator: " ")
        
        return "\(firstLine)\n\(secondLine)"
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
        guard let curationId = curationId else {
            print("Error: curationId is nil")
            return
        }

        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Error: No access token found.")
            return
        }

        let endpoint = "/api/v1/curations/\(curationId)"

        APIClient.getRequest(endpoint: endpoint, parameters: nil, token: token, headerType: .authorization) { (result: Result<CurationDetailResponse, AFError>) in
            switch result {
            case .success(let response):
                print("API Success: \(response)")

                let curationInfo = response.data.curationInfo
                self.stores = response.data.stores
                let isBookmarked = response.data.bookmarked // bookmarked 상태 가져오기

                DispatchQueue.main.async {
                    self.curationTitle.text = curationInfo.title

                    let formattedSubtitle = self.splitSubtitleIntoTwoLines(curationInfo.subtitle)
                    self.curationSubTitle.text = formattedSubtitle

                    self.curateImg.load(from: curationInfo.imageUrl)
                    self.curationView.reloadData()

                    // 북마크 버튼 상태 업데이트
                    self.bookmarkBtn.isSelected = isBookmarked
                    let bookmarkImage = isBookmarked ? "icon_scrap" : "icon_scrap_unselected"
                    self.bookmarkBtn.setImage(UIImage(named: bookmarkImage), for: .normal)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching curation detail: \(error.localizedDescription)")
                }
            }
        }
    }

    private func toggleStoreBookmark(for storeId: Int, at indexPath: IndexPath) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Error: No access token found.")
            return
        }

        // API 엔드포인트 설정
        let endpoint = "/api/v1/stores/\(storeId)/bookmark/toggle"

        // PUT 요청 호출
        APIClient.putRequest(endpoint: endpoint, token: token, headerType: .authorization) { (result: Result<BookmarkToggleResponse, AFError>) in
            switch result {
            case .success(let response):
                let isBookmarked = response.data.bookmarked
                print("Bookmark toggled successfully: \(isBookmarked)")

                DispatchQueue.main.async {
                    self.stores[indexPath.row].bookmarked = isBookmarked

                    // 셀을 업데이트
                    if let cell = self.curationView.cellForItem(at: indexPath) as? CurationCollectionViewCell {
                        cell.bookmarkBtn.isSelected = isBookmarked
                        let newImageName = isBookmarked ? "icon_scrap" : "icon_scrap_unselected"
                        cell.bookmarkBtn.setImage(UIImage(named: newImageName), for: .normal)
                        print("Bookmark button updated with image: \(newImageName)")
                    }
                }
            case .failure(let error):
                print("Error toggling bookmark: \(error.localizedDescription)")
            }
        }
    }
    
    private func toggleCurationBookmark() {
        guard let curationId = curationId else {
            print("Error: curationId is nil")
            return
        }

        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Error: No access token found.")
            return
        }

        let endpoint = "/api/v1/curations/\(curationId)/bookmark/toggle"

        // PUT 요청 호출
        APIClient.putRequest(endpoint: endpoint, token: token, headerType: .authorization) { (result: Result<BookmarkToggleResponse, AFError>) in
            switch result {
            case .success(let response):
                let isBookmarked = response.data.bookmarked
                print("Curation bookmark toggled successfully: \(isBookmarked)")

                DispatchQueue.main.async {
                    // 북마크 버튼 상태 업데이트
                    self.bookmarkBtn.isSelected = isBookmarked
                    let bookmarkImage = isBookmarked ? "icon_scrap" : "icon_scrap_unselected"
                    self.bookmarkBtn.setImage(UIImage(named: bookmarkImage), for: .normal)
                }
            case .failure(let error):
                print("Error toggling curation bookmark: \(error.localizedDescription)")
            }
        }
    }
    
    // action
    @IBAction func tapBack(_ sender: Any) {
        guard let toHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as? CustomTabBarViewController else { return }
            
        toHomeVC.modalPresentationStyle = .fullScreen
        
        // 전환 애니메이션 설정
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(toHomeVC, animated: false, completion: nil)
    }
    
    @IBAction func tapBookmarkBtn(_ sender: Any) {
        toggleCurationBookmark()
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

        let images = store.storeInfo.images
        let firstImage = images.first ?? ""
        let secondImage = images.count > 1 ? images[1] : ""

        cell.curationImg1.load(from: firstImage)
        cell.curationImg2.load(from: secondImage)

        cell.storeName.text = store.storeInfo.name
        cell.category.text = store.storeInfo.category
        cell.rating.text = "\(store.storeInfo.rating)"
        cell.reviewCount.text = "(\(store.storeInfo.reviewCount))"
        cell.onSale.text = store.storeInfo.businessStatus
        cell.closeTime.text = store.storeInfo.closeTime ?? "N/A"

        cell.configureSummaryText(store.summary ?? "설명 없음")
        cell.summary.font = UIFont(name: "Pretendard-Regular", size: 16)

        cell.bookmarkBtn.isSelected = store.bookmarked
        if store.bookmarked {
            cell.bookmarkBtn.setImage(UIImage(named: "icon_scrap"), for: .normal)
        } else {
            cell.bookmarkBtn.setImage(UIImage(named: "icon_scrap_unselected"), for: .normal)
        }

        cell.toggleBookmark = { [weak self] in
            guard let self = self else { return }
            self.toggleStoreBookmark(for: store.storeInfo.storeId, at: indexPath)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight = collectionView.bounds.height
        let cellHeight = (collectionViewHeight - (20 * 6)) / 5
        return CGSize(width: collectionView.bounds.width - 40, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
