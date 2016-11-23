//
//  HTTPHelper.swift
//  KarmaBear
//
//  Created by TY on 11/16/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import Foundation
import CoreLocation

enum HTTPRequestAuthType {
    case HTTPBasicAuth
    case HTTPTokenAuth
}

enum HTTPRequestContentType {
    case HTTPJsonContent
    case HTTPMultipartContent
}

struct HTTPHelper {
    static let BASE_URL = FBConstants.BASE_URL
    
    func buildRequest(path: String!, method: String, requestContentType: HTTPRequestContentType = HTTPRequestContentType.HTTPJsonContent, requestBoundary:String = "") -> NSMutableURLRequest {
        // 1. Create the request URL from path
        let requestURL = NSURL(string: "\(HTTPHelper.BASE_URL)/\(path as! String)")
        let request = NSMutableURLRequest(url: requestURL! as URL)

        // Set HTTP request method and Content-Type
        request.httpMethod = method
        
        // 2. Set the correct Content-Type for the HTTP Request. This will be multipart/form-data for photo upload request and application/json for other requests in this app
        switch requestContentType {
        case .HTTPJsonContent:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .HTTPMultipartContent:
            let contentType = "multipart/form-data; boundary=\(requestBoundary)"
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }    
    
    func sendRequest(request: NSURLRequest, completion: @escaping (NSData?, NSError?) -> Void) -> () {
        // Create a NSURLSession task
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            guard error == nil && data != nil else{
                print(error)
                completion(nil, error as NSError?)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 else{
                completion(nil, error as NSError?)
                return
            }
            do
            {
                completion(data as NSData?, nil)
                
            } catch let parserError as NSError{
                print(parserError)
            }
        }
        task.resume()
    }
    
    func sendCharitySearchRequest(request: NSURLRequest, completion:@escaping ([CLLocationCoordinate2D]?, NSError?) -> Void) -> () {
        // Create a NSURLSession task
        var charityLocations = [CLLocationCoordinate2D]()
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            guard error == nil && data != nil else{
                print(error)
                completion(nil, error as NSError?)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 else{
                completion(nil, error as NSError?)
                return
            }
            do
            {
                guard error == nil else {
                    print(error)
                    return
                }
                
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? NSArray
                
                for coordinate in jsonData!{
                    
                    let json = coordinate as? [String:AnyObject]
                    let coordinatesToAppend = CLLocationCoordinate2D(latitude: (json!["lat"]! as? Double)!, longitude: (json!["lng"]! as? Double)!)
                    charityLocations.append(coordinatesToAppend)
                }
                completion(charityLocations, nil)
                
            } catch let parserError as NSError{
                print(parserError)
            }
        }
        task.resume()
    }
    
    
    func sharedInstance() -> HTTPHelper {
        
        struct Singleton {
            static var sharedInstance = HTTPHelper()
        }
        return Singleton.sharedInstance
    }
}

