//
//  PhotoCollectionViewCell.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/23/24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    // image
    @IBOutlet weak var photoImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}
