//
//  AdditionalInfoController.swift
//  Article Summarizer
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
        navBar.topItem?.title = infoType
        webView.scrollView.bounces = false
        if (sourceUrl != "") {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: sourceUrl)!))
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}