# Article-Summarizer
## Steps to Run the Application
- Download the zip file
- Within the downloaded folder, open the "SummarizerExtension" folder
- Open "AylienSummarizerClient.swift" located in the "AylienSummarizerClient" folder using any text editor
- At the top of the code, in the "API constants" section, add the AYLIEN App Key and App ID found in your Dashboard after logging into the AYLIEN Text Analysis website (https://developer.aylien.com). After adding the credentials, save the file and close it. **Make sure to remove "<>" angle brackets when adding the credentials**
```
//
//  AylienSummarizerClient.swift
//  Article Summarizer
//
//  Client that uses GET Requests to access the AYLIEN Text Analysis API
//
//  Created by Sahaj Bhatt on 3/18/16.
//  Copyright © 2016 Sahaj Bhatt. All rights reserved.
//

import UIKit

//API constants
let AYLIEN_TextAPI_App_Key = "<INSERT API KEY>"
let AYLIEN_TextAPI_App_ID = "<INSERT APP ID>"
let AYLIEN_Base_URL = "https://api.aylien.com/api/v1"
```
- Open "DiffbotArticleClient.swift" located in the "DiffbotArticleClient" folder using any text editor
- At the top of the code, in the "API constants" section, add the Diffbot API Token found in your email after signing up for the Diffbot 2-week Free trial or in your dashboard if you are already logged into the Diffbot website (https://www.diffbot.com). After adding the credentials, save the file and close it. **Make sure to remove "<>" angle brackets when adding the credentials**
```
  //
  //  DiffbotArticleClient.swift
  //  Article Summarizer
  //
  //  Client that uses GET Requests to access the Diffbot API
  //
  //  Created by Sahaj Bhatt on 3/20/16.
  //  Copyright © 2016 Sahaj Bhatt. All rights reserved.
  //
  
  import UIKit
  
  //API constants
  let Diffbot_API_Token = "<INSERT DIFFBOT API TOKEN>"
  let Diffbot_Base_URL = "http://api.diffbot.com/v3/article"
```
- Return to the root folder and open "ArticleSummarizer.xcodeproj"
- On the top bar, next to the play and stop button, select the target and set it to "Article Summarizer"
<img width="362" alt="screen shot 2016-03-26 at 11 22 10 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063728/0acd834a-f3ac-11e5-9530-7eee9d722e23.png">  
<img width="596" alt="screen shot 2016-03-26 at 11 22 25 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063715/07b7573a-f3ac-11e5-9a6c-b2650d692f7f.png">
- Next to that, set the platform to one of the latest simulators or your own device if you have your iphone plugged into the laptop via a USB cord.
- Finally, hit the play button to run the app in a simulator or your own device

**If Running App on your Own Device**  
After hitting the play button, xcode should download the app to your phone. If the app runs into a signing error while running/downloading, hit fix signing error. If after downloading the app, you still cannot open it, make sure that my developer account is trusted. To check, open the Settings App and click on the "General" tab. Scroll down to the "Device Management" tab and click on my account(sahajb97@gmail.com). You should see the "Article Summarizer" app listed. Hit "Trust" to enable your device to open my app.

## App Overview
When first opening the app, you should see an empty table, labeled "Saved Articles". This screen will show any articles that you have previously summarized and want to see again.  
<img width="376" alt="screen shot 2016-03-26 at 11 23 35 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063717/07b9a9d6-f3ac-11e5-9f88-8556f9464f31.png">  

To actually **summarize** an article, open Safari and find any online article. When on the article page, tap the share button to open a list of extension.  
<img width="376" alt="screen shot 2016-03-26 at 11 24 47 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063718/07bb09de-f3ac-11e5-9184-42aa515cfde9.png">  
In the bottom most row, scroll until you find an action extension labeled "Summarizer Extension."  
<img width="374" alt="screen shot 2016-03-26 at 11 25 09 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063714/07b65de4-f3ac-11e5-9609-24e8b8c4e10a.png">  
<img width="354" alt="screen shot 2016-03-26 at 11 25 52 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063720/07bfa2d2-f3ac-11e5-94f5-7c5d50fb64e0.png">  

If the app extension cannot be seen, hit "More" and switch "Summarizer Extension" on.  
<img width="375" alt="screen shot 2016-03-26 at 11 25 24 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063716/07b8ca02-f3ac-11e5-9c2c-184985e98a19.png">
<img width="373" alt="screen shot 2016-03-26 at 11 25 42 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063719/07be21fa-f3ac-11e5-8111-d2551115927a.png">

After tapping the "Summarizer Extension," you should see a page that says "Loading Summary."  
<img width="375" alt="screen shot 2016-03-26 at 11 28 15 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063721/07c12bb6-f3ac-11e5-9d29-ffd5543152dd.png">  
This page will load the summary, gather additional information regarding the article, and save the article for future viewing. It may take a long time to load the summary depending on the internet connection speed with the APIs. If it encounters any errors while loading the summary, the extension will be closed. Otherwise, just wait until the loading is complete. Once everything is loaded, a new page will appear with the article title, author, publication information, and summary.  
<img width="373" alt="screen shot 2016-03-26 at 11 37 26 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063722/07c297e4-f3ac-11e5-905f-77413538a265.png">  
If further author information is available, the author text will be colored blue and tapping on it will lead to another page which provides further information on the author.  
<img width="373" alt="screen shot 2016-03-26 at 11 37 51 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063723/07c336fe-f3ac-11e5-9c16-0d7ad93aa334.png">  
Furthermore, words important to the topic of the article are made into hyperlinks that provide further information on the specific key word. Tapping on the hyperlink will open another page as well with the additional information.  
<img width="372" alt="screen shot 2016-03-26 at 11 38 11 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063724/07c4609c-f3ac-11e5-9ba8-9d048d8783ea.png">  
Once you are done with the summary, tap "Done" and the app extension will close. Now, you can continue browsing more articles and create more summaries, or you can return to the main application. If you open the app once again, you should notice that the table is populated with all of the articles that you successfully summarized using the app extension.  
<img width="373" alt="screen shot 2016-03-26 at 11 38 29 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063725/07c597b4-f3ac-11e5-9243-d8bceb4548fc.png">  
Tapping on any of the articles in the table will lead to a familiar page with the article title, author, publication, and summary. Once again, tapping any of the blue text will provide further information on the topics. All of these summaries are accessible offline as they are stored locally. However, the additional information regarding the author and key words is only accessible with internet access.  
<img width="374" alt="screen shot 2016-03-26 at 11 38 37 pm" src="https://cloud.githubusercontent.com/assets/11774230/14063726/07c6b20c-f3ac-11e5-94d9-017a00ac0241.png">  
**Unfortunately**, not all articles can be summarized by the AYLIEN API as discovered when going through multiple tests regarding the summarized data.  



