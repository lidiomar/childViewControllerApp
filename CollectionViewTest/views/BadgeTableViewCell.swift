//
//  BadgeTableViewCell.swift
//  AmeDigital
//
//  Created by Lidiomar Fernando dos Santos Machado on 01/07/21.
//  Copyright © 2021 B2W Digital. All rights reserved.
//

import UIKit

class BadgeTableViewCell: UITableViewCell {

    @IBOutlet weak var badgeIndicatorView: BadgeIndicatorView!
    @IBOutlet weak var badgeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
