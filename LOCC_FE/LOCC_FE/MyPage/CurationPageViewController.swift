//
//  CurationPageViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import UIKit
import Alamofire

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
    
    private var bookmarkedCurations: [Curation] = [] // 북마크된 큐레이션 데이터
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        registerNib()
        setupCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchBookmarkedCurations()
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
    
    private func fetchBookmarkedCurations() {
        // API 요청으로 데이터 가져오기
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Error: No access token found.")
            return
        }

        let endpoint = "/api/v1/users/me/profile"

        APIClient.getRequest(endpoint: endpoint, parameters: nil, token: token, headerType: .authorization) { (result: Result<MyPageResponse, AFError>) in
            switch result {
            case .success(let response):
                if let curations = response.data?.savedCurations {
                    self.bookmarkedCurations = curations
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching bookmarked curations: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CurationPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkedCurations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCell", for: indexPath) as? BookmarkCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let curation = bookmarkedCurations[indexPath.item]
        
        // 데이터 설정
        cell.curationTitle.text = curation.title
        cell.curationImg.load(from: curation.imageUrl) // 이미지 로드 메서드 사용
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalSpacing = CGFloat(20 * 2) + 15 // 좌우 여백 (20 * 2) + 열 간격 (15)
        let cellWidth = (collectionView.bounds.width - totalHorizontalSpacing) / 2 // 셀 너비 (2열 기준)
        let cellHeight: CGFloat = 197.72 // 셀 높이
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13.72 // 행 간 간격
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // 컬렉션 뷰 전체 여백
    }
}
