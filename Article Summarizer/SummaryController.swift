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
        summaryHTML += "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.loadHTMLString(summaryHTML, baseURL: nil)
    }
    
    @IBAction func loadAuthorPage(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: authorURL)!)
    }
    
    //Hyperlink tapped within webview
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //Open link via safari
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

