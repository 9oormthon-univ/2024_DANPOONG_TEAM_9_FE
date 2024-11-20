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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
