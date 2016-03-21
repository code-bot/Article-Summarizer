//
//  DiffbotArticleClient.swift
//  Article Summarizer
//
//  Created by Sahaj Bhatt on 3/20/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

let Diffbot_API_Token = "e9f92e911efc248037f969b3886f6169"
let Diffbot_Base_URL = "http://api.diffbot.com/v3/article"

public class DiffbotArticleClient {
    //Summarizes the article on the provided url
    //Additional parameters can be passed in to edit the number of sentences and the language
    public static func analyze(articleURL : String, params : NSDictionary?, withCallback : (succeeded: Bool, data : NSDictionary?) -> ()) {
        let paramsString = convertParams(params)
        let urlString = Diffbot_Base_URL + "?token=" + Diffbot_API_Token + "&url=" + articleURL.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + paramsString
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        
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