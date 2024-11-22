//
//  MyListPageViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import UIKit

class MyListPageViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView()
    private let myListData = [
        ["storeName": "로슈아커피", "category": "카페", "province": "서울", "city": "강남구", "status": "영업중", "closeTime": "10:00", "rating": "4.5", "reviewCnt": "120"],
        ["storeName": "로슈아커피", "category": "카페", "province": "경기", "city": "성남시", "status": "영업중", "closeTime": "8:00", "rating": "4.7", "reviewCnt": "80"],
        ["storeName": "로슈아커피", "category": "카페", "province": "부산", "city": "해운대구", "status": "영업중", "closeTime": "11:00", "rating": "4.8", "reviewCnt": "200"]
    ] // 임시 데이터

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.buttonBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        registerNib()
        
        setupTableView()
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
        
        tableView.rowHeight = 137.98 // 행 높이 설정
        tableView.separatorStyle = .singleLine // 구분선 스타일
        tableView.backgroundColor = UIColor.buttonBackground
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyListPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myListData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mylistCell", for: indexPath) as? MyListTableViewCell else {
            return UITableViewCell()
        }
        
        let data = myListData[indexPath.row]
        
        // 데이터 설정
        cell.storeName.text = data["storeName"]
        cell.category.text = data["category"]
        cell.province.text = data["province"]
        cell.city.text = data["city"]
        cell.status.text = data["status"]
        cell.closeTime.text = data["closeTime"]
        cell.rating.text = data["rating"]
        cell.reviewCnt.text = "(\(data["reviewCnt"] ?? "0"))"
        
        // 이미지 설정 (임시 이미지)
        cell.mylistImg.image = UIImage(named: "test_image")
        cell.mylistImg.layer.cornerRadius = 15
        cell.mylistImg.layer.masksToBounds = true
        
        cell.selectionStyle = .none
        
        return cell
    }
}
