//
//  DetailsViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 12/03/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import SwiftyJSON
import UIColor_Hex_Swift
import CDAlertView
import Alamofire
import MapleBacon

class DetailsViewController: UIViewController {

    @IBOutlet weak var recordSong: UIButton!
    @IBOutlet weak var shareRed: UIButton!
    @IBOutlet weak var nomAlbum: UILabel!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var singer: UILabel!
    @IBOutlet weak var dateShare: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgAlbum: UIImageView!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var dislike: UIButton!
    @IBOutlet weak var likeRed: UIButton!
    @IBOutlet weak var dislikeRed: UIButton!
    @IBOutlet weak var nbrLike: UILabel!
    @IBOutlet weak var shareEmpty: UIButton!
    @IBOutlet weak var nbrDislike: UILabel!
    var shares : JSON  = []
    var l : Int = 0
    let url = "http://193.95.44.118/lyrics/addShare.php"
    let url1 = "http://193.95.44.118/lyrics/addLike.php"
    let url2 = "http://193.95.44.118/lyrics/deleteLike.php"
    let url3 = "http://193.95.44.118/lyrics/getLikes.php"
    let url4 = "http://193.95.44.118/lyrics/addLikeRecord.php"
    let url5 = "http://193.95.44.118/lyrics/deleteLikeRecord.php"
    let url6 = "http://193.95.44.118/lyrics/getLikesRecord.php"
    let url7 = "http://193.95.44.118/lyrics/addShareRecord.php"
    var url8 = ""
    let url9 = "http://193.95.44.118/lyrics/deleteShare.php"
    var parameters : [String : String] = [:]
    
    var page : String = ""
    
