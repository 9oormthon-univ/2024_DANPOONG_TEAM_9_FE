//
//  CurationCollectionViewCell.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/20/24.
//

import UIKit

class CurationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var curateBaseView: UIView!
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var onSale: UILabel!
    @IBOutlet weak var closeTime: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var quoteBtn: UIButton!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    @IBOutlet weak var curationImg1: UIImageView!
    @IBOutlet weak var curationImg2: UIImageView!
    
    var toggleBookmark: (() -> Void)? // 북마크 상태를 토글하는 클로저
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        curateBaseView.layer.cornerRadius = 15
        curateBaseView.layer.borderWidth = 1
        curateBaseView.layer.borderColor = UIColor.line2.cgColor
        curateBaseView.layer.masksToBounds = true
        
        category.layer.cornerRadius = 9
        category.layer.borderWidth = 1
        category.layer.borderColor = UIColor.category.cgColor
        
        curationImg1.layer.cornerRadius = 5
        curationImg1.clipsToBounds = true
        curationImg2.layer.cornerRadius = 5
        curationImg2.clipsToBounds = true
    }
    
    func configureSummaryText(_ text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = summary.font.lineHeight * 0.5 // 행간 간격을 150%로 설정

        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: summary.font ?? UIFont(name: "Pretendard-Regular", size: 16) ?? "설명 없음",
                .foregroundColor: summary.textColor ?? UIColor.black
            ]
        )
        summary.attributedText = attributedString
    }

    @IBAction func bookmarkTapped(_ sender: Any) {
        toggleBookmark?() // 북마크 상태를 부모에게 알림
    }
}
