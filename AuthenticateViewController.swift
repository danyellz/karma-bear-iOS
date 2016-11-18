//
//  AuthenticateViewController.swift
//  KarmaBear
//
//  Created by TY on 11/16/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class AuthenticateViewController: UIViewController, FBSDKLoginButtonDelegate{
    
    var httpHelper = HTTPHelper()
    var backgroundPlayer : BackgroundVideo?
    
    let loginView: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUserToken = UserDefaults.standard.string(forKey: "FBToken")
        
        if currentUserToken != nil {
            dismiss(animated: true, completion: nil)
        }
        
        if (FBSDKAccessToken.current() != nil){
            print("A user is already logged in!")
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.view.addSubview(loginView)
            loginView.center = view.center
            loginView.delegate = self
        }
        
        backgroundPlayer = BackgroundVideo(on: self, withVideoURL: "charity-1.mp4")
        backgroundPlayer!.setUpBackground()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            print(error)
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            print("Setup Navigation to View")
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                getTokenFromFB()
            }
        }
    }
    
    func getTokenFromFB() {
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start{ (connection, result, error) -> Void in
            
            let result = result as! [String:AnyObject]
            let userId = result["id"] as! String
            let accessToken = FBSDKAccessToken.current().tokenString as String
            
            guard error == nil else{
                print(error)
                return
            }
            
            let httpRequest = self.httpHelper.buildRequest(path: "auth/verify", method: "POST")
            httpRequest.httpBody = "{\"id\":\"\(userId)\",\"access_token\":\"\(accessToken)\"}".data(using: String.Encoding.utf8)
            
            self.httpHelper.sendRequest(request: httpRequest, completion: {(data, error) in
                
                guard error == nil else {
                    print(error)
                    return
                }
                do
                {
                    let responseDict = try JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    UserDefaults.standard.setValue("\(responseDict)", forKey: "FBToken")
                    UserDefaults.standard.synchronize()
                    
                    let currentUserToken = UserDefaults.standard.string(forKey: "FBToken")
                    print(currentUserToken)
                    
                } catch let error as NSError {
                    print(error)
                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
}



