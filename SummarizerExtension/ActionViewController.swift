//
//  ActionViewController.swift
//  SummarizerExtension
//
//  Created by Sahaj Bhatt on 3/20/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit
import MobileCoreServices
import Article_Summarizer

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var finished = false
        var sourceUrl = ""
        
        // Get the item[s] we're handling from the extension context.
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItemForTypeIdentifier(propertyList, options: nil, completionHandler: { (item, error) -> Void in
                let dictionary = item as! NSDictionary
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                    sourceUrl = results["currentURL"] as! String
                }
            })
        } else {
            print("error")
        }
        
        //AYLIEN API Request
        AylienSummarizerClient.summarize(sourceUrl, params: nil) { (succeeded, data) -> () in
            if (succeeded) {
                print("Aylien api accessed")
                
                if let sentences = data!["sentences"] {
                    for sentence in sentences as! [String] {
                        self.summaryString += sentence + " "
                    }
                }
                
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
        
        
        
        //Diffbot API Request
        DiffbotAPIClient.apiRequest(DiffbotArticleRequest, urlString: sourceUrl, optionalArgs: nil, format: DiffbotAPIFormatJSON) { (success: Bool, result: AnyObject?) in
            if (success) {
                print("Diffbot api accessed")
                
                if let dict = result as! NSDictionary? {
                    if let objects = dict["objects"] as! NSArray? {
                        let info = objects[0] as! NSDictionary
                        print(info)
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
                        }
                        if let authURL = info["authorUrl"] {
                            self.authURL = authURL as! String
                        }
                    }
                }
                
                //Wait until both APIs are accessed before loading summary
                if (finished) {
                    self.performSegueWithIdentifier("showSummary", sender: nil)
                } else {
                    finished = true
                }
            } else {
                print("Diffbot api failed to access")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }

}
