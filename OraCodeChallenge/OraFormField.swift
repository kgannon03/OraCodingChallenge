//
//  OraFormField.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit

@IBDesignable
class OraFormField: UITextField {
    
    @IBInspectable var dividerColor: UIColor =
        UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 35)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return super.clearButtonRect(forBounds: bounds).offsetBy(dx: -8.0, dy: 0)
    }

    override func draw(_ rect: CGRect) {
        let bottom = CGRect(x: 0, y: rect.size.height - 1.0, width: rect.size.width, height: 1.0)
        dividerColor.setFill()
        UIRectFill( bottom )
    }
}
