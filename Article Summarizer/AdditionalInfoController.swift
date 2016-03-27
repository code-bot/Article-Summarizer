//
//  AdditionalInfoController.swift
//  Article Summarizer
//
//  Shows additional information from the summary
//
//  Created by Sahaj Bhatt on 3/21/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit

class AdditionalInfoController: UIViewController {
    
    var infoType = "Additional Info"
    var sourceUrl = ""
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change title of navigation bar based on the type of info presented
        navBar.topItem?.title = infoType
        
        //Set webview options and load url
        webView.scrollView.bounces = false
        if (sourceUrl != "") {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: sourceUrl)!))
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
