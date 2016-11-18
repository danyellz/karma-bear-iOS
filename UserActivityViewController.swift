//
//  UserActivityViewController.swift
//  KarmaBear
//
//  Created by TY on 11/16/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit

class UserActivityViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var needsTableView: UITableView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    
    var headersArr = ["My Contributions","Upcoming Events"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        needsTableView.dataSource = self
        needsTableView.delegate = self
        needsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "needsCell")
        needsTableView.backgroundColor = UIColor.clear
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "eventsCell")
        eventsTableView.backgroundColor = UIColor.clear
        
        self.userProfile.layer.masksToBounds = true
        userProfile.layer.cornerRadius = 10
        
        setUpViews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView!.contentInset = UIEdgeInsetsMake(self.userProfile.frame.size.height-40, 0, 0, 0);
    }
    
    func setUpViews() {
        let userData = CharityModel.userData[0]
        let url = NSURL(string: userData.imageUrl)
        let thisData = NSData(contentsOf: url! as URL)
        let userImg = UIImage(data: thisData! as Data)
        
        self.userProfile.image = userImg
        
        self.pointsLabel.text = String(userData.points)
        self.userNameLabel.text = "\(userData.firstName) \(userData.lastName)"
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.headerImage.frame
        
        self.headerImage.insertSubview(blurEffectView, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.needsTableView {
            count = CharityModel.userNeeds.count
            
        }
        if tableView == self.eventsTableView {
            count = CharityModel.userEvents.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        if tableView == self.needsTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "needsCell", for: indexPath)
            let needsDetail = CharityModel.userNeeds[indexPath.row]
            cell!.textLabel!.text = needsDetail.name
        }
        
        if tableView == self.eventsTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath)
            let needsDetail = CharityModel.userEvents[indexPath.row]
            cell!.textLabel!.text = needsDetail.name
        }
        
        cell?.backgroundColor = UIColorFromHex(rgbValue: 0xF5F5F5)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.needsTableView {
            
            //TODO: Select data from user profile and EDIT/UPDATE/REVISE charity activity.
            //Add logic to save users changes to PostGres.
            
            _ = CharityModel.userNeeds[indexPath.row]
            
            //            donateToCharity(actionForNeed.id)
            //            needId = actionForNeed.id
            //            needTitle = actionForNeed.name
            //            quantityNeed = actionForNeed.quantityNeeded
            //            needStatus = actionForNeed.status
            performSegue(withIdentifier: "needModal", sender: self)
        }
        
        if tableView == self.eventsTableView {
            _ = CharityModel.userEvents[indexPath.row]
            //
            //            eventId = actionForEvent.id
            //            eventTitle = actionForEvent.name
            //            eventDescription = actionForEvent.description
            //            eventStart = actionForEvent.start
            //            eventEnd = actionForEvent.end
            
            performSegue(withIdentifier: "eventModal", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == self.needsTableView {
            title = headersArr[0]
        }
        if tableView == self.eventsTableView {
            title = headersArr[1]
        }
        return title
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

