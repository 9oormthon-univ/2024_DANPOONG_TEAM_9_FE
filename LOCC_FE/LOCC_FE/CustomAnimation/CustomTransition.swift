//
//  CustomTransition.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import Foundation
import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // 애니메이션 시간 설정
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    // 애니메이션 내용 설정
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else { return }

        // 시작 위치 설정 (오른쪽에서 시작)
        let containerView = transitionContext.containerView
        let screenWidth = containerView.bounds.width
        let screenHeight = containerView.bounds.height
        toVC.view.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)

        containerView.addSubview(toVC.view)

        // 애니메이션 설정 (오른쪽에서 왼쪽으로 슬라이드)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = CGRect(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
            toVC.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}
