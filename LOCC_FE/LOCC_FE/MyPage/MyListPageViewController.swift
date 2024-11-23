//
//  MyListPageViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import UIKit
import Alamofire

class MyListPageViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView()
    private var bookmarkedStores: [Store] = [] // 북마크된 가게 데이터

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.buttonBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        registerNib()
        setupTableView()
        
        fetchBookmarkedStores()
    }

    private func registerNib() {
        let mylistNib = UINib(nibName: "MyListTableViewCell", bundle: nil)
        tableView.register(mylistNib, forCellReuseIdentifier: "mylistCell")
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.rowHeight = 137.98 // 행 높이 설정
        tableView.separatorStyle = .singleLine // 구분선 스타일
        tableView.backgroundColor = UIColor.buttonBackground
    }
    
    private func fetchBookmarkedStores() {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Error: No access token found.")
            return
        }

        let endpoint = "/api/v1/users/me/profile"

        APIClient.getRequest(endpoint: endpoint, parameters: nil, token: token, headerType: .authorization) { (result: Result<MyPageResponse, AFError>) in
            switch result {
            case .success(let response):
                if let stores = response.data?.savedStores {
                    self.bookmarkedStores = stores
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching bookmarked stores: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyListPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedStores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mylistCell", for: indexPath) as? MyListTableViewCell else {
            return UITableViewCell()
        }
        
        let store = bookmarkedStores[indexPath.row]
        
        // 데이터 설정
        cell.storeName.text = store.name
        cell.category.text = store.category
        cell.province.text = store.province
        cell.city.text = store.city
        cell.status.text = store.businessStatus
        cell.closeTime.text = store.closeTime
        cell.rating.text = "\(store.rating)"
        cell.reviewCnt.text = "(\(store.reviewCount))"
        cell.mylistImg.load(from: store.imageUrl) // 이미지 로드 메서드 사용
        
        // closeTime 설정
        if let closeTime = store.closeTime, !closeTime.isEmpty {
            cell.closeTime.text = "오후 \(closeTime)에 영업종료"
        } else {
            cell.closeTime.text = "" // null일 경우 출력하지 않음
        }
        
        return cell
    }
}
