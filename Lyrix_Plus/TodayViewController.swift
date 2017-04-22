//
//  TodayViewController.swift
//  Lyrix_Plus
//
//  Created by Ahmed Haddar on 17/04/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var hi: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userFromApp = UserDefaults.init(suiteName: "group.Lyrix")?.value(forKey: "username") {
            if String(describing: userFromApp) != "" {
                
            hi.text = "Welcome " + String(describing: userFromApp) + " !"
                 }
            else {
                
            hi.text = "Open app and enjoy it."
            }

        }
        else {
            hi.text = "Open app and enjoy searching and listening to music."
        }
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    @IBAction func openApp(_ sender: Any) {
       
        
        self.extensionContext?.open(URL(string:"Lyrix-Plus://")!, completionHandler:{(success)  in
            if (!success) {
                print("task erreur!")
            }
            else {
                 print("task done!")
              
            }
          })
    }
    
}
