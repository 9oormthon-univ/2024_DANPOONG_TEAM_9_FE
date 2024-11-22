//
//  MyListTableViewCell.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import UIKit

class MyListTableViewCell: UITableViewCell {
    
    // image
    @IBOutlet weak var mylistImg: UIImageView!
    
    // label
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var province: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var closeTime: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviewCnt: UILabel!
    
    // button
    @IBOutlet weak var starBtn: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
