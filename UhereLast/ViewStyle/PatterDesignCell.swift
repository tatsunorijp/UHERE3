//
//  PatterDesignCell.swift
//  UhereLast
//
//  Created by Wellington Tatsunori Asahide on 05/07/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class PatterDesignCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Color.tableViewBackgroundColor
        contentView.backgroundColor = Color.tableViewBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
