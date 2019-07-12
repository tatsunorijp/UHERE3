//
//  TableView.swift
//  UhereLast
//
//  Created by Wellington Tatsunori Asahide on 05/07/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class TableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorColor = Color.tableViewBackgroundColor
        backgroundColor = Color.tableViewBackgroundColor
        keyboardDismissMode = .onDrag
    }
}
