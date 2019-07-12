//
//  SelecionaDiasCell.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 03/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class SelecionaDiasCell: UITableViewCell {
    
    @IBOutlet weak var lbDia: UILabel!
    @IBOutlet weak var tfHora: DateTextField!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = Color.mainColor
        tfHora.setConfig(format: Constants.timeFormat, mode: .time)
    }
    
}
