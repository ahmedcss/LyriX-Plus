//
//  SignUpController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 16/02/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import CDAlertView
import Alamofire
import UIColor_Hex_Swift

class SignUpController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var txtusername: UITextField!
    
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var txtconfirmPasswod: UITextField!
    
    

    var server:String="http://193.95.44.118/lyrics/"
    var isUsernameValid:Bool = true
    var isUsernameNonEmpty:Bool = false
    var isPasswordNonEmpty:Bool = false
    var isConfirmPasswordNonEmpty:Bool = false
    var isPasswordsMatching:Bool = false
    var isEmailNonEmpty:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        txtusername.delegate = self
        txtusername.addTarget(self, action: #selector(self.textFieldDidChange(textView:)), for: .editingChanged)
        
        btn.layer.cornerRadius = 7
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        /*
         txtusername.attributedPlaceholder = NSAttributedString(string: "Username",
         attributes: [NSForegroundColorAttributeName: UIColor.gray])
         txtemail.attributedPlaceholder = NSAttributedString(string: "Email",
         attributes: [NSForegroundColorAttributeName: UIColor.gray])
         txtpassword.attributedPlaceholder = NSAttributedString(string: "Password",
         attributes: [NSForegroundColorAttributeName: UIColor.gray])
         txtconfirmPasswod.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
         attributes: [NSForegroundColorAttributeName: UIColor.gray])
         */
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidChange(textView: UITextView) { //Handle the text changes here
        //print(textView.text); //the textView parameter is the textView where text was changed
        
        let usr:String = textView.text!
        
        
        self.validUsername(usernam: usr)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func displayAlertMessage(messageToDisplay: String)
    {
        let alert = CDAlertView(title: "Alert", message: messageToDisplay , type: .error)
        let doneAction = CDAlertViewAction(title: "Nevermind 😑")
        alert.add(action: doneAction)
        alert.show()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sev:UploadPicture =  segue.destination as! UploadPicture
        sev.username = txtusername.text!
        sev.email = txtemail.text!
        sev.password = txtpassword.text!
    }

    func validUsername(usernam:String){
        
        let urlString = self.server + "validusername.php"
        
        Alamofire.request(urlString, method: .post, parameters: ["username": usernam]).responseString {
            response in
            switch response.result {
            case .success:
                //print(response)
                //print (response.description)
                if response.description == "SUCCESS: \"no\""{
                    print("invalid username")
                    self.isUsernameValid = false
                    self.displayAlertMessage(messageToDisplay: "this Username is already taken, please choose another one")
                }else{
                    print("valid username")
                    self.isUsernameValid = true
                }
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
    }

    @IBAction func btnRegistre(_ sender: Any) {
        let username = txtusername.text
        let email = txtemail.text
        let password = txtpassword.text
        let confPass = txtconfirmPasswod.text
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: email!)
        
        
        if (username != ""){
            self.isUsernameNonEmpty = true
        }else{
            self.isUsernameNonEmpty = false
            displayAlertMessage(messageToDisplay: "Username field is empty !")
        }
        
        if(!isUsernameValid){
            displayAlertMessage(messageToDisplay: "This username is already Taken, please choose another one !")
        }
        
        if (email != ""){
            self.isEmailNonEmpty = true
        }else{
            self.isEmailNonEmpty = false
            displayAlertMessage(messageToDisplay: "Email field is empty !")
        }
        
        if (password != ""){
            self.isPasswordNonEmpty = true
        }else{
            self.isPasswordNonEmpty = false
            displayAlertMessage(messageToDisplay: "Password field is empty !")
        }
        
        if (confPass != ""){
            self.isConfirmPasswordNonEmpty = true
        }else{
            self.isConfirmPasswordNonEmpty = false
            displayAlertMessage(messageToDisplay: "Confirm password field is empty !")
        }
        
        if (confPass == password){
            self.isPasswordsMatching = true
        }else{
            self.isPasswordsMatching = false
            
            displayAlertMessage(messageToDisplay: "Passwords doesn't match !")
        }
        
        if (isEmailAddressValid && isUsernameValid && isPasswordsMatching && isPasswordNonEmpty && isConfirmPasswordNonEmpty && isEmailNonEmpty && isUsernameNonEmpty)
        {
            
            print("everything is ok")
            
            self.performSegue(withIdentifier: "uploadSegue", sender: self)
        } else {
            print("Email address is not valid")
            displayAlertMessage(messageToDisplay: "Non valid Form !")
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
