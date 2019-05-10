//
//  ModelClass.swift
//  UHere-2
//
//  Created by Wellington Tatsunori Asahide on 13/03/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import Foundation
import UIKit

class ModelClass{
    
    static func alertaSimNao(titulo: String, menssagem: String) -> UIAlertController{
        let alert = UIAlertController(title: titulo, message: menssagem, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))

        return alert
    }
}
