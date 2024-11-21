//
//  DetailViewController.swift
//  LOCC_FE
//
//  Created by 우은진 on 11/22/24.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // 기본 배경색 설정
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "Detail Page"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
