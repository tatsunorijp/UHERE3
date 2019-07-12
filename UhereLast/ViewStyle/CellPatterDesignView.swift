//
//  DesignCellMateria.swift
//  UHere_Prototype
//
//  Created by Wellington Tatsunori Asahide on 15/11/18.
//  Copyright © 2018 tatsu. All rights reserved.
//

import UIKit

import UIKit

@IBDesignable class CellPatterDesignView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 3
    @IBInspectable var shadowColor: UIColor = UIColor.black
    @IBInspectable let shadowOffSetWidth: Int = 1
    @IBInspectable let shadowOffSetHeight: Int = 1
    
    @IBInspectable var shadowOpacity: Float = 0.3
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
    }
    
}
