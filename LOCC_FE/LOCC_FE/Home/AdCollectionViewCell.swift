//
//  AdCollectionViewCell.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/20/24.
//

import UIKit

class AdCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var adImg: UIImageView!
    
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
