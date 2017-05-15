//
//  UpdateImageViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 26/04/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import CDAlertView

class UpdateImageViewController: UIViewController ,  UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    var username : String = ""
    let server : String = "http://193.95.44.118/lyrics/"
    var img : String  = ""
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var fromCameraBtn: UIButton!
    @IBOutlet weak var fromLibraryBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    let picker = UIImagePickerController()
    
    @IBAction func ChooseFromCamera(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: true,completion: nil)
        uploadBtn.isEnabled = true
    }
    
    @IBAction func ChooseFrom(_ sender: Any) {
        fromLibraryBtn.isHidden = false
        fromCameraBtn.isHidden = false
        
    }
    

    
    @IBAction func btnUpload(_ sender: Any) {
        if (self.imageView.image != nil){
            
            SwiftSpinner.show("Uploading Picutre...")
            let data = UIImageJPEGRepresentation(self.imageView.image!, 1)!
             print ("data :",data)
            let usernameParam = self.username.data(using: String.Encoding.utf8)!
          
            let serverParam = self.server.data(using: String.Encoding.utf8)!
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
                    multipartFormData.append(usernameParam, withName: "username")
                    multipartFormData.append(serverParam, withName: "server")
            },
                to: self.server + "updateImage.php",
                
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                            SwiftSpinner.hide()
                          
                                                        if response.description == "SUCCESS: 1"{
                                CDAlertView(title: "Upload", message: "Image Sucessfully Uploaded !", type: .success).show()
                                self.dismiss(animated: true, completion: nil)
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
            
           // self.performSegue(withIdentifier: "TopSongSegue", sender: self)
            
           
             let alert = CDAlertView(title: "Alert", message: "You have to choose a picture first" , type: .error)
             let doneAction = CDAlertViewAction(title: "Nevermind 😑")
             alert.add(action: doneAction)
             alert.show()
            
            
        }
        
    }
    
    
    
    
    
    
    
     func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        self.imageView.contentMode = .scaleAspectFit //3
        self.imageView.image = chosenImage //4
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
        uploadBtn.isEnabled = false
        username = SharedPreferences.sharedpref.prefs.string(forKey: "username")! as String
        if let imageUrl = URL(string:img) , let placeholder = UIImage(named: "placeholder"){
            imageView.setImage(withUrl: imageUrl , placeholder: placeholder)
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func ChooseLibrary(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
        uploadBtn.isEnabled = true

    }
    
    @IBAction func Back(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
}

