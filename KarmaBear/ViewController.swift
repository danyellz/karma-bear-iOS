//
//  ViewController.swift
//  Selfie
//
//  Created by Behera, Subhransu on 29/8/14.
//  Copyright (c) 2014 subhb.org. All rights reserved.
//

import UIKit
import MapKit
import Foundation

var tableView: UITableView!

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
  @IBOutlet weak var signinBackgroundView: UIView!
  @IBOutlet weak var signupBackgroundView: UIView!
  @IBOutlet weak var signinEmailTextField: UITextField!
  @IBOutlet weak var signinPasswordTextField: UITextField!
  @IBOutlet weak var signupNameTextField: UITextField!
  @IBOutlet weak var signupEmailTextField: UITextField!
  @IBOutlet weak var signupPasswordTextField: UITextField!
  @IBOutlet weak var activityIndicatorView: UIView!
  @IBOutlet weak var passwordRevealBtn: UIButton!
  @IBOutlet weak var tableView: CharityLocTableView!
    @IBOutlet weak var charityCellImageView: UIImageView!
    
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var userNavBtn: UIButton!
    
  
  let cllocationManager: CLLocationManager = CLLocationManager()
//  let transitionManager = TransitionManager()
    
  var httpHelper = HTTPHelper()
  var LocArr: NSMutableArray = NSMutableArray()
  var charityId: Int?
  var passImageUrl: String!
  var descString: String!
  var charitySearchCount = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    self.tableView.backgroundColor = UIColor.clear
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    self.cllocationManager.requestAlwaysAuthorization()
    self.cllocationManager.requestWhenInUseAuthorization()
    
    let userLocation = mapView.userLocation
    
    cllocationManager.startUpdatingLocation()
    mapView.showsUserLocation = true
    mapView.delegate = self
    
    let userImg = UIImage(named: "UserIcon")
    userNavBtn.setImage(userImg, for: .normal)
    
    if UserDefaults.standard.string(forKey: "FBToken") == nil {
        performSegue(withIdentifier: "authFailure", sender: self)
    }
    
    if UserDefaults.standard.string(forKey: "FBToken") != nil {
        
        let activityView = UIView.init(frame: view.frame)
        activityView.backgroundColor = UIColor.gray
        activityView.alpha = 1
        view.addSubview(activityView)
        
        let activitySpinner = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activitySpinner.center = view.center
        activitySpinner.startAnimating()
        activityView.addSubview(activitySpinner)

        getUserData()
        
        activitySpinner.stopAnimating()
        activityView.removeFromSuperview()
        
        showAlert(alertTitle: "Wecome to KarmaBear", alertMessage: "Start giving by adding a destination", actionTitle: "Ok")
    }
    
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView!.contentInset = UIEdgeInsetsMake(self.mapView.frame.size.height-40, 0, 0, 0);
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation
        userLocation: MKUserLocation) {

        mapView.centerCoordinate = userLocation.location!.coordinate
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 50000, 50000)
    
        mapView.setRegion(region, animated: true)
    } 
    
    func getUserData() {
        
        let activityView = UIView.init(frame: view.frame)
        activityView.backgroundColor = UIColor.gray
        activityView.alpha = 1
        view.addSubview(activityView)
        
        let activitySpinner = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activitySpinner.center = view.center
        activitySpinner.startAnimating()
        activityView.addSubview(activitySpinner)
            
            print("Creating User Data...")
            
            let currentUserToken = UserDefaults.standard.string(forKey: "FBToken")
            let userToken = currentUserToken! as String
            
            let httpRequest = httpHelper.buildRequest(path: "auth/giver", method: "POST")
            httpRequest.httpBody = "{\"token\":\"\(userToken)\"}".data(using: String.Encoding.utf8)
            
            httpHelper.sendRequest(request: httpRequest, completion: {(data: NSData!, error: NSError!) in
                
                guard error == nil else {
                    print(error)
                    return
                }
                do {
                    
                    if !CharityModel.userData.isEmpty {
                        CharityModel.userData.removeAll()
                    }
                    
                    let responseDict = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if let responseDict = responseDict as? [String:AnyObject] {
                    
                        let user = responseDict["giver"] as! [String:AnyObject]
                        print(user)
                        
                        let userEvents = responseDict["events"] as! NSArray
                        let userNeeds = responseDict["needs"] as! NSArray
                
                        
                        CharityModel.userData.insert((UserStruct(dictionary: user)), at: 0)
                        print(CharityModel.userData[0])
                        
                        for event in userEvents {
                            CharityModel.userEvents.append(EventStruct(dictionary: event as! [String : AnyObject] ))
                        }
                        
                        for need in userNeeds {
                            CharityModel.userNeeds.append(NeedStruct(dictionary: need as! [String : AnyObject]))
                        }
                        
                    }
                    
                    print(CharityModel.userEvents)
                    print(CharityModel.userNeeds)
                    
                
                } catch let error as NSError {
                    print(error)
                }
            } as! (NSData?, NSError?) -> Void)
        
        activitySpinner.stopAnimating()
        activityView.removeFromSuperview()
    }
  
    func populateMapData(newCoordArr:[CharityStruct]) {
        
        if !mapView.annotations.isEmpty{
            mapView.removeAnnotations(mapView.annotations)
        }
        
        let coordinateArray = newCoordArr
        
        var annotations = [CharityAnnotation]()
        
        for s in  coordinateArray {
            
            self.cllocationManager.delegate = self
            
            /* Get the lat and lon values to create a coordinate */
            let lat = CLLocationDegrees(s.latitude)
            let lon = CLLocationDegrees(s.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            /* Make the map annotation with the coordinate and other student data */
            let annotation = CharityAnnotation(coordinate: coordinate)
            
            annotation.title = s.name
            annotation.subtitle = s.address[0] as? String
            annotation.phone = s.phone
            
            let imageString = NSURL(string: "\(s.imageUrl)")
            let imageData = NSData(contentsOf: imageString! as URL)
            if imageData != nil {
                annotation.image = UIImage(data: imageData! as Data)
            }
            
            /* Add the annotation to the array */
            annotations.append(annotation)
            /*Append cllocations to represent overlay connections between annotations*/
            self.mapView.delegate = self
            /*Load annotations/overlay to map view once data is completely loaded*/
                self.mapView.addAnnotations(annotations)
                self.mapView.showAnnotations(annotations, animated: true)
        }
        
        tableView.reloadData()
        
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        
        var v = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if v == nil {
            v = AnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            v!.canShowCallout = true
        }
        else {
            v!.annotation = annotation
        }
        
        if CharityModel.charityData.count > 0 {
            let customPointAnnotation = annotation as! CharityAnnotation
            
            if customPointAnnotation.image != nil {
                v!.image = resizeImage(image: customPointAnnotation.image!, newWidth: 60)
                v!.layer.borderWidth = 2
                v!.layer.borderColor = UIColor.gray.cgColor
                v!.layer.cornerRadius = 10
                
            }
        }
        else{
            v!.image = UIImage(named: "KarmaBear")
        }
        
        v!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return v
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView{
            
            view.layer.cornerRadius = 0.5
            
            print(view.annotation?.title)
            
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

    }
    
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        if view.isMemberOfClass(AnnotationView.self)
//        {
//            for subview in view.subviews
//            {
//                subview.removeFromSuperview()
//            }
//        }
//    }
  
  func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
    // hide activityIndicator view and display alert message
    let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
    errorAlert.show()
  }
  

    @IBAction func searchCoordBtn() {
        searchDBForLocation(search: searchField.text!)
        getUserData()
    }

    func searchDBForLocation(search: String) {
        
        let httpRequest = httpHelper.buildRequest(path: "search", method: "POST")
        httpRequest.httpBody = "{\"search\":\"\(search)\"}".data(using: String.Encoding.utf8)
        
        httpHelper.sendRequest(request: httpRequest, completion: {(data: NSData!, error: NSError!) in
            
            guard error == nil else {
                print(error)
                return
            }
            do {
                
                let responseDict = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions()) as? NSArray
                
                var charityLocations = [CharityStruct]()
                
                if !CharityModel.charityData.isEmpty{
                    CharityModel.charityData.removeAll()
                }
                
                for coordinate in responseDict!{
                    
                    print(coordinate)
                    
                    CharityModel.charityData.append(CharityStruct(dictionary: coordinate as! [String : AnyObject]))
                    
                    charityLocations.append(CharityStruct(dictionary: coordinate as! [String : AnyObject]))
                }
                
                DispatchQueue.main.async {
                    self.populateMapData(newCoordArr: charityLocations)
                }
                
            } catch let error as NSError {
                print(error)
            }
            
        } as! (NSData?, NSError?) -> Void)
        
            self.tableView.reloadData()
        
        
        if charitySearchCount == 0 {
            UIView.animate(withDuration: 3, animations: {
                var newCenter = self.tableView.center
                newCenter.y -= 200
                var mapCenter = self.mapView.center
                mapCenter.y += 100
                self.tableView.center = newCenter
                }, completion: { finished in
                    print("Table levitating!")
            })
        }
        
        charitySearchCount += 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > self.mapView.frame.size.height * 1 ) {
            scrollView .setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: self.mapView.frame.size.height * 1), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if CharityModel.charityData.count <= 0 {
            count = 5
        }
        else{
            count = CharityModel.charityData.count
        }
        
        return count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell? = self.tableView!.dequeueReusableCell(withIdentifier: "CharityCell") as UITableViewCell?
        
        if CharityModel.charityData.count == 0 {
            (cell?.contentView.viewWithTag(20) as? UIImageView)!.image = UIImage(named: "Launch")
            
        }else{
            let charityArr = CharityModel.charityData[indexPath.row]
            
            let url = NSURL(string: "\(charityArr.imageUrl)")
            let thisData = NSData(contentsOf: url! as URL)
            let charityImg = UIImage(data: thisData! as Data)
            
            
            if charityImg != nil {
                (cell?.contentView.viewWithTag(20) as? UIImageView)!.image = charityImg
            }
            
            (cell?.contentView.viewWithTag(21) as? UILabel)!.text = charityArr.name
            (cell?.contentView.viewWithTag(22) as? UILabel)!.text = charityArr.address[0] as? String
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if CharityModel.charityData.count != 0 {
            let selectedCharity = CharityModel.charityData[indexPath.row]
            print(selectedCharity)
            
            
            passImageUrl = selectedCharity.imageUrl
            descString = selectedCharity.description
   
            charityId = indexPath.row
            performSegue(withIdentifier: "charityDetail", sender: self)
        }else{
            showAlert(alertTitle: "Invalid", alertMessage: "It looks like this link is invalid", actionTitle: "Try Another")
        }
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print(segue.identifier)
        
        if (segue.identifier == "charityDetail") {
            let viewController = segue.destination as! CharityDetailViewController
            viewController.passedId = charityId
            viewController.imageUrl = passImageUrl
            viewController.descString = descString
        }
        
        if (segue.identifier == "activityDetail") {
            _ = segue.destination as! UserActivityViewController
        }
        
    }


  
  func updateUserLoggedInFlag() {
    let defaults = UserDefaults.standard
    defaults.set("loggedIn", forKey: "userLoggedIn")
    defaults.synchronize()
  }
    
    func showAlert(alertTitle: String, alertMessage: String, actionTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    
    static func sharedInstance() -> ViewController {
        
        struct Singleton {
            static var sharedInstance = ViewController()
        }
        return Singleton.sharedInstance
    }
}
