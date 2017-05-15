//
//  UploadPicture.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 2/17/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CDAlertView
import SwiftSpinner
import SystemConfiguration
public class UploadPicture : UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate{

    var username:String=""
    var email:String=""
    var password:String=""
    var server:String="http://193.95.44.118/lyrix/"
    
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var fromCameraBtn: UIButton!
    @IBOutlet weak var fromLibraryBtn: UIButton!
    @IBOutlet weak var imageView:
    UIImageView!
    let picker = UIImagePickerController()
    
    
    @IBAction func ChooseFromCamera(_ sender: Any)
     {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: true,completion: nil)
        
    }
    
    @IBAction func ChooseFrom(_ sender: Any) {
        
        fromLibraryBtn.isHidden = false
        fromCameraBtn.isHidden = false
    }
    
    
    @IBAction func ChooseFromLibrary(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    @IBAction func btnUpload(_ sender: Any) {
        
        if (self.isInternetAvailable()){
            if (self.imageView.image != nil){
                
                SwiftSpinner.show("Uploading Picutre...")
                let data = UIImageJPEGRepresentation(self.imageView.image!, 1)!
                
                let usernameParam = self.username.data(using: String.Encoding.utf8)!
                let emailParam = self.email.data(using: String.Encoding.utf8)!
                let passwordParam = self.password.data(using: String.Encoding.utf8)!
                let serverParam = self.server.data(using: String.Encoding.utf8)!
                
               
                
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
                        multipartFormData.append(usernameParam, withName: "username")
                        multipartFormData.append(emailParam, withName: "email")
                        multipartFormData.append(passwordParam, withName: "password")
                        multipartFormData.append(serverParam, withName: "server")
                },
                    to: self.server + "signup.php",
                    
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                debugPrint(response)
                                SwiftSpinner.hide()
                                print(response.description)
                                if response.description == "SUCCESS: 1"{
                                    CDAlertView(title: "Upload", message: "Image Sucessfully Uploaded !", type: .success).show()
                                    
                                    self.performSegue(withIdentifier: "toMusicSegue", sender: self)
                                }else{
                                    CDAlertView(title: "Upload", message: "Upload Image Failed !", type: .error).show()
                                }
                                
                                
                                
                                
                                
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                            
                            SwiftSpinner.hide()
                        }
                }
                )
            }else{
                //self.performSegue(withIdentifier: "TopSongSegue", sender: self)
                
                
                let alert = CDAlertView(title: "Alert", message: "You have to choose a picture first" , type: .error)
                let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                alert.add(action: doneAction)
                alert.show()
                
                
            }
        }else{
            let alert = CDAlertView(title: "Alert", message: "No Internet Available" , type: .error)
            let doneAction = CDAlertViewAction(title: "Try again")
            alert.add(action: doneAction)
            alert.show()
        }
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.contentMode = .scaleAspectFit //3
        imageView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        picker.delegate = self
        fromLibraryBtn.isHidden = true
        fromCameraBtn.isHidden = true
        fromLibraryBtn.layer.cornerRadius = 7
        fromCameraBtn.layer.cornerRadius = 7
        uploadBtn.layer.cornerRadius = 7
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

    
   
        
        
    
 
