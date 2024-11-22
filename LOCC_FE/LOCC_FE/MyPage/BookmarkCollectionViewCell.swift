//
//  BookmarkCollectionViewCell.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    
    // image
    @IBOutlet weak var curationImg: UIImageView!
    
    // label
    @IBOutlet weak var curationTitle: UILabel!
    
    // button
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Cell에 cornerRadius 적용
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
    
    // action
    @IBAction func bookmarkTapped(_ sender: Any) {
        if bookmarkBtn.isSelected {
            bookmarkBtn.isSelected = true
        }
        else {
            bookmarkBtn.isSelected = false
        }
    }

}
