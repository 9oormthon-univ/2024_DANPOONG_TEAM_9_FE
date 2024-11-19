//
//  SearchViewController.swift
//  LOCC_FE
//
//  Created by 우은진 on 11/19/24.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // 배경색 설정
        view.backgroundColor = .white

        // Label 생성 및 설정
        let label = UILabel()
        label.text = "Hello, this is search page!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        // Label 추가 및 레이아웃 설정
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
