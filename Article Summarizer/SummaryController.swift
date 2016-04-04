//
//  SummaryController.swift
//  Article Summarizer
//
//  Shows summary and additional information of the article
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
        
        //Add navigation bar button to view the full article
        let fullArticleBtn = UIBarButtonItem(title: "View Full Article", style: .Plain, target: self, action: "viewFullArticle")
        self.navigationItem.rightBarButtonItem = fullArticleBtn
        
        //Set title, author, and publication labels' texts
        self.titleLabel.text = articleTitle
        self.authorButton.setTitle(articleAuthor, forState: UIControlState.Normal)
        //Change text color and interaction status based on the existance of an author url
        if (authorUrl == "") {
            self.authorButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.authorButton.userInteractionEnabled = false
        } else {
            self.authorButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            self.authorButton.userInteractionEnabled = true
        }
        self.publicationLabel.text = articlePublication
        
        //Set webview options and load html text
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.loadHTMLString(summaryHTML, baseURL: nil)
    }
    
    //Segues to AdditionalInfoController with author url once author button is tapped
    @IBAction func loadAuthorPage(sender: AnyObject) {
        performSegueWithIdentifier("showAdditionalInfo", sender: ["Author Info", authorUrl])
    }
    
    //Opens hyperlink within webview
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //Open link via AdditionalInfoController
        if navigationType == UIWebViewNavigationType.LinkClicked {
            performSegueWithIdentifier("showAdditionalInfo", sender: ["Additional Info", request.URL!.absoluteString])
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Transfer information to AdditionalInfoController
        if let vc = segue.destinationViewController as? AdditionalInfoController {
            if let params = sender as? [String] {
                vc.infoType = params[0]
                vc.sourceUrl = params[1]
            }
        }
    }
    
    //Open full article url via Safari when tapping on navigation bar button
    func viewFullArticle() {
        UIApplication.sharedApplication().openURL(NSURL(string: sourceUrl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
