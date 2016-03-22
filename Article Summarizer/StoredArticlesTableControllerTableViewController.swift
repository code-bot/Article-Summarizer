//
//  StoredArticlesTableController.swift
//  Article Summarizer
//
//  Created by Sahaj Bhatt on 3/21/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit

class StoredArticlesTableController: UITableViewController {

    var storedInfo: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myDefaults = NSUserDefaults(suiteName: "group.com.sahajbhatt.Article-Summarizer")
        storedInfo = myDefaults?.objectForKey("urls") as? [NSDictionary]
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        let myDefaults = NSUserDefaults(suiteName: "group.com.sahajbhatt.Article-Summarizer")
        storedInfo = myDefaults?.objectForKey("urls") as? [NSDictionary]
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (storedInfo == nil) {
            return 0
        } else {
            return storedInfo!.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! StoredArticlesTableViewCell
        
        let article = storedInfo![indexPath.row]
        cell.titleLabel.text = article["title"] as? String
        cell.authorLabel.text = article["author"] as? String
        cell.dateLabel.text = article["date"] as? String
        

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //Change height of table cell based on height of the text of the title
        let article = storedInfo![indexPath.row]
        let articleTitle = article["title"] as! String
        let attributedText = NSAttributedString(string: articleTitle, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(24)])
        return attributedText.boundingRectWithSize(CGSizeMake(tableView.bounds.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).height + 40
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("loadSummary", sender: storedInfo![indexPath.row]["url"] as! String)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? LoadingController {
            vc.sourceUrl = sender as! String
        }
    }

}
