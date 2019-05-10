//
//  FaltasCell.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 30/04/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class FaltasCell: UITableViewCell {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbHora: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
