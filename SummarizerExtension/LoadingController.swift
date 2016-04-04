//
//  LoadingController.swift
//  Article Summarizer
//
//  Loads the summary and additional information of article using the AylienSummarizerClient and DiffbotArticleClient
//
//  Created by Sahaj Bhatt on 3/20/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit
import MobileCoreServices

class LoadingController: UIViewController {
    
    var articleTitle = ""
    var articleAuthor = ""
    var articlePublication = ""
    var summaryString = ""
    var articleTags = [NSDictionary]()
    var relatedPhrasesForTags = [[NSDictionary]]()
    var authorUrl = ""
    var sourceUrl = ""
    var articleExists = false
    var imageUrl = ""
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingLabel.text = "Loading Summary"
        
        // Get the item[s] we're handling from the extension context.
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        //Get the url of the article accessed on Safari
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItemForTypeIdentifier(propertyList, options: nil, completionHandler: { (item, error) -> Void in
                let dictionary = item as! NSDictionary
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                    //Get the source URL
                    self.sourceUrl = results["currentUrl"] as! String
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        //Check whether the article exists in stored data already
                        let myDefaults = NSUserDefaults(suiteName: "group.com.sahajbhatt.Article-Summarizer")
                        let storedInfo = myDefaults?.arrayForKey("urls")
                        var index = 0;
                        if (storedInfo != nil) {
                            while (index < storedInfo!.count && !self.articleExists) {
                                let article = storedInfo![index] as! NSDictionary
                                if (article["url"] as! String == self.sourceUrl) {
                                    self.articleExists = true
                                }
                                index++
                            }
                        }
                        
                        if (!self.articleExists) {
                            //If the article doesn't exist in local storage, load the summary with the APIs
                            self.loadSummary(self.sourceUrl)
                        } else {
                            //If the article already exists in local storage, get the stored data
                            let article = storedInfo![index-1] as! NSDictionary
                            self.articleTitle = article["title"] as! String
                            self.articleAuthor = article["author"] as! String
                            self.articlePublication = article["publication"] as! String
                            self.summaryString = article["summary"] as! String
                            self.authorUrl = article["authorUrl"] as! String
                            self.performSegueWithIdentifier("showSummary", sender: nil)
                        }
                    }
                    
                }
            })
        } else {
            print("Error: Could not get url link of article from Safari source")
            //If there is an error, close the extension
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
            }
        }
    }
    
    //Loads all relevant information about the article and the summary
    func loadSummary(sourceUrl: String) {
        var apiFinished = false;
        
        //AYLIEN API Request
        AylienSummarizerClient.summarize(sourceUrl, params: nil) { (succeeded, data) -> () in
            if (succeeded) {
                print("Aylien api accessed: Summarizer")
                
                //Get the summary
                if let sentences = data!["sentences"] {
                    for sentence in sentences as! [String] {
                        self.summaryString += sentence + " "
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    //If no summary is actually generated, quit the extension
                    if (self.summaryString == "") {
                        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
                    }
                    //Wait until both APIs are accessed before loading summary
                    if (apiFinished) {
                        self.performSegueWithIdentifier("showSummary", sender: nil)
                    } else {
                        apiFinished = true
                    }
                }
                
            } else {
                print("Aylien api failed to access: Summarizer")
                //If there is an error, close the extension
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
                }
                
            }
        }
        
        
        //Diffbot API Request
        DiffbotArticleClient.analyze(sourceUrl, params: nil) { (succeeded, data) -> () in
            if (succeeded) {
                print("Diffbot api accessed: Article Analyze")
                
                //Get additional information about the article
                if let objects = data!["objects"] as! NSArray? {
                    let info = objects[0] as! NSDictionary
                    if let title = info["title"] {
                        self.articleTitle = title as! String
                    }
                    if let author = info["author"] {
                        self.articleAuthor = author as! String
                    }
                    if let publisher = info["siteName"] {
                        self.articlePublication = "Published by " + (publisher as! String)
                    }
                    if let publisherCountry = info["publisherCountry"] {
                        self.articlePublication += " in " + (publisherCountry as! String)
                    }
                    if let date = info["date"] {
                        self.articlePublication += " on " + (date as! String).substringToIndex((date as! String).startIndex.advancedBy(16))
                    }
                    if let tags = info["tags"] {
                        self.articleTags = tags as! [NSDictionary]
                    }
                    if let authURL = info["authorUrl"] {
                        self.authorUrl = authURL as! String
                    }
                    if let images = info["images"] {
                        self.imageUrl = (images[0] as! NSDictionary)["url"] as! String
                    }
                } else {
                    //If there is an error, close the extension
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    //Get related phrases for each key word in the article
                    var tagsFinished = 0
                    var relatedPhrasesDone = true
                    while (tagsFinished < self.articleTags.count) {
                        //Call the GET request again once the original thread is finished
                        if (relatedPhrasesDone && tagsFinished < self.articleTags.count) {
                            let tag = self.articleTags[tagsFinished]
                            AylienSummarizerClient.relatedPhrases((tag["label"] as! String).stringByReplacingOccurrencesOfString(")", withString: "").stringByReplacingOccurrencesOfString("(", withString: "")) { (succeeded, data) -> () in
                                if (succeeded) {
                                    print("Aylien api accessed: Related Phrases")
                                    //Add all related phrases
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
                //If there is an error, close the extension
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
                }
            }
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Transfer data to SummaryController when the segue is performed
        if let vc = segue.destinationViewController as? SummaryController {
            vc.articleTitle = self.articleTitle
            vc.articleAuthor = self.articleAuthor
            vc.articlePublication = self.articlePublication
            vc.summaryText = self.summaryString
            vc.tags = self.articleTags
            vc.authorUrl = self.authorUrl
            vc.sourceUrl = self.sourceUrl
            vc.originalExtensionContext = self.extensionContext
            vc.relatedPhrasesForTags = self.relatedPhrasesForTags
            vc.articleExists = self.articleExists
            vc.imageUrl = self.imageUrl
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
