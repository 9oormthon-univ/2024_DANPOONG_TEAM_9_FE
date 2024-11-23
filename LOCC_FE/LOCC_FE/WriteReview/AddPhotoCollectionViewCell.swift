//
//  AddPhotoCollectionViewCell.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/23/24.
//

import UIKit

class AddPhotoCollectionViewCell: UICollectionViewCell {

    // button
    @IBOutlet weak var cameraBtn: UIButton!
    
    // label
    @IBOutlet weak var uploadLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.camera2.cgColor
        clipsToBounds = true
    }

}
