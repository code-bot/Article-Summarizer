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
    var authURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var finished = true;
        let sourceUrl = "http://www.cnn.com/2016/03/19/us/neanderthal-human-interbred-irpt/index.html"
        
        //AYLIEN API Request
        AylienSummarizerClient.summarize(sourceUrl, params: nil) { (succeeded, data) -> () in
            if (succeeded) {
                print("Aylien api accessed")
                
                if let sentences = data!["sentences"] {
                    for sentence in sentences as! [String] {
                        self.summaryString += sentence + " "
                    }
                    print(sentences)
                }
                print("done")
                print(finished)
                //Wait until both APIs are accessed before loading summary
                if (finished) {
                    self.performSegueWithIdentifier("showSummary", sender: nil)
                } else {
                    finished = true
                }
            } else {
                print("Aylien api failed to access")
            }
        }
        
        
//        //Diffbot API Request
//        DiffbotArticleClient.analyze(sourceUrl, params: nil) { (succeeded, data) -> () in
//            if (succeeded) {
//                print("Diffbot api accessed")
//                if let objects = data!["objects"] as! NSArray? {
//                    print("hi")
//                    let info = objects[0] as! NSDictionary
//                    print(info)
//                    if let title = info["title"] {
//                        self.articleTitle = title as! String
//                    }
//                    if let author = info["author"] {
//                        self.articleAuthor = author as! String
//                    }
//                    if let date = info["date"] {
//                        self.articlePublication = (date as! String).substringToIndex((date as! String).startIndex.advancedBy(16))
//                    }
//                    if let tags = info["tags"] {
//                        self.articleTags = tags as! [NSDictionary]
//                    }
//                    if let authURL = info["authorUrl"] {
//                        self.authURL = authURL as! String
//                    }
//                }
//                print(finished)
//                //Wait until both APIs are accessed before loading summary
//                if (finished) {
//                    print("segue")
//                    self.performSegueWithIdentifier("showSummary", sender: nil)
//                } else {
//                    print("not segue")
//                    finished = true
//                }
//            } else {
//                print("Diffbot api failed to access")
//            }
//        }

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
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
