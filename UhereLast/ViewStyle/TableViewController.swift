//
//  TableViewController.swift
//  UhereLast
//
//  Created by Wellington Tatsunori Asahide on 05/07/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = Color.tableViewBackgroundColor
        tableView.backgroundColor = Color.tableViewBackgroundColor
        tableView.keyboardDismissMode = .onDrag
    }
}
