//
//  AlertView.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import UIKit

class AlertView: UIView {
    class func instanceFromNib() -> UIView {
    return UINib(nibName: "AlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
