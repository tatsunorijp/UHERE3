//
//  TabBarControllerSwift.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 30/01/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class TabBarControllerSwift: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = Controller.mainColor
        UITabBar.appearance().tintColor = .white
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
