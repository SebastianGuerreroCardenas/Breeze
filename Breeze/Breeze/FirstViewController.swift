//
//  FirstViewController.swift
//  Breeze
//
//  Created by Sebastian Guerrero on 9/12/15.
//  Copyright (c) 2015 Sebastian Guerrero. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var indoorTemp: UILabel!
    @IBOutlet weak var outdoorTemp: UILabel!
    @IBOutlet weak var moneySaved: UILabel!
    
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    func update() {
        let url = NSURL(string: "https://expressthing.herokuapp.com/temp")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            let myNSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            //myNSString.substringWithRange(NSRange(location: 0, length: 2))
            println(myNSString)
            
            let dictTemps = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: nil) as! NSDictionary
            //updates the tempetatures and the money saved
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let indoorT = dictTemps["insidewindowTemp"] as? String{
                    self.indoorTemp.text = indoorT
                }
                if let outsideT = dictTemps["outsidewindowTemp"] as? String{
                    self.outdoorTemp.text = outsideT
                }
            })

        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestPost(sender: AnyObject) {
        // create the request & response
        var request = NSMutableURLRequest(URL: NSURL(string: "https://expressthing.herokuapp.com/api/changewindow")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var error: NSError?
        
        // create some JSON data and configure the request
//        let jsonString = "json=[{\"str\":\"Hello\",\"num\":1},{\"str\":\"Goodbye\",\"num\":99}]"
//        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//        request.HTTPMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // send the request
        NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        // look at the response
        if let httpResponse = response as? NSHTTPURLResponse {
            println("HTTP response: \(httpResponse.statusCode)")
        } else {
            println("No HTTP response")
        }
    }

}

