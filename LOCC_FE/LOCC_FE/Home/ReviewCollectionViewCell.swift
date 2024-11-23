//
//  ReviewCollectionViewCell.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/20/24.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var reviewImg: UIImageView!
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var reviewStoreName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var reviewRate: UILabel!
    @IBOutlet weak var reviewCnt: UILabel!
    
    @IBOutlet weak var reviewStarBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
