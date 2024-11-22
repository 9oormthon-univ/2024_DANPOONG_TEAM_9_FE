//
//  CurationPageViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import UIKit

class CurationPageViewController: UIViewController {

    // MARK: - Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // 세로 스크롤
        layout.minimumLineSpacing = 20 // 행 간 간격
        layout.minimumInteritemSpacing = 10 // 열 간 간격
        layout.sectionInset = UIEdgeInsets(top: 25.25, left: 20, bottom: 20, right: 20) // 섹션 내부 여백
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let curationData = ["낙엽도 맛집이\n있나요 TOP5", "낙엽도 맛집이\n있나요 TOP5", "낙엽도 맛집이\n있나요 TOP53", "낙엽도 맛집이\n있나요 TOP5", "낙엽도 맛집이\n있나요 TOP5"] // 임시 데이터
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        registerNib()
        setupCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func registerNib() {
        let bookmarkNib = UINib(nibName: "BookmarkCollectionViewCell", bundle: nil)
        collectionView.register(bookmarkNib, forCellWithReuseIdentifier: "bookmarkCell")
    }
    
    private func setupCollectionView() {
        // 컬렉션 뷰 추가
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = .white
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CurationPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curationData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCell", for: indexPath) as? BookmarkCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // 데이터 설정
        cell.curationTitle.text = curationData[indexPath.item]
        cell.curationImg.image = UIImage(named: "test_image") // 임시 이미지 설정
        
        cell.bookmarkBtn.isSelected = false // 기본 버튼 상태
        cell.bookmarkBtn.addTarget(self, action: #selector(bookmarkTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func bookmarkTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        // 북마크 로직 추가
        print("Bookmark button tapped, isSelected: \(sender.isSelected)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 컬렉션 뷰에서 셀 너비 계산
        let totalHorizontalSpacing = CGFloat(20 * 2) + 15 // 좌우 여백 (20 * 2) + 열 간격 (15)
        let cellWidth = (collectionView.bounds.width - totalHorizontalSpacing) / 2 // 셀 너비 (2열 기준)
        let cellHeight: CGFloat = 197.72 // 셀 높이
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13.72 // 행 간 간격
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15 // 열 간 간격
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // 컬렉션 뷰 전체 여백
    }

}
