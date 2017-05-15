//
//  AddRecordViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 27/03/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CDAlertView
import Speech
import SwiftSpinner

class AddRecordViewController: UIViewController , RecorderViewDelegate {

    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var lyricsText: UITextView!
    @IBOutlet weak var labelNotice: UILabel!
    let url = "http://193.95.44.118/lyrics/insertRecord.php"
    @IBOutlet weak var save: UIButton!
    var song : JSON = []
    var page : String = ""
    @IBOutlet weak var songText: UITextField!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    var recorderView: RecorderViewController!
    var param : [String:String] = [:]
   
       override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor("#FF475C")]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        recorderView = storyboard.instantiateViewController(withIdentifier: "RecorderViewController") as! RecorderViewController
        recorderView.delegate = self
        recorderView.createRecorder()
      
        recorderView.modalTransitionStyle = .crossDissolve
        recorderView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    
        stopBtn.layer.cornerRadius = 10
        startBtn.layer.cornerRadius = 10
        
        save.layer.cornerRadius = 10
        
         self.navigationController?.navigationBar.tintColor = UIColor("#FF475C")
        if(page == "details")
        {
            songText.text = song["title"].stringValue
            songText.isEnabled = false
            lyricsText.text = "a"
        }
        else {
            songText.isEnabled = true
            labelNotice.text = "Enter The song's title, lyrics and touch play to record your voice then save  "
            
            lyricsText.isHidden = false

        }
    }

    internal func didFinishRecording(_ recorderViewController: RecorderViewController) {
        print(recorderView.recording.url)
    }
    
    @IBAction func start(_ sender: Any) {
        self.present(recorderView, animated: true, completion: nil)
        if(page == "details")
        {
        recorderView.lyricsText.text = song["lyrics"].stringValue
        }
        else {
            recorderView.lyricsText.isHidden = true
        }
        recorderView.startRecording()
        save.isHidden = false
        resetBtn.isHidden = false

    }

    @IBAction func play(_ sender: Any) {
        do {
            try recorderView.recording.play()
        } catch {
            print(error)
        }
    }
   
    @IBAction func save(_ sender: Any) {
       /* if(page == "details")
        {
        parameters = [
            "title" : song["title"].stringValue ,
            "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! ,
            "lyrics" : song["lyrics"].stringValue ,
            ]
            Alamofire.request(url,method : .post , parameters : parameters).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    if(value as! NSNumber == 0)
                    {
                        
                        let alert = CDAlertView(title: " Failed ", message: "Error in saving the record", type: .error  )
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
                        let alert = CDAlertView(title: "Success", message: "You saved the record", type: .notification  )
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
                    let alert = CDAlertView(title: "Erreur", message: "Failed to save", type: .error  )
                    alert.alertBackgroundColor = UIColor("#333333")
                    alert.actionSeparatorColor = UIColor("#FF475C")
                    alert.tintColor = UIColor("#FF475C")
                    alert.titleTextColor = UIColor.white
                    alert.messageTextColor = UIColor.white
                    let doneAction = CDAlertViewAction(title: " Nevermind 😑")
                    doneAction.buttonTextColor = UIColor("#FF475C")
                    alert.add(action: doneAction)
                    alert.show()
                    print(error)
                }
            }
        }
        else {
            if (self.songText.text == "" || self.lyricsText.text == "")
            {
                let alert = CDAlertView(title: " Failed ", message: "Enter Title and lyrics", type: .error  )
                alert.alertBackgroundColor = UIColor("#333333")
                alert.actionSeparatorColor = UIColor("#FF475C")
                alert.tintColor = UIColor("#FF475C")
                alert.titleTextColor = UIColor.white
                alert.messageTextColor = UIColor.white
                let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                doneAction.buttonTextColor = UIColor("#FF475C")
                alert.add(action: doneAction)
                alert.show()

            
            }else {
                parameters = [
                    "title" : self.songText.text! ,
                    "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! ,
                    "lyrics" : self.lyricsText.text ,
                ]
                Alamofire.request(url,method : .post , parameters : parameters).responseJSON {
                    response in
                    switch response.result {
                        
                    case .success(let value) :
                        if(value as! NSNumber == 0)
                        {
                            
                            let alert = CDAlertView(title: " Failed ", message: "Error in saving the record", type: .error  )
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
                            let alert = CDAlertView(title: "Success", message: "You saved the record", type: .notification  )
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
                        let alert = CDAlertView(title: "Erreur", message: "Failed to save", type: .error  )
                        alert.alertBackgroundColor = UIColor("#333333")
                        alert.actionSeparatorColor = UIColor("#FF475C")
                        alert.tintColor = UIColor("#FF475C")
                        alert.titleTextColor = UIColor.white
                        alert.messageTextColor = UIColor.white
                        let doneAction = CDAlertViewAction(title: " Nevermind 😑")
                        doneAction.buttonTextColor = UIColor("#FF475C")
                        alert.add(action: doneAction)
                        alert.show()
                        print(error)
                    }
                }

            }
            
        }*/
       
       //  SwiftSpinner.show("Uploading Record...")
      
        if (self.songText.text == "" || self.lyricsText.text == "")
        {
            let alert = CDAlertView(title: " Failed ", message: "Enter Title and lyrics", type: .error  )
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
     self.mySongUploadRequest()
    }

    @IBAction func reset(_ sender: Any) {
        save.isHidden = true
        resetBtn.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        recorderView = storyboard.instantiateViewController(withIdentifier: "RecorderViewController") as! RecorderViewController
        recorderView.delegate = self
        recorderView.createRecorder()
        
        recorderView.modalTransitionStyle = .crossDissolve
        recorderView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    func mySongUploadRequest()
    {
        SwiftSpinner.show("uploading the song ...")
        let myUrl = NSURL(string: self.url);
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        if(page == "details")
        {
                let title = self.song["title"].stringValue
        let id_user = SharedPreferences.sharedpref.prefs.string(forKey: "id")!
        let lyrics = self.song["lyrics"].stringValue
             param = [
                "title" : "\(title)",
                "id_user" : "\(id_user)",
                "lyrics" : "\(lyrics)"
            ]

        }
        else {
            let title = self.songText.text
                       let lyrics = self.lyricsText.text
            let id_user = SharedPreferences.sharedpref.prefs.string(forKey: "id")!

             param = [
                "title" : "\(title!)",
                "id_user" : "\(id_user)",
                "lyrics" : "\(lyrics!)"
            ]
        }
      
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        

       let fileURL = NSURL(fileURLWithPath: self.recorderView.recording.url.path )
        let recording : NSData? = NSData(contentsOf: fileURL as URL)

        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: recording!, boundary: boundary) as Data
        
        
      
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                let alert = CDAlertView(title: "Erreur", message: "Failed to save", type: .error  )
                alert.alertBackgroundColor = UIColor("#333333")
                alert.actionSeparatorColor = UIColor("#FF475C")
                alert.tintColor = UIColor("#FF475C")
                alert.titleTextColor = UIColor.white
                alert.messageTextColor = UIColor.white
                let doneAction = CDAlertViewAction(title: " Nevermind 😑")
                doneAction.buttonTextColor = UIColor("#FF475C")
                alert.add(action: doneAction)
                alert.show()

                SwiftSpinner.hide()
                return
            }
            
            // You can print out response object
            print("******* response = \(String(describing: response)))")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                 SwiftSpinner.hide()
                let alert = CDAlertView(title: "Success", message: "You saved the record", type: .notification  )
                alert.alertBackgroundColor = UIColor("#333333")
                alert.actionSeparatorColor = UIColor("#FF475C")
                alert.tintColor = UIColor("#FF475C")
                alert.titleTextColor = UIColor.white
                alert.messageTextColor = UIColor.white
                let doneAction = CDAlertViewAction(title: "Sure! 💪")
                doneAction.buttonTextColor = UIColor("#FF475C")
                alert.add(action: doneAction)
                alert.show()
                print(json!)
                
                
                
            }catch
            {
                let alert = CDAlertView(title: "Erreur", message: "Failed to save", type: .error  )
                alert.alertBackgroundColor = UIColor("#333333")
                alert.actionSeparatorColor = UIColor("#FF475C")
                alert.tintColor = UIColor("#FF475C")
                alert.titleTextColor = UIColor.white
                alert.messageTextColor = UIColor.white
                let doneAction = CDAlertViewAction(title: " Nevermind 😑")
                doneAction.buttonTextColor = UIColor("#FF475C")
                alert.add(action: doneAction)
                alert.show()

                 SwiftSpinner.hide()
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = SharedPreferences.sharedpref.prefs.string(forKey: "id")! + self.songText.text! + ".m4a"
        let mimetype = "audio/mp4"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    

    
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
    
