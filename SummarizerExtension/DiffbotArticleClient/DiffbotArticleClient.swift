//
//  DiffbotArticleClient.swift
//  Article Summarizer
//
//  Client that uses GET Requests to access the Diffbot API
//
//  Created by Sahaj Bhatt on 3/20/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit

//API constants
let Diffbot_API_Token = "e9f92e911efc248037f969b3886f6169"
let Diffbot_Base_URL = "http://api.diffbot.com/v3/article"

public class DiffbotArticleClient {
    //Analyzes the article on the provided url
    //Additional parameters can be passed in to specify details regarding the output
    public static func analyze(articleURL : String, params : NSDictionary?, withCallback : (succeeded: Bool, data : NSDictionary?) -> ()) {
        //Converts parameters to url form
        let paramsString = convertParams(params)
        //Converts url to a format that is allowed to be passed in as a parameter in the url
        let customAllowedSet = NSCharacterSet(charactersInString: "&=\"#%/<>?@\\^`{|}").invertedSet
        let urlString = Diffbot_Base_URL + "?token=" + Diffbot_API_Token + "&url=" + articleURL.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)! + paramsString
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        
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