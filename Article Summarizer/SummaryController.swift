//
//  SummaryController.swift
//  Article Summarizer
//
//  Created by Sahaj Bhatt on 3/11/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit



class SummaryController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publicationLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var summaryLabel: UILabel!
    var articleTitle = ""
    var articleAuthor = ""
    var articlePublication = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let source_url = "http://www.cnn.com/2016/03/17/us/seaworld-last-generation-of-orcas/index.html"
        
//        summaryLabel = UILabel(frame: scrollView.bounds)
//        AylienSummarizerClient.summarize(source_url, params: nil) { (succeeded, data) -> () in
//            if (succeeded) {
//                print("success")
//                print(data)
//                var summaryString = ""
//                if let sentences = data!["sentences"] {
//                    for sentence in sentences as! [String] {
//                        summaryString += sentence
//                    }
//                }
//                self.summaryLabel.text = summaryString
//                self.scrollView.addSubview(self.summaryLabel)
//                print("added to scroll view")
//            } else {
//                print("failure")
//            }
//        }
        
        
        
        //Diffbot API test
        DiffbotAPIClient.apiRequest(DiffbotArticleRequest, urlString: source_url, optionalArgs: nil, format: DiffbotAPIFormatJSON) { (success: Bool, result: AnyObject?) in
            if (success) {
                print("success")
                //print(result)
                if let dict = result as! NSDictionary? {
                    if let objects = dict["objects"] as! NSArray? {
                        let info = objects[0] as! NSDictionary
                        if let title = info["title"] {
                            self.articleTitle = title as! String
                        }
                        if let author = info["author"] {
                            self.articleAuthor = author as! String
                        }
                        if let date = info["date"] {
                            self.articlePublication = date as! String
                        }
                    }
                    
                }
                self.viewDidAppear(false)
            } else {
                print("error")
            }
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.titleLabel.text = articleTitle
        self.authorLabel.text = articleAuthor
        self.publicationLabel.text = articlePublication
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

