//
//  DataTextField.swift
//  UhereLast
//
//  Created by Wellington Tatsunori Asahide on 28/06/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import UIKit

class DateTextField: UITextField {
    private let dateFormatter = DateFormatter()
    private let datePicker = UIDatePicker()

    var date: Date {
        get {
            if let dateString = text {
                return dateFormatter.date(from: dateString)!
            }
            return Date()
        }
        
        set {
            text = dateFormatter.string(from: newValue)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setConfig(format dateFormat: String, mode dateMode: UIDatePicker.Mode) {
        datePicker.datePickerMode = dateMode
        inputView = datePicker
        dateFormatter.dateFormat = dateFormat
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc func dateChanged(_: UIDatePicker) {
        text = dateFormatter.string(from: datePicker.date)
    }
    

}
