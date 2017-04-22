//
//  MyTabBarViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 18/04/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import NotificationCenter

class MyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.selectedIndex = 2;
        NotificationCenter.default.addObserver(self, selector: #selector(MyTabBarViewController.notifyBottomBar), name: NSNotification.Name(rawValue: "notif"), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func notifyBottomBar()
    {
        print("heey")
        self.selectedIndex = 2;

    }
}
