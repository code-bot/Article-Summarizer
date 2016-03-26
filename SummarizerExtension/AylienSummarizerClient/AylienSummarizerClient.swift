//
//  AylienSummarizerClient.swift
//  Article Summarizer
//
//  Created by Sahaj Bhatt on 3/18/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit

let AYLIEN_TextAPI_App_Key = "9cec5357fbdf8eece817054e0d153141"
let AYLIEN_TextAPI_App_ID = "ced832ab"
let AYLIEN_Base_URL = "https://api.aylien.com/api/v1"

public class AylienSummarizerClient {
    
    //Summarizes the article on the provided url
    //Additional parameters can be passed in to edit the number of sentences and the language
    public static func summarize(articleURL : String, params : NSDictionary?, withCallback : (succeeded: Bool, data : NSDictionary?) -> ()) {
        let paramsString = convertParams(params)
        let urlString = AYLIEN_Base_URL + "/summarize" + "?url=" + articleURL.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + paramsString
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(AYLIEN_TextAPI_App_Key, forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-Key")
        request.addValue(AYLIEN_TextAPI_App_ID, forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-ID")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error)
                withCallback(succeeded: false, data: nil)
            } else {
                var json : NSDictionary?
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                    
                    if let parseJSON = json {
                        withCallback(succeeded: true, data: parseJSON)
                    } else {
                        withCallback(succeeded: true, data: nil)
                    }
                } catch let err {
                    print(err)
                    withCallback(succeeded: false, data: nil)
                }
            }
        })
        
        task.resume()
    }
    
    public static func relatedPhrases(inputString: String, withCallback: (succeeded: Bool, data: [NSDictionary]?) -> ()) {
        let urlString = AYLIEN_Base_URL + "/related" + "?phrase=" + inputString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(AYLIEN_TextAPI_App_Key, forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-Key")
        request.addValue(AYLIEN_TextAPI_App_ID, forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-ID")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error)
                withCallback(succeeded: false, data: nil)
            } else {
                var json : NSDictionary?
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                    
                    if let parseJSON = json {
                        withCallback(succeeded: true, data: (parseJSON["related"] as! [NSDictionary]))
                    } else {
                        withCallback(succeeded: true, data: nil)
                    }
                } catch let err {
                    print(err)
                    withCallback(succeeded: false, data: nil)
                }
            }
        })
        
        task.resume()
    }
    
    public static func convertParams(params: NSDictionary?) -> String {
        var paramString = ""
        if (params != nil) {
            for (key, value) in params! {
                paramString += "&" + (key as! String) + "=" + (value as! String)
            }
        }
        return paramString
    }
}