//
//  ProfilViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 02/02/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import UIColor_Hex_Swift
import CDAlertView
import MapleBacon


class ProfilViewController: UIViewController,SPSegmentControlCellStyleDelegate, SPSegmentControlDelegate {
   
    @IBOutlet weak var btnUpdateImage: UIButton!
    @IBOutlet weak var profilImage: UIImageView!
    private let borderColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.5)
   private let backgroundColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.08)
    
    @IBOutlet weak var segmentedControl: SPSegmentedControl!
    
    @IBOutlet weak var locationText: UITextField!
   
    @IBOutlet weak var usernameText: UITextField!
   
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var birthdayText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var fullnameText: UILabel!
    @IBOutlet weak var passwordText: UITextField!
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let url = "http://193.95.44.118/lyrics/editProfil.php"
    let url1 = "http://193.95.44.118/lyrics/validusername.php"
    
    @IBOutlet weak var modifBtn: UIButton!
    override func viewDidLoad() {
      
       
        super.viewDidLoad()
        modifBtn.layer.cornerRadius = 20
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor("#FF475C")]
        navigationController?.navigationBar.barTintColor = UIColor("#333333")
        if let imageUrl = URL(string:SharedPreferences.sharedpref.prefs.string(forKey: "picture")!) , let placeholder = UIImage(named: "placeholder"){
            profilImage.setImage(withUrl: imageUrl , placeholder: placeholder)
        }
       /* let url = NSURL(string:SharedPreferences.sharedpref.prefs.string(forKey: "picture")!)
        let data = NSData(contentsOf:url! as URL)
        profilImage.image = UIImage(data : data! as Data)*/
        self.profilImage.layer.cornerRadius = self.profilImage.frame.size.width / 2
        self.profilImage.clipsToBounds = true
       // for segmentedControl in [segmentedControl] {
           segmentedControl?.layer.borderColor = self.borderColor.cgColor
          segmentedControl?.backgroundColor = self.backgroundColor
            segmentedControl?.styleDelegate = self
            segmentedControl?.delegate = self
       // }

        
        locationText.text = SharedPreferences.sharedpref.prefs.string(forKey: "location")! as String
        fullnameText.text = SharedPreferences.sharedpref.prefs.string(forKey: "fullname")! as String
        usernameText.text = SharedPreferences.sharedpref.prefs.string(forKey: "username")! as String
        emailText.text = SharedPreferences.sharedpref.prefs.string(forKey: "email")! as String
        birthdayText.text = SharedPreferences.sharedpref.prefs.string(forKey: "birthday")! as String
        passwordText.text = SharedPreferences.sharedpref.prefs.string(forKey: "password")! as String
        genderText.text = SharedPreferences.sharedpref.prefs.string(forKey: "gender")! as String

        let xFirstCell = self.createCell(
            text: "Profil",
            image: self.createImage(withName: "profil")
        )
        let xSecondCell = self.createCell(
            text: "Edit",
            image: self.createImage(withName: "ic_image_edit")
        )
       /* let xThirdCell = self.createCell(
            text: "Oswald",
            image: self.createImage(withName: "wind-sign")
        )*/
        for cell in [xFirstCell, xSecondCell] {
            cell.layout = .textWithImage
            self.segmentedControl.add(cell: cell)
        
        }
      
       



    }
    
    private func createCell(text: String, image: UIImage ) -> SPSegmentedControlCell {
        let cell = SPSegmentedControlCell.init()
        cell.label.text = text
        cell.label.font = UIFont(name: "Avenir-Medium", size: 13.0)!
        cell.imageView.image = image
        return cell
    }
    
    private func createImage(withName name: String) -> UIImage {
        return UIImage.init(named: name)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
    
    func selectedState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor("#FF475C")
          

        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor("#FF475C")
        }, completion: nil)
          indicatorViewRelativPosition(position: CGFloat(index), onSegmentControl: segmentedControl)
    }
    
    func normalState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.white
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.white
        }, completion: nil)
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorViewRelativPosition(position: CGFloat, onSegmentControl segmentControl: SPSegmentedControl) {
        if(position==1)
        {
      
             modifBtn.isHidden = false
            usernameText.isUserInteractionEnabled = true
            locationText.isUserInteractionEnabled = true
            emailText.isUserInteractionEnabled = true
            birthdayText.isUserInteractionEnabled = true
            passwordText.isUserInteractionEnabled = true
            genderText.isUserInteractionEnabled = true
            btnUpdateImage.isHidden = false
            
            usernameText.layer.cornerRadius = 10
            locationText.layer.cornerRadius = 10
            emailText.layer.cornerRadius = 10
            birthdayText.layer.cornerRadius = 10
            passwordText.layer.cornerRadius = 10
            genderText.layer.cornerRadius = 10
            
            usernameText.backgroundColor = UIColor("#494949")
            locationText.backgroundColor = UIColor("#494949")
            emailText.backgroundColor = UIColor("#494949")
            birthdayText.backgroundColor = UIColor("#494949")
            passwordText.backgroundColor = UIColor("#494949")
            genderText.backgroundColor = UIColor("#494949")
            
          
            
            
        }
        else
        {
            modifBtn.isHidden = true
            btnUpdateImage.isHidden = true
            usernameText.isUserInteractionEnabled = false
            locationText.isUserInteractionEnabled = false
            emailText.isUserInteractionEnabled = false
            birthdayText.isUserInteractionEnabled = false
            passwordText.isUserInteractionEnabled = false
            genderText.isUserInteractionEnabled = false
            
            usernameText.backgroundColor = UIColor.clear
            locationText.backgroundColor = UIColor.clear
            emailText.backgroundColor = UIColor.clear
            birthdayText.backgroundColor = UIColor.clear
            passwordText.backgroundColor = UIColor.clear
            genderText.backgroundColor = UIColor.clear
           
            
            

        }
           }



    @IBAction func updateProfil(_ sender: Any) {
       
        let parameters: [String: String] = [
            "username" : usernameText.text! ,
            "password" : passwordText.text! ,
            "id" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
            "email" : emailText.text! ,
            "gender" : genderText.text! ,
            "birthday" : birthdayText.text! ,
            "location" : locationText.text! ,
            
            
            ]
        
        let parameters1: [String: String] = [
            "username" : usernameText.text! ,
]
        
        let alert = UIAlertController(title: "Alert", message: "Are u sure ?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            SwiftSpinner.show("Loading...")
            
            Alamofire.request(self.url1,method : .post , parameters : parameters1).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    if value as! String == "no" {
                        SwiftSpinner.hide()
                        let alert = CDAlertView(title: "Alert", message: "Username existe , try an other username", type: .warning  )
                        alert.alertBackgroundColor = UIColor("#333333")
                        alert.actionSeparatorColor = UIColor("#FF475C")
                        alert.tintColor = UIColor("#FF475C")
                        alert.titleTextColor = UIColor.white
                        alert.messageTextColor = UIColor.white
                        let doneAction = CDAlertViewAction(title: "Sure! 💪")
                        doneAction.buttonTextColor = UIColor("#FF475C")
                        alert.add(action: doneAction)
                        alert.show()
                        
                        
                        
                        
                       
                    }else{
                       
                        Alamofire.request(self.url,method : .post , parameters : parameters).responseJSON {
                            response in
                            switch response.result {
                                
                            case .success(let value) :
                                if value as! NSNumber == 0 {
                                    SwiftSpinner.hide()
                                    print("not found")
                                }else{
                                    SwiftSpinner.hide()
                                    SharedPreferences.sharedpref.setSharedprefs(email:self.emailText.text!,id:SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String,username:self.usernameText.text!,gender:self.genderText.text!, birthday: self.birthdayText.text!,location: self.locationText.text!,fullName : self.fullnameText.text! , picture : SharedPreferences.sharedpref.prefs.string(forKey: "picture")! ,password : self.passwordText.text!,isLogged:1)
                                    
                                    
                                    
                                }
                            case .failure(let error) :
                                SwiftSpinner.hide()
                                print(error)
                            }
                            
                            
                        }
                        
                    }
                case .failure(let error) :
                    SwiftSpinner.hide()
                    print(error)
                }
                
                
            }

            
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        alert.view.backgroundColor = UIColor("#333333")
        alert.view.tintColor = UIColor("#FF475C")
        
        
        

    }
    @IBAction func Logout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Alert", message: "Are u sure to logout ?", preferredStyle: UIAlertControllerStyle.alert )
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
           SharedPreferences.sharedpref.prefs.set(0, forKey: "ISLOGGEDIN")
              UserDefaults.init(suiteName: "group.Lyrix")?.setValue("" , forKey: "username")
            
            let view2 = self.storyboard?.instantiateViewController(withIdentifier: "login") as! ViewController
            self.tabBarController?.selectedIndex = 0

            DispatchQueue.main.async (execute : {
                
                              self.navigationController?.present(view2, animated: true, completion: nil)
                           })

            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        alert.view.backgroundColor = UIColor("#333333")
        alert.view.tintColor = UIColor("#FF475C")
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let svc:UpdateImageViewController=segue.destination as! UpdateImageViewController
        svc.username = SharedPreferences.sharedpref.prefs.string(forKey: "username")! as String
        svc.img = SharedPreferences.sharedpref.prefs.string(forKey: "picture")!
        
        
    }
   
}
