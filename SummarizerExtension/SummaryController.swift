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
    var originalExtensionContext: NSExtensionContext?
    var articleExists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if (!articleExists) {
            //Convert summary to HTML text and add hyperlinks around key words in text
            summaryHTML = "<p>" + summaryText + "</p>"
            for (index,tag) in tags.enumerate() {
                print(tag)
                let tagLabel = (tag["label"] as! String).stringByReplacingOccurrencesOfString(")", withString: "").stringByReplacingOccurrencesOfString("(", withString: "")
                let range = summaryHTML.rangeOfString(tagLabel, options: NSStringCompareOptions.CaseInsensitiveSearch)
                if (range != nil) {
                    summaryHTML = summaryHTML.stringByReplacingOccurrencesOfString(tagLabel, withString: "<a href=https://en.wikipedia.org/wiki/" + (tagLabel).stringByReplacingOccurrencesOfString(" ", withString: "_") + ">" + summaryHTML.substringWithRange(range!) + "</a>", options: NSStringCompareOptions.CaseInsensitiveSearch, range: range!)
                } else {
                    var phraseIndex = 0
                    while (phraseIndex < relatedPhrasesForTags[index].count) {
                        let rangeOfRelatedPhrase = summaryHTML.rangeOfString(relatedPhrasesForTags[index][phraseIndex]["phrase"] as! String, options: NSStringCompareOptions.CaseInsensitiveSearch)
                        if (rangeOfRelatedPhrase != nil) {
                            summaryHTML = summaryHTML.stringByReplacingOccurrencesOfString(relatedPhrasesForTags[index][phraseIndex]["phrase"] as! String, withString: "<a href=https://en.wikipedia.org/wiki/" + (tag["label"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "_") + ">" + summaryHTML.substringWithRange(rangeOfRelatedPhrase!) + "</a>", options: NSStringCompareOptions.CaseInsensitiveSearch, range: rangeOfRelatedPhrase!)
                            phraseIndex = relatedPhrasesForTags[index].count
                        } else {
                            phraseIndex++
                        }
                    }
                }
                
            }
            
            //Store article information for viewing in main app
            let myDefaults = NSUserDefaults(suiteName: "group.com.sahajbhatt.Article-Summarizer")
            var storedInfo = myDefaults?.arrayForKey("urls")
            if (storedInfo == nil) {
                myDefaults?.setObject([["url":self.sourceUrl,"title":self.articleTitle,"author":self.articleAuthor,"authorUrl":self.authorUrl,"publication":self.articlePublication,"summary":self.summaryHTML]], forKey: "urls")
            } else {
                storedInfo!.insert(["url":self.sourceUrl,"title":self.articleTitle,"author":self.articleAuthor,"authorUrl":self.authorUrl,"publication":self.articlePublication,"summary":self.summaryHTML], atIndex: 0)
                myDefaults?.setObject(storedInfo!, forKey: "urls")
            }
        } else {
            summaryHTML = summaryText
        }
        
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.loadHTMLString(summaryHTML, baseURL: nil)
    }
    
    @IBAction func loadAuthorPage(sender: AnyObject) {
        performSegueWithIdentifier("showAdditionalInfo", sender: ["Author Info", authorUrl])
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

