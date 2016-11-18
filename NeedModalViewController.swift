//
//  NeedModalViewController.swift
//  KarmaBear
//
//  Created by TY on 11/16/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit

class NeedModalViewController: UIViewController {
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var quantityInput: UITextField!
    @IBOutlet weak var needsList: UILabel!
    @IBOutlet weak var needNumber: UILabel!
    @IBOutlet weak var donateLabel: UILabel!
    
    var needId: Int!
    var needTitle: String!
    var quantityNeed: Int!
    var status: String!
    var httpHelper = HTTPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        needsList.text = needTitle
        needNumber.text = String(quantityNeed)
        modalView.layer.cornerRadius = 10
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    @IBAction func dismissModal(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func giveToCharity(sender: AnyObject) {
        donateToCharity(needId: needId)
        self.dismiss(animated: true, completion: nil)
    }
    
    func donateToCharity(needId: Int) {
        let httpRequest = httpHelper.buildRequest(path: "auth/donate", method: "POST")
        let currentUserToken = UserDefaults.standard.string(forKey: "FBToken")
        let userToken = currentUserToken! as String
        let quantity = quantityInput.text!
        
        httpRequest.httpBody = "{\"id\":\"\(needId)\",\"token\":\"\(userToken)\",\"quantity\":\"\(quantity)\"}".data(using: String.Encoding.utf8)
        
        httpHelper.sendRequest(request: httpRequest, completion: {(data, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            do {
                //                let responseDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                //                print(responseDict)
            } catch let error as NSError {
                print(error)
            }
        })
    }
}

