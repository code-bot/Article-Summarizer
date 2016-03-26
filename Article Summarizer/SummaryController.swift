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
    var relatedPhrasesForTags = [[NSDictionary]]()
    var authorUrl = ""
    var sourceUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullArticleBtn = UIBarButtonItem(title: "View Full Article", style: .Plain, target: self, action: "viewFullArticle")
        self.navigationItem.rightBarButtonItem = fullArticleBtn
        self.titleLabel.text = articleTitle
        self.authorButton.setTitle(articleAuthor, forState: UIControlState.Normal)
        if (authorUrl == "") {
            self.authorButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.authorButton.userInteractionEnabled = false
        } else {
            self.authorButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            self.authorButton.userInteractionEnabled = true
        }
        self.publicationLabel.text = articlePublication
        
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.loadHTMLString(summaryHTML, baseURL: nil)
    }
    
    @IBAction func loadAuthorPage(sender: AnyObject) {
        performSegueWithIdentifier("showAdditionalInfo", sender: ["Author Info", authorUrl])
    }
    
    //Hyperlink tapped within webview
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //Open link via safari
        if navigationType == UIWebViewNavigationType.LinkClicked {
            performSegueWithIdentifier("showAdditionalInfo", sender: ["Additional Info", request.URL!.absoluteString])
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? AdditionalInfoController {
            if let params = sender as? [String] {
                vc.infoType = params[0]
                vc.sourceUrl = params[1]
            }
        }
    }
    
    func viewFullArticle() {
        UIApplication.sharedApplication().openURL(NSURL(string: sourceUrl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
