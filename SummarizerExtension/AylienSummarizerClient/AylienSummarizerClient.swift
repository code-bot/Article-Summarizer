//
//  AylienSummarizerClient.swift
//  Article Summarizer
//
//  Client that uses GET Requests to access the AYLIEN Text Analysis API
//
//  Created by Sahaj Bhatt on 3/18/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit

//API constants
let AYLIEN_TextAPI_App_Key = "9cec5357fbdf8eece817054e0d153141"
let AYLIEN_TextAPI_App_ID = "ced832ab"
let AYLIEN_Base_URL = "https://api.aylien.com/api/v1"

public class AylienSummarizerClient {
    
    //Summarizes the article on the provided url
    //Additional parameters can be passed in to edit the number of sentences and the language
    public static func summarize(articleURL : String, params : NSDictionary?, withCallback : (succeeded: Bool, data : NSDictionary?) -> ()) {
        //Converts parameters to url form
        let paramsString = convertParams(params)
        //Converts url to a format that is allowed to be passed in as a parameter in the url
        let customAllowedSet = NSCharacterSet(charactersInString: "&=\"#%/<>?@\\^`{|}").invertedSet
        let urlString = AYLIEN_Base_URL + "/summarize" + "?url=" + articleURL.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)! + paramsString
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        //Add headers regarding the API key and App ID to the request
        request.addValue(AYLIEN_TextAPI_App_Key, forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-Key")
        request.addValue(AYLIEN_TextAPI_App_ID, forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-ID")
        
        //Start a GET Request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error)
                withCallback(succeeded: false, data: nil)
            } else {
                var json : NSDictionary?
                do {
                    //Get data from the API in JSON format
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
    
    //Gets all related phrases for an input string
    public static func relatedPhrases(inputString: String, withCallback: (succeeded: Bool, data: [NSDictionary]?) -> ()) {
        //Adds input string to the base url
        let urlString = AYLIEN_Base_URL + "/related" + "?phrase=" + inputString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        //Add headers regarding the API key and App ID to the request
        request.addValue(AYLIEN_TextAPI_App_Key, forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-Key")
        request.addValue(AYLIEN_TextAPI_App_ID, forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-ID")
        
        //Start a GET request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error)
                withCallback(succeeded: false, data: nil)
            } else {
                var json : NSDictionary?
                do {
                    //Get data from the API in JSON format
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
    
    //Converts the given parameters into a form that can be passed into a url
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