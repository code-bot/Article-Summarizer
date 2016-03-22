//
//  SummaryController.swift
//  Article Summarizer
//
//  Created by Sahaj Bhatt on 3/11/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit

class SummaryController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var publicationLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var articleTitle = ""
    var articleAuthor = ""
    var articlePublication = ""
    var summaryText = ""
    var summaryHTML = ""
    var tags = [NSDictionary]()
    var authorURL = ""
    var originalExtensionContext: NSExtensionContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = articleTitle
        self.authorButton.setTitle(articleAuthor, forState: UIControlState.Normal)
        if (authorURL == "") {
            self.authorButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.authorButton.userInteractionEnabled = false
        } else {
            self.authorButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            self.authorButton.userInteractionEnabled = true
        }
        self.publicationLabel.text = articlePublication
        
        //Convert summary to HTML text and add hyperlinks around key words in text
        summaryHTML = "<p>" + summaryText + "</p>"
        for tag in tags {
            summaryHTML = summaryHTML.stringByReplacingOccurrencesOfString(tag["label"] as! String, withString: "<a href=" + (tag["uri"] as! String) + ">" + (tag["label"] as! String) + "</a>")
            print(tag["label"] as! String)
        }
        
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.loadHTMLString(summaryHTML, baseURL: nil)
    }
    
    @IBAction func loadAuthorPage(sender: AnyObject) {
        performSegueWithIdentifier("showAdditionalInfo", sender: ["Author Info", authorURL])
        //UIApplication.sharedApplication().openURL(NSURL(string: authorURL)!)
    }
    
    //Hyperlink tapped within webview
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //Open link via safari
        if navigationType == UIWebViewNavigationType.LinkClicked {
            performSegueWithIdentifier("showAdditionalInfo", sender: ["Additional Info", request.URL!.absoluteString])
            //UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
    @IBAction func done(sender: AnyObject) {
        // Echo the passed in items
        //print(self.extensionContext!)
        //self.dismissViewControllerAnimated(false, completion: nil)
        self.originalExtensionContext!.completeRequestReturningItems(self.originalExtensionContext!.inputItems, completionHandler: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? AdditionalInfoController {
            if let params = sender as? [String] {
                vc.infoType = params[0]
                vc.sourceUrl = params[1]
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

