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
    var authorURL = ""
    var sourceURL = ""
    
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
        for (index,tag) in tags.enumerate() {
            print(tag)
            let range = summaryHTML.rangeOfString(tag["label"] as! String, options: NSStringCompareOptions.CaseInsensitiveSearch)
            if (range != nil) {
                summaryHTML = summaryHTML.stringByReplacingOccurrencesOfString(tag["label"] as! String, withString: "<a href=" + (tag["uri"] as! String) + ">" + summaryHTML.substringWithRange(range!) + "</a>", options: NSStringCompareOptions.CaseInsensitiveSearch, range: range!)
            } else {
                var phraseIndex = 0
                while (phraseIndex < relatedPhrasesForTags[index].count) {
                    let rangeOfRelatedPhrase = summaryHTML.rangeOfString(relatedPhrasesForTags[index][phraseIndex]["phrase"] as! String, options: NSStringCompareOptions.CaseInsensitiveSearch)
                    if (rangeOfRelatedPhrase != nil) {
                        print(relatedPhrasesForTags[index][phraseIndex]["phrase"] as! String)
                        summaryHTML = summaryHTML.stringByReplacingOccurrencesOfString(relatedPhrasesForTags[index][phraseIndex]["phrase"] as! String, withString: "<a href=" + (tag["uri"] as! String) + ">" + summaryHTML.substringWithRange(rangeOfRelatedPhrase!) + "</a>", options: NSStringCompareOptions.CaseInsensitiveSearch, range: rangeOfRelatedPhrase!)
                        phraseIndex = relatedPhrasesForTags[index].count
                    } else {
                        phraseIndex++
                    }
                }
            }
            
        }
        
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.loadHTMLString(summaryHTML, baseURL: nil)
    }
    
    @IBAction func loadAuthorPage(sender: AnyObject) {
        performSegueWithIdentifier("showAdditionalInfo", sender: ["Author Info", authorURL])
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
    
    @IBAction func viewFullArticle(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: sourceURL)!)
    }
    
    @IBAction func returnToSavedArticles(sender: AnyObject) {
        let presentingVC = self.presentingViewController
        self.dismissViewControllerAnimated(true, completion: {
            presentingVC?.dismissViewControllerAnimated(false, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
