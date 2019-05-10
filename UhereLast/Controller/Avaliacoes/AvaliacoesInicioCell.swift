//
//  AvaliacoesInicioTableViewCell.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 10/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class AvaliacoesInicioCell: UITableViewCell {

    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var lbData: UILabel!
    @IBOutlet weak var lbNota: UILabel!
    @IBOutlet weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
