//
//  EventModalViewController.swift
//  KarmaBear
//
//  Created by TY on 11/16/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit

class EventModalViewController: UIViewController {
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    var eventId: Int!
    var eventTitle: String!
    var eventDescription: String!
    var eventStart: String!
    var eventEnd: String!
    var httpHelper = HTTPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalView.layer.cornerRadius = 10
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, at: 0)
        
        setupView()
    }
    
    func setupView() {
        descriptionText.text = eventDescription
        startLabel.text = eventStart
        endLabel.text = eventEnd
        descriptionText.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionText.numberOfLines = 0
    }
    
    @IBAction func dismissModal(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerToThisEvent(sender: AnyObject) {
        registerForEvent(eventId: eventId)
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerForEvent(eventId: Int) {
        
        let httpRequest = httpHelper.buildRequest(path: "auth/register", method: "POST")
        let currentUserToken = UserDefaults.standard.string(forKey: "FBToken")
        let userToken = currentUserToken! as String
        
        httpRequest.httpBody = "{\"id\":\"\(eventId)\",\"token\":\"\(userToken)\"}".data(using: String.Encoding.utf8)
        
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

