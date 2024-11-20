//
//  BenefitCollectionViewCell.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/20/24.
//

import UIKit

class BenefitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var benefitImg: UIImageView!
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeCity: UILabel!
    @IBOutlet weak var storeRate: UILabel!
    
    @IBOutlet weak var starBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
