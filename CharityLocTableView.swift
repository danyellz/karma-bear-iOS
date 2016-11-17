
//
//  CharityLocTableView.swift
//  KarmaBear
//
//  Created by TY on 11/16/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit
class CharityLocTableView: UITableView, UITableViewDelegate {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (point.y<0)
        {
            return hitView
        }
        return hitView
    }
}
