//
//  LoadingController.swift
//  Article Summarizer
//
//  Created by Sahaj Bhatt on 3/20/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit
import ArticleSummarizerKit

class LoadingController: UIViewController {
    
    var articleTitle = ""
    var articleAuthor = ""
    var articlePublication = ""
    var summaryString = ""
    var articleTags = [NSDictionary]()
    var relatedPhrasesForTags = [[NSDictionary]]()
    var authURL = ""
    var sourceUrl = "http://www.cnn.com/2016/03/19/us/neanderthal-human-interbred-irpt/index.html"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var apiFinished = false;
        
        //AYLIEN API Request
        AylienSummarizerClient.summarize(sourceUrl, params: nil) { (succeeded, data) -> () in
            if (succeeded) {
                print("Aylien api accessed: Summarizer")
                
                if let sentences = data!["sentences"] {
                    for sentence in sentences as! [String] {
                        self.summaryString += sentence + " "
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    //Wait until both APIs are accessed before loading summary
                    if (apiFinished) {
                        self.performSegueWithIdentifier("showSummary", sender: nil)
                    } else {
                        apiFinished = true
                    }
                }
                
            } else {
                print("Aylien api failed to access: Summarizer")
            }
        }
        
        
        //Diffbot API Request
        DiffbotArticleClient.analyze(self.sourceUrl, params: nil) { (succeeded, data) -> () in
            if (succeeded) {
                print("Diffbot api accessed: Article Analyze")
                if let objects = data!["objects"] as! NSArray? {
                    let info = objects[0] as! NSDictionary
                    if let title = info["title"] {
                        self.articleTitle = title as! String
                    }
                    if let author = info["author"] {
                        self.articleAuthor = author as! String
                    }
                    if let date = info["date"] {
                        self.articlePublication = (date as! String).substringToIndex((date as! String).startIndex.advancedBy(16))
                    }
                    if let tags = info["tags"] {
                        self.articleTags = tags as! [NSDictionary]
                        print(tags)
                    }
                    if let authURL = info["authorUrl"] {
                        self.authURL = authURL as! String
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    var tagsFinished = 0
                    var relatedPhrasesDone = true
                    while (tagsFinished < self.articleTags.count) {
                        if (relatedPhrasesDone && tagsFinished < self.articleTags.count) {
                            let tag = self.articleTags[tagsFinished]
                            //self.relatedPhrasesForTags.append(["label":tag["label"] as! String])
                            AylienSummarizerClient.relatedPhrases(tag["label"] as! String) { (succeeded, data) -> () in
                                if (succeeded) {
                                    print("Aylien api accessed: Related Phrases")
                                    if let phrases = data {
                                        self.relatedPhrasesForTags.append(phrases)
                                    }
                                } else {
                                    print("Aylien api failed to access: Related Phrases")
                                }
                                tagsFinished++
                                relatedPhrasesDone = true
                            }
                            relatedPhrasesDone = false
                        }
                    }
                    //Wait until both APIs are accessed before loading summary
                    if (tagsFinished == self.articleTags.count && apiFinished) {
                        self.performSegueWithIdentifier("showSummary", sender: nil)
                    } else {
                        apiFinished = true
                    }
                }
                
            } else {
                print("Diffbot api failed to access: Article Analyze")
            }
        }
        print("hey")
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? SummaryController {
            //Pass data to SummaryController
            vc.articleTitle = self.articleTitle
            vc.articleAuthor = self.articleAuthor
            vc.articlePublication = self.articlePublication
            vc.summaryText = self.summaryString
            vc.tags = self.articleTags
            vc.authorURL = self.authURL
            vc.sourceURL = self.sourceUrl
            vc.relatedPhrasesForTags = self.relatedPhrasesForTags
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
