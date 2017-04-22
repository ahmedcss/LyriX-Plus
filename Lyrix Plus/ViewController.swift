//
//  ViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 02/02/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import CDAlertView
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import UIColor_Hex_Swift

class ViewController: UIViewController {

    let url = "http://193.95.44.118/lyrics/Login.php"
    let url1 = "http://193.95.44.118/lyrics/addFacebook.php"
    let url2 = "http://193.95.44.118/lyrics/LoginFacebook.php"
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
  
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var LoginFb: UIButton!
    @IBOutlet weak var signUp: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        LoginButton.layer.cornerRadius = 20
        LoginFb.layer.cornerRadius = 20
        signUp.layer.cornerRadius = 20
       
       
                 }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Login(_ sender: Any) {
        if (userTextField.text == "" || passTextField.text == "")
        {
        let alert = CDAlertView(title: "Alert", message: "You must enter username and password", type: .warning)
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
        else {
            
        
        SwiftSpinner.show("Loging In...")
        let parameters: [String: String] = [
            "username" : userTextField.text! ,
            "password" : passTextField.text! ,
        ]
        
        Alamofire.request(url,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
               let json1 = JSON(value)
               if json1.arrayObject?.count == 0 {
                SwiftSpinner.hide()
                let alert = CDAlertView(title: "Alert", message: "bad username or password" , type: .error)
                let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                alert.add(action: doneAction)
                alert.show()
                self.userTextField.text = ""
                self.passTextField.text = ""
               }else{
                SwiftSpinner.hide()
                
             //   print(json1[0]["username"].stringValue)
               SharedPreferences.sharedpref.setSharedprefs(email:json1[0]["email"].stringValue,id:json1[0]["id"].stringValue,username:json1[0]["username"].stringValue,gender:json1[0]["gender"].stringValue, birthday: json1[0]["birthday"].stringValue,location: json1[0]["location"].stringValue,fullName : json1[0]["fullname"].stringValue , picture : json1[0]["picture"].stringValue ,password : json1[0]["password"].stringValue,isLogged:1)
                UserDefaults.init(suiteName: "group.Lyrix")?.setValue(json1[0]["username"].stringValue , forKey: "username")
                                //self.navigationController?.pushViewController(view, animated: true)
                self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error) :
                SwiftSpinner.hide()
                let alert = CDAlertView(title: "Alert", message: "we have a server problem we will fix it" , type: .error)
                let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                alert.add(action: doneAction)
                alert.show()
                
                print(error)
            }
            }
            
        }

    }
   
    @IBAction func fbloginBtn(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.Type(large), email,gender,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let json1 = JSON(result as Any)
                   
                
                    SwiftSpinner.show("Loging In...")
                    let parameters1: [String: String] = [
                        "id_fb" : json1["id"].stringValue ,
                    
                        ]
                    
                    Alamofire.request(self.url2,method : .post , parameters : parameters1).responseJSON {
                        response in
                        switch response.result {
                            
                        case .success(let value) :
                            let json2 = JSON(value)
                            if json2.arrayObject?.count == 0 {
                               
                                let parameters: [String: String] = [
                                    "id_fb" : json1["id"].stringValue ,
                                    "name" : json1["name"].stringValue ,
                                    "gender" : json1["gender"].stringValue,
                                    "location" : "",
                                    "birthday" : "",
                                    "email" : json1["email"].stringValue,
                                    "picture" : json1["picture"]["data"]["url"].stringValue,
                                    ]
                                
                                Alamofire.request(self.url1,method : .post , parameters : parameters).responseJSON {
                                    response in
                                    switch response.result {
                                        
                                    case .success(let value) :
                                        if(value as! NSNumber == 1)
                                        {
                                         SwiftSpinner.hide()
                                
        SharedPreferences.sharedpref.setSharedprefs(email:json1["email"].stringValue,id:json2[0]["id"].stringValue,username:json1["first_name"].stringValue,gender:json1["gender"].stringValue, birthday: json1["birthday"].stringValue,location: "",fullName : json1["name"].stringValue , picture : json1["picture"]["data"]["url"].stringValue ,password : "" ,isLogged:1)
                                         
                                         UserDefaults.init(suiteName: "group.Lyrix")?.setValue(json1["username"].stringValue , forKey: "username")
                                         self.dismiss(animated: true, completion: nil)

                                        
                                        }
                                        else {
                                             SwiftSpinner.hide()
                                        }
                                    case .failure(let error) :
                                         SwiftSpinner.hide()
                                        print(error)
                                    }
                                }

                            }else{
                                SwiftSpinner.hide()
                        SharedPreferences.sharedpref.setSharedprefs(email:json1["email"].stringValue,id:json2[0]["id"].stringValue,username:json1["first_name"].stringValue,gender:json1["gender"].stringValue, birthday: json1["birthday"].stringValue,location: "",fullName : json1["name"].stringValue , picture : json1["picture"]["data"]["url"].stringValue ,password : "" ,isLogged:1)
                                UserDefaults.init(suiteName: "group.Lyrix")?.setValue(json1[0]["username"].stringValue , forKey: "username")
                                self.dismiss(animated: true, completion: nil)
                            }
                        case .failure(let error) :
                            SwiftSpinner.hide()
                            let alert = CDAlertView(title: "Alert", message: "we have a server problem we will fix it" , type: .error)
                            let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                            alert.add(action: doneAction)
                            alert.show()
                            
                            print(error)
                        }
                    }

                   
                }
            })
        }
    }
    
 
}

