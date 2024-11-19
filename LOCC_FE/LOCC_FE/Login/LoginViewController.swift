//
//  LoginViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    // button
    @IBOutlet weak var logo: UIButton!
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    
    // label
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        let introduceText = "로컬 크리에이터들을\n한 손에서 발견!"
        let attributedString = NSMutableAttributedString(string: introduceText)

        // 특정 범위의 텍스트에 글꼴을 변경
        let range = (introduceText as NSString).range(of: "로컬 크리에이터")
        let customFont = UIFont(name: "Pretendard-Bold", size: 21) ?? UIFont.systemFont(ofSize: 21) // 원하는 글꼴 및 크기 설정
        attributedString.addAttribute(.font, value: customFont, range: range)

        introduceLabel.attributedText = attributedString
    }

}
