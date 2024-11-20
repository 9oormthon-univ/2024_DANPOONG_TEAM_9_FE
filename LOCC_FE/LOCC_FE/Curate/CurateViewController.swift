//
//  CurateViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/20/24.
//

import UIKit

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
    
    // 임시 데이터 배열
    let images1 = ["test_image", "test_image", "test_image", "test_image", "test_image"]
    let images2 = ["test_image", "test_image", "test_image", "test_image", "test_image"]
    let titles = ["강원도 감자 특선 3곳", "강원도 감자 특선 3곳", "강원도 감자 특선 3곳", "강원도 감자 특선 3곳", "강원도 감자 특선 3곳"]
    let subtitles = ["강원도 감자 코스\n모든 게 감자 감자 감자", "강원도 감자 코스\n모든 게 감자 감자 감자", "강원도 감자 코스\n모든 게 감자 감자 감자", "강원도 감자 코스\n모든 게 감자 감자 감자", "강원도 감자 코스\n모든 게 감자 감자 감자"]
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        registerNib()
        
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
}

extension CurateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "curationCell", for: indexPath) as? CurationCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // 데이터 설정
        cell.curationImg1.image = UIImage(named: images1[indexPath.item])
        cell.curationImg1.layer.cornerRadius = 5
        cell.curationImg2.image = UIImage(named: images2[indexPath.item])
        cell.curationImg2.layer.cornerRadius = 5
        cell.storeName.text = titles[indexPath.item]
        cell.summary.text = subtitles[indexPath.item]
        
        cell.curateBaseView.layer.cornerRadius = 15
        cell.curateBaseView.layer.masksToBounds = false
        
        cell.category.layer.cornerRadius = 41
        cell.category.layer.borderWidth = 1
        cell.category.layer.masksToBounds = true
        cell.category.font = UIFont(name: "Pretendard-Medium", size: 12)
        
        cell.storeName.font = UIFont(name: "Pretendard-Bold", size: 18)
        
        cell.onSale.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        
        cell.closeTime.font = UIFont(name: "Pretendard-Regular", size: 10)
        
        cell.rating.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        cell.reviewCount.font = UIFont(name: "Pretendard-Regular", size: 9)
        
        cell.summary.font = UIFont(name: "Pretendard-Regular", size: 16)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 컬렉션 뷰의 높이에 따라 셀 크기 조정
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
