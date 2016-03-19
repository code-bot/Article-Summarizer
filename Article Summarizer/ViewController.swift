//
//  ViewController.swift
//  Article Summarizer
//
//  Created by Sahaj Bhatt on 3/11/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Diffbot API test
//        DiffbotAPIClient.apiRequest(DiffbotAnalyzeRequest, urlString: "http://www.cnn.com/2016/03/17/us/seaworld-last-generation-of-orcas/index.html", optionalArgs: nil, format: DiffbotAPIFormatJSON) { (success: Bool, result: AnyObject?) in
//            if (success) {
//                print("success")
//                print(result)
//            } else {
//                print("error")
//            }
//        }
        
        let source_url = "http://www.cnn.com/2016/03/17/us/seaworld-last-generation-of-orcas/index.html"
        
        AylienSummarizerClient.summarize(source_url, params: nil) { (succeeded, data) -> () in
            if (succeeded) {
                print("success")
                print(data)
            } else {
                print("failure")
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

