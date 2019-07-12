//
//  NavigationController.swift
//  UhereLast
//
//  Created by Wellington Tatsunori Asahide on 05/07/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        navigationBar.tintColor = Color.tintColor
        navigationBar.barTintColor = Color.mainColor
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.foregroundColor: Color.tintColor as Any]
    }

}
