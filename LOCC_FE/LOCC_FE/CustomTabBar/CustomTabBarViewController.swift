//
//  CustomTabBarViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import UIKit

class CustomTabBar: UITabBar {
    let customHeight: CGFloat = 98
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }
}

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setCustomTabBar()
        setItemImageTint()
        setTitleFont()
        setBackground()
        
        // 스크롤뷰가 탭바를 가리지 않도록 탭바의 위치 고정
        tabBar.frame = CGRect(x: 0, y: view.bounds.height - tabBar.frame.height, width: view.bounds.width, height: tabBar.frame.height)
    }

    private func setCustomTabBar() {
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
    }
    
    private func setItemImageTint() {
        tabBar.unselectedItemTintColor = UIColor.tabBarItemTitle
        tabBar.tintColor = UIColor.selectedGreen
    }
    
    private func setTitleFont() {
        if let font = UIFont(name: "Pretendard-Medium", size: 10) {
            let attributes = [NSAttributedString.Key.font: font]
            UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        }
    }
    
    private func setBackground() {
        tabBar.backgroundColor = UIColor.buttonBackground
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.line2.cgColor
    }
}
