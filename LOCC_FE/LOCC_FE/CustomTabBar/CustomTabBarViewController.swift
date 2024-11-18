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
    }
}
