//
//  MusicViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 26/03/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CDAlertView
import MapleBacon

class MusicViewController: UIViewController {
    
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var nameAlbum: UILabel!
    @IBOutlet weak var imgAlbum: UIImageView!
    var parameters : [String : String] = [:]
     let url1 = "http://193.95.44.118/lyrics/addShareRecord.php"
    let url = "http://193.95.44.118/lyrics/deleteRecord.php"
   var shares : JSON  = []
    var page : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor("#FF475C")

        if(page == "music")
        {
        if (self.shares["id_record"] == [] )
        {
            shareBtn.isHidden = true
            deleteBtn.isHidden = true
        nameAlbum.text = shares["id_song"][0]["album"][0]["name"].stringValue
        nameSong.text = shares["id_song"][0]["title"].stringValue
            if let imageUrl = URL(string:shares["id_song"][0]["album"][0]["picture"].stringValue),let placeholder = UIImage(named: "placeholder") {
                imgAlbum.setImage(withUrl: imageUrl , placeholder: placeholder)
            }
      /*  let url1 = NSURL(string:shares["id_song"][0]["album"][0]["picture"].stringValue)
        let data1 = NSData(contentsOf:url1! as URL)
        imgAlbum.image = UIImage(data : data1! as Data)*/
        }
        else
        {
            imgAlbum.image = UIImage(named: "default_record")
            nameAlbum.text = "No album"
            
            nameSong.text = shares["id_record"][0]["title"].stringValue

        }
        }
        else {
            shareBtn.isHidden = false
            deleteBtn.isHidden = false
            nameSong.text = self.shares["title"].stringValue
            nameAlbum.text = "No Album"
            imgAlbum.image = UIImage(named: "default_record")
        }
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
            let sv:MusicPlayerViewController=segue.destination as! MusicPlayerViewController
            sv.shares = self.shares
        sv.page = self.page
            
        
    }

    @IBAction func share(_ sender: Any) {
        parameters = [
            "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
            "id_record" : shares["id"].stringValue
        ]
        Alamofire.request(url1,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                if(value as! NSNumber == 0)
                {
                    
                    let alert = CDAlertView(title: " Failed ", message: "Error in sharing record", type: .error  )
                    alert.alertBackgroundColor = UIColor("#333333")
                    alert.actionSeparatorColor = UIColor("#FF475C")
                    alert.tintColor = UIColor("#FF475C")
                    alert.titleTextColor = UIColor.white
                    alert.messageTextColor = UIColor.white
                    let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                    doneAction.buttonTextColor = UIColor("#FF475C")
                    alert.add(action: doneAction)
                    alert.show()
                    
                }
                else
                {
                    let alert = CDAlertView(title: "Success", message: "You share the record", type: .notification  )
                    alert.alertBackgroundColor = UIColor("#333333")
                    alert.actionSeparatorColor = UIColor("#FF475C")
                    alert.tintColor = UIColor("#FF475C")
                    alert.titleTextColor = UIColor.white
                    alert.messageTextColor = UIColor.white
                    let doneAction = CDAlertViewAction(title: "Sure! 💪")
                    doneAction.buttonTextColor = UIColor("#FF475C")
                    alert.add(action: doneAction)
                    alert.show()
                    
                  
                }
            case .failure(let error) :
                let alert = CDAlertView(title: " Failed ", message: "Try later", type: .error  )
                alert.alertBackgroundColor = UIColor("#333333")
                alert.actionSeparatorColor = UIColor("#FF475C")
                alert.tintColor = UIColor("#FF475C")
                alert.titleTextColor = UIColor.white
                alert.messageTextColor = UIColor.white
                let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                doneAction.buttonTextColor = UIColor("#FF475C")
                alert.add(action: doneAction)
                alert.show()
                
                print(error)
            }
        }

    }
    @IBAction func deleteRecord(_ sender: Any) {
        parameters = [
            "id_record" : shares["id"].stringValue
        ]
       
        Alamofire.request(url,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                if(value as! NSNumber == 0)
                {
                    
                    let alert = CDAlertView(title: " Failed ", message: "Error in deleting record", type: .error  )
                    alert.alertBackgroundColor = UIColor("#333333")
                    alert.actionSeparatorColor = UIColor("#FF475C")
                    alert.tintColor = UIColor("#FF475C")
                    alert.titleTextColor = UIColor.white
                    alert.messageTextColor = UIColor.white
                    let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                    doneAction.buttonTextColor = UIColor("#FF475C")
                    alert.add(action: doneAction)
                    alert.show()
                    
                }
                else
                {
                    let alert = CDAlertView(title: "Success", message: "You delete the record", type: .notification  )
                    alert.alertBackgroundColor = UIColor("#333333")
                    alert.actionSeparatorColor = UIColor("#FF475C")
                    alert.tintColor = UIColor("#FF475C")
                    alert.titleTextColor = UIColor.white
                    alert.messageTextColor = UIColor.white
                    let doneAction = CDAlertViewAction(title: "Sure! 💪")
                    doneAction.buttonTextColor = UIColor("#FF475C")
                    alert.add(action: doneAction)
                    alert.show()
                    
                    
                }
            case .failure(let error) :
                let alert = CDAlertView(title: " Failed ", message: "Try later", type: .error  )
                alert.alertBackgroundColor = UIColor("#333333")
                alert.actionSeparatorColor = UIColor("#FF475C")
                alert.tintColor = UIColor("#FF475C")
                alert.titleTextColor = UIColor.white
                alert.messageTextColor = UIColor.white
                let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                doneAction.buttonTextColor = UIColor("#FF475C")
                alert.add(action: doneAction)
                alert.show()
                
                print(error)
            }
        }

        
    }
    

}
