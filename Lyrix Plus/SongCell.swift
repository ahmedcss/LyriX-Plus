//
//  SongCell.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 4/18/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit

class SongCell:UITableViewCell{

    
    @IBOutlet weak var Button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(true, animated: true)
    }
}
