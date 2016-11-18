//
//  CustomCalloutView.swift
//  KarmaBear
//
//  Created by TY on 11/16/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit

class CustomCalloutView: UIView {
    
    @IBOutlet var charityImage: UIImageView!
    @IBOutlet var charityName: UILabel!
    @IBOutlet var charityAddress: UILabel!
    @IBOutlet var charityPhone: UILabel!
}

//CUSTOM CALLOUT IMPLEMENTATION


//            let charityAnnotation = view.annotation as! CharityAnnotation
//            let views = NSBundle.mainBundle().loadNibNamed("CustomCalloutView", owner: nil, options: nil)
//            let calloutView = views?[0] as! CustomCalloutView
//            calloutView.charityName.text = charityAnnotation.title
//            calloutView.charityAddress.text = charityAnnotation.address
//            calloutView.charityPhone.text = charityAnnotation.phone
//            print(calloutView.charityPhone.text)
//
//            let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("CallPhoneNumber:")))
//            calloutView.charityPhone.addGestureRecognizer(tapGesture)
//            calloutView.charityPhone.userInteractionEnabled = true
//            calloutView.charityImage.image = charityAnnotation.image
//            // 3
//            calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
//            view.addSubview(calloutView)
//            mapView.setCenterCoordinate((view.annotation?.coordinate)!, animated: true)s
