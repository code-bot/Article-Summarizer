//
//  StoredArticlesTableController.swift
//  Article Summarizer
//
//  Shows a table with all articles stored on the phone
//
//  Created by Sahaj Bhatt on 3/21/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit

class StoredArticlesTableController: UITableViewController {
    
    var storedInfo: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set table view design settings
        self.tableView.separatorInset = UIEdgeInsetsZero
        //Get articles stored on the device and reload tableview
        let myDefaults = NSUserDefaults(suiteName: "group.com.sahajbhatt.Article-Summarizer")
        storedInfo = myDefaults?.objectForKey("urls") as? [NSDictionary]
        
        tableView.reloadData()
    }
    
    //Table will always have one section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Total number of rows in the table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (storedInfo == nil) {
            //Table will have 0 rows if there are no stored articles
            return 0
        } else {
            return storedInfo!.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Cell layout is based on StoredArticlesTableViewCell properites
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! StoredArticlesTableViewCell
        
        //Set cell information
        let article = storedInfo![indexPath.row]
        //Check if image exists
        if let imageUrlStr = article["imageUrl"] as? String {
            if let imageUrl = NSURL(string: imageUrlStr) {
                let imageData = NSData(contentsOfURL: imageUrl)
                if let image = imageData {
                    cell.articleImageView.image = UIImage(data: image)
                }
            }
        }
        cell.titleLabel.text = (article["title"] as! String)
        cell.authorLabel.text = (article["author"] as! String)
        let date = (article["publication"] as! String)
        //Show only date without the other publication information
        cell.dateLabel.text = date.substringWithRange(Range<String.Index>(start: date.endIndex.advancedBy(-16), end: date.endIndex))
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //Change height of table cell based on height of the text of the title and its font and font-size
        let article = storedInfo![indexPath.row]
        var imageHeight = CGFloat(0)
        //Check if the image can be accessed before incrementing height of table
        if let imageUrl = article["imageUrl"] as? String {
            if let _ = NSURL(string: imageUrl) {
                imageHeight = CGFloat(230)
            }
        }
        let articleTitle = article["title"] as! String
        let attributedText = NSAttributedString(string: articleTitle, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(24)])
        return attributedText.boundingRectWithSize(CGSizeMake(tableView.bounds.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).height + 40 + imageHeight
        
    }
    
    //Once an article is selected from the table, show its summary
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showSummary", sender: storedInfo![indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Transfer information from stored data to SummaryController
        if let vc = segue.destinationViewController as? SummaryController {
            let info = sender as! NSDictionary
            vc.sourceUrl = info["url"] as! String
            vc.articleTitle = info["title"] as! String
            vc.articleAuthor = info["author"] as! String
            vc.authorUrl = info["authorUrl"] as! String
            vc.articlePublication = info["publication"] as! String
            vc.summaryHTML = info["summary"] as! String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