    @IBOutlet weak var lyricsSong: UIButton!
    @IBOutlet weak var lyricsRecord: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor("#FF475C")]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

       override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.tintColor = UIColor("#FF475C")
       
        if (self.page == "home")
        {
            shareEmpty.isHidden = false
            shareRed.isHidden = true
            shareRed.isEnabled = false
        }
        else {
            shareEmpty.isHidden = true
            shareRed.isHidden = false
            shareRed.isEnabled = true

          
        }
        if let imageUrl1 = URL(string: shares["id_user"][0]["picture"].stringValue) ,let placeholder = UIImage(named: "placeholder"){
            img.setImage(withUrl: imageUrl1, placeholder: placeholder)
        }
       /* let url = NSURL(string:shares["id_user"][0]["picture"].stringValue)
        let data = NSData(contentsOf:url! as URL)
        img.image = UIImage(data : data! as Data)*/
        username.text = shares["id_user"][0]["username"].stringValue
        dateShare.text = shares["date_share"].stringValue
       
        if (self.shares["id_record"] == [] )
        {
            lyricsSong.isHidden = false
            lyricsRecord.isHidden = true
            recordSong.isHidden = false
            if let imageUrl = URL(string:shares["id_song"][0]["id_singer"][0]["picture"].stringValue) ,let placeholder = UIImage(named: "placeholder"){
                imgAlbum.setImage(withUrl: imageUrl, placeholder: placeholder)
            }
       /* let url1 = NSURL(string:shares["id_song"][0]["id_singer"][0]["picture"].stringValue)
        let data1 = NSData(contentsOf:url1! as URL)
        imgAlbum.image = UIImage(data : data1! as Data)*/
            
        nomAlbum.text = shares["id_song"][0]["album"][0]["name"].stringValue
        singer.text = shares["id_song"][0]["id_singer"][0]["name"].stringValue
        song.text = shares["id_song"][0]["title"].stringValue
            
        nbrLike.text = shares["id_song"][0]["id_rating"][0]["likes"].stringValue
        nbrDislike.text = shares["id_song"][0]["id_rating"][0]["dislikes"].stringValue
            
                      parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_song" : shares["id_song"][0]["id"].stringValue
            ]
            Alamofire.request(url3,method : .post , parameters : parameters).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    if(value as! NSNumber == 1)
                    {
                        self.likeRed.isHidden = false
                        self.like.isHidden = true
                        self.dislikeRed.isHidden = true
                        self.dislike.isHidden = false
                        self.dislike.isEnabled = false
                    }
                    else if (value as! NSNumber == -1)
                    {
                        self.likeRed.isHidden = true
                        self.like.isHidden = false
                        self.dislikeRed.isHidden = false
                        self.dislike.isHidden = true
                        self.like.isEnabled = false
                    }
                    else {
                       
                        self.likeRed.isHidden = true
                        self.dislikeRed.isHidden = true
                    }
                case .failure(let error) :
                    
                    print(error)
                }
            }


        }
        else {
            lyricsSong.isHidden = true
            lyricsRecord.isHidden = false
             recordSong.isHidden = true
             imgAlbum.image = UIImage(named: "default_record")
            nomAlbum.text = "No album"
            singer.text = shares["id_record"][0]["id_user"][0]["fullname"].stringValue
            song.text = shares["id_record"][0]["title"].stringValue
            
            nbrLike.text = shares["id_record"][0]["id_rating"][0]["likes"].stringValue
            nbrDislike.text = shares["id_record"][0]["id_rating"][0]["dislikes"].stringValue
            
            
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_record" : shares["id_record"][0]["id"].stringValue
            ]
            Alamofire.request(url6,method : .post , parameters : parameters).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    if(value as! NSNumber == 1)
                    {
                        self.likeRed.isHidden = false
                        self.like.isHidden = true
                        self.dislikeRed.isHidden = true
                        self.dislike.isHidden = false
                        self.dislike.isEnabled = false
                    }
                    else if (value as! NSNumber == -1)
                    {
                        
                        self.likeRed.isHidden = true
                        self.like.isHidden = false
                        self.dislikeRed.isHidden = false
                        self.dislike.isHidden = true
                        self.like.isEnabled = false
                    }
                    else {
                       
                        self.likeRed.isHidden = true
                        self.dislikeRed.isHidden = true
                    }
                case .failure(let error) :
                    self.likeRed.isHidden = true
                    self.dislikeRed.isHidden = true
                        print(error)
                }
            }


        }
        
       

        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "comment")
       {
        let svc:CommentsViewController=segue.destination as! CommentsViewController
        svc.id = shares["id"].intValue
        svc.iduser = shares["id_user"][0]["id"].stringValue
        }
        else if (segue.identifier == "playsong" )
       {
       /* let sv:MusicViewController=segue.destination as! MusicViewController
        sv.shares = self.shares
        sv.page = "music"*/
      let svs:SongController=segue.destination as! SongController
     
        svs.artistName = self.singer.text!
        svs.songName = self.song.text!
        svs.albumName = self.nomAlbum.text!
        svs.albumPicUrl = shares["id_song"][0]["album"][0]["picture"].stringValue
        svs.artistPicUrl = shares["id_song"][0]["id_singer"][0]["picture"].stringValue
        print (shares["id_song"][0]["preview"].stringValue)
        svs.url = shares["id_song"][0]["preview"].stringValue
        }
        else if (segue.identifier == "recordsong")
       {
        let sv:AddRecordViewController=segue.destination as! AddRecordViewController
        sv.song = self.shares["id_song"][0]
        sv.page = "details"
        }
        else
       {
        let sv:MusicViewController=segue.destination as! MusicViewController
        sv.shares = self.shares
        sv.page = "music"
        }
        
    }
    @IBAction func like(_ sender: Any) {
        
        if (self.shares["id_record"] == [] )
        {
            
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_song" : shares["id_song"][0]["id"].stringValue,
                 "like" : "1"
            ]
            url8 = url1
        }
        else {
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_record" : shares["id_record"][0]["id"].stringValue,
                 "like" : "1"
            ]
            url8 = url5
        }

        Alamofire.request(url8,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                if(value as! NSNumber == 0)
                {
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

                }
                else {
                    self.likeRed.isHidden = false
                    self.like.isHidden = true
                    self.dislike.isEnabled = false
                    self.l = 1 + Int(self.nbrLike.text!)!
                    self.nbrLike.text = String(self.l)
                }
                    
                
            case .failure(let error) :
            print(error)
            }
        }
        
        

        
    }
    @IBAction func dislike(_ sender: Any) {
        if (self.shares["id_record"] == [] )
        {
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_song" : shares["id_song"][0]["id"].stringValue,
                "like" : "-1",
                ]
            url8 = url1
        }
        else {
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_record" : shares["id_record"][0]["id"].stringValue,
                "like" : "-1",
                ]
            url8 = url4
        }
        
        Alamofire.request(url8,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                if(value as! NSNumber == 0)
                {
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
                    
                }
                else {
                    self.dislikeRed.isHidden = false
                    self.dislike.isHidden = true
                    self.like.isEnabled = false
                    
                    self.l = 1 + Int(self.nbrDislike.text!)!
                    self.nbrDislike.text = String(self.l)
                }
                
                
            case .failure(let error) :
                print(error)
            }
        }

        
    }
    @IBAction func deleteLike(_ sender: Any) {
        
        if (self.shares["id_record"] == [] )
        {
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_song" : shares["id_song"][0]["id"].stringValue,
                "like" : "1",
            ]
            url8 = url2
        }
        else {
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_record" : shares["id_record"][0]["id"].stringValue,
                "like" : "1",
            ]
            url8 = url5
        }
        
        Alamofire.request(url8,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                if(value as! NSNumber == 0)
                {
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
                    
                }
                else {
                    self.like.isHidden = false
                    self.likeRed.isHidden = true
                    self.dislike.isEnabled = true
                    self.l = Int(self.nbrLike.text!)! - 1
                    self.nbrLike.text = String(self.l)
                }
                
                
            case .failure(let error) :
                print(error)
            }
        }

        
    }
    @IBAction func deleteDislike(_ sender: Any) {
        
        if (self.shares["id_record"] == [] )
        {
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_song" : shares["id_song"][0]["id"].stringValue,
                "like" : "-1",
            ]
            url8 = url2
        }
        else {
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_record" : shares["id_record"][0]["id"].stringValue,
                "like" : "-1",
            ]
            url8 = url5
        }
        
        Alamofire.request(url2,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                if(value as! NSNumber == 0)
                {
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
                    
                }
                else {
                    self.dislike.isHidden = false
                    self.dislikeRed.isHidden = true
                    self.like.isEnabled = true
                    
                    self.l = Int(self.nbrDislike.text!)! - 1
                    self.nbrDislike.text = String(self.l)
                }
                
                
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    @IBAction func deleteShare(_ sender: Any) {
        if(page == "myshares")
        {
        parameters = [
           
            "id_share" : shares["id"].stringValue
        ]
        Alamofire.request(url9,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                if(value as! NSNumber == 0)
                {
                    
                    let alert = CDAlertView(title: " Failed ", message: "Error in deleting the share", type: .error  )
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
                    let alert = CDAlertView(title: "Success", message: "You delete the share", type: .notification  )
                    alert.alertBackgroundColor = UIColor("#333333")
                    alert.actionSeparatorColor = UIColor("#FF475C")
                    alert.tintColor = UIColor("#FF475C")
                    alert.titleTextColor = UIColor.white
                    alert.messageTextColor = UIColor.white
                    let doneAction = CDAlertViewAction(title: "Sure! 💪")
                    doneAction.buttonTextColor = UIColor("#FF475C")
                    alert.add(action: doneAction)
                    alert.show()
                    self.shareEmpty.isHidden = false
                    self.shareEmpty.isEnabled = true
                    
                    self.shareRed.isHidden = true
                    self.shareRed.isEnabled = false
                    
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
   
    @IBAction func share(_ sender: Any) {
        
        if (self.shares["id_record"] == [] )
        {
            
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_song" : shares["id_song"][0]["id"].stringValue
            ]
            url8 = url
        }
        else {
            parameters = [
                "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
                "id_record" : shares["id_record"][0]["id"].stringValue
            ]
            url8 = url7
        }
        Alamofire.request(url8,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                if(value as! NSNumber == 0)
                {
                    
                    let alert = CDAlertView(title: " Failed ", message: "Error in sharing song", type: .error  )
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
                    let alert = CDAlertView(title: "Success", message: "You share the song", type: .notification  )
                    alert.alertBackgroundColor = UIColor("#333333")
                    alert.actionSeparatorColor = UIColor("#FF475C")
                    alert.tintColor = UIColor("#FF475C")
                    alert.titleTextColor = UIColor.white
                    alert.messageTextColor = UIColor.white
                    let doneAction = CDAlertViewAction(title: "Sure! 💪")
                    doneAction.buttonTextColor = UIColor("#FF475C")
                    alert.add(action: doneAction)
                    alert.show()
                    
                    self.shareEmpty.isHidden = true
                    self.shareEmpty.isEnabled = false
                    self.shareRed.isHidden = false
                    if (self.page == "home")
                    {
                    self.shareRed.isEnabled = true
                    }
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
