//
//  SongController.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 4/28/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Alamofire
import Kanna
import SwiftSpinner
import SwiftyJSON
import UIColor_Hex_Swift
import CDAlertView
import Social
import SystemConfiguration
class SongController:UIViewController{

    
    @IBOutlet weak var playOutlet: UIButton!
    @IBOutlet weak var artistPicture: UIImageView!
    @IBOutlet weak var albumPicture: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var LyricsTextView: UITextView!
    
    var artistName = ""
    var artistPicUrl = ""
    var albumName = ""
    var albumPicUrl = ""
    var songName = ""
    var songLyrics = ""
    var songCodeYT = ""
    var url = ""
    var youtubeUrl = "https://www.youtube.com/watch?v="
    var codes : JSON = []
    
    
    let server:String="http://193.95.44.118/lyrix/"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (url == ""){
            self.playOutlet.isHidden = true
        }else{
            self.playOutlet.isHidden = false
        }
       
        // Transparent Navigation
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        //setting Artist, Song and Album labels
        
        songNameLabel.text = self.songName
        artistNameLabel.text =  self.artistName
        albumNameLabel.text = self.albumName
        
        //setting Album Picture
        
        let link = NSURL(string: self.albumPicUrl)
        let data1 = NSData(contentsOf:link! as URL)
        self.albumPicture.image = UIImage(data : data1! as Data)
        
        //circle the images
        self.artistPicture.layer.cornerRadius = self.artistPicture.frame.size.width / 2
        
        self.artistPicture.clipsToBounds = true
        
        //self.albumPicture.layer.cornerRadius = self.artistPicture.frame.size.width / 2
        
        //self.albumPicture.clipsToBounds = true
        
        //removing weird characters
        
        if artistName.lowercased().range(of:"(") != nil {
            print("exists in artist")
            self.artistName = artistName.characters.split{$0 == "("}.map(String.init)[0]
            artistName = String(artistName.characters.dropLast(1))
            
        }
        
        if songName.lowercased().range(of:"(") != nil {
            print("exists in song")
            self.songName = songName.characters.split{$0 == "("}.map(String.init)[0]
            songName = String(songName.characters.dropLast(1))
        }
        
        self.artistNameLabel.text = self.artistName
        self.songNameLabel.text = self.songName
        
        if artistName.lowercased().range(of:"&") != nil {
            print("exists in song")
            let artistNameArr = artistName.characters.split{$0 == "&"}.map(String.init)
            
            artistName = String(artistNameArr[0].characters.dropLast(1))
            artistName.append(" feat")
            artistName.append(artistNameArr[1])
            
        }
        if songName.lowercased().range(of:"&") != nil {
            print("exists in song")
            let 💩 = songName.characters.split{$0 == "&"}.map(String.init)
            
            songName = String(💩[0].characters.dropLast(1))
            
            songName.append(💩[1])
            
        }
        
        if artistName.lowercased().range(of:"\'") != nil {
            print("exists in song")
            let artistNameArr = artistName.characters.split{$0 == "\'"}.map(String.init)
            
            artistName = artistNameArr[0]
            artistName.append(" ")
            artistName.append(artistNameArr[1])
            
        }
        
        if songName.lowercased().range(of:"\'") != nil {
            print("'''exists in song")
            let 💄 = songName.characters.split{$0 == "\'"}.map(String.init)
            
            songName = 💄[0]
            songName.append(" ")
            songName.append(💄[1])
        }
        
        
        //Getting the lyrics of the song
        
        self.getLyrics(artist: self.artistName,song:self.songName)
        
        //Getting artist Pciture
        
       self.getArtistPicture(artistnom: self.artistName)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    func getLyrics(artist:String, song:String){
        
        
        
        var a = artist.replacingOccurrences(of: "'", with: "-", options: .literal, range: nil).replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        
        var b = song.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        
        
        a = a.replacingOccurrences(of: "\'", with: "-", options: .literal, range: nil)
        
        b = b.replacingOccurrences(of: "\'", with: "-", options: .literal, range: nil)
        
        var url = "https://www.musixmatch.com/lyrics/"
        url.append(a)
        url.append("/")
        url.append(b)
        print("MusixMatch")
        print("Urlll :" + url)
        
        if (self.isInternetAvailable()){
            Alamofire.request(url).responseString { response in
                print("\(response.result.isSuccess)")
                if let html = response.result.value {
                    
                    if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                        
                        for show in doc.css("p[class^='mxm-lyrics__content']"){
                            self.LyricsTextView.text?.append((show.text)!)
                            self.songLyrics.append((show.text)!)
                        }
                    }
                    
                }
                SwiftSpinner.hide()
            }
        }else{
            SwiftSpinner.hide()
            let alert = CDAlertView(title: "Alert", message: "No Internet Available" , type: .error)
            let doneAction = CDAlertViewAction(title: "Try again")
            alert.add(action: doneAction)
            alert.show()
        }
        
        
    }
    
    func getArtistPicture(artistnom:String){
        
        var ur = "https://www.last.fm/music/"
        let ur2 = artistName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        ur.append(ur2!)
        print("Mayma : " + ur)
        if (self.isInternetAvailable()){
            Alamofire.request(ur).responseString { response in
                print("\(response.result.isSuccess)")
                if let html = response.result.value {
                    
                    if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                        
                        for show in doc.css("img[class^='avatar']"){
                            let link = URL(string:show["src"]!)
                            self.artistPicUrl = link!.absoluteString
                            let data1 = NSData(contentsOf:link! as URL)
                            self.artistPicture.image = UIImage(data : data1! as Data)
                        }
                    }
                }
            }
        }else{
            SwiftSpinner.hide()
            let alert = CDAlertView(title: "Alert", message: "No Internet Available" , type: .error)
            let doneAction = CDAlertViewAction(title: "Try again")
            alert.add(action: doneAction)
            alert.show()
        }
        
    }
    
    @IBAction func PreviewButton(_ sender: Any) {
        
        
        if (self.isInternetAvailable()){
            let nv = storyboard?.instantiateViewController(withIdentifier: "Preview") as! PreviewPlayer
            
            nv.albumPicUrl = self.albumPicUrl
            
            nv.song = self.songName + " By " + self.artistName
            
            nv.prev = self.url
            
            nv.lyrics = self.LyricsTextView.text
            self.present(nv, animated: true, completion: nil)
        }else{
            SwiftSpinner.hide()
            let alert = CDAlertView(title: "Alert", message: "No Internet Available" , type: .error)
            let doneAction = CDAlertViewAction(title: "Try again")
            alert.add(action: doneAction)
            alert.show()
        }
        
        
        
    }
    
    @IBAction func ShareAppBtn(_ sender: Any) {
        SwiftSpinner.show("Loading ...")
        
        
        let artistNamee = self.artistName.data(using: String.Encoding.utf8)!
        let artistPic = self.artistPicUrl.data(using: String.Encoding.utf8)!
        let albumNamee = self.albumName.data(using: String.Encoding.utf8)!
        let albumPic = self.albumPicUrl.data(using: String.Encoding.utf8)!
        let songNamee = self.songName.data(using: String.Encoding.utf8)!
        let songLyricss = self.songLyrics.data(using: String.Encoding.utf8)!
        let songCodeYTT = self.songCodeYT.data(using: String.Encoding.utf8)!
        let prev = self.url.data(using: String.Encoding.utf8)!
        let idUser = "2".data(using: String.Encoding.utf8)!
        
        
        if (self.isInternetAvailable()){
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(artistNamee, withName: "artist")
                    multipartFormData.append(artistPic, withName: "artistPic")
                    multipartFormData.append(albumNamee, withName: "album")
                    multipartFormData.append(albumPic, withName: "albumPic")
                    multipartFormData.append(songNamee, withName: "song")
                    multipartFormData.append(songLyricss, withName: "lyrics")
                    multipartFormData.append(songCodeYTT, withName: "codeYT")
                    multipartFormData.append(prev, withName: "preview")
                    multipartFormData.append(idUser, withName: "idUser")
            },
                to: self.server + "ShareSong.php",
                
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseString { response in
                            debugPrint(response)
                            SwiftSpinner.hide()
                            print(response.description)
                            if response.description == "SUCCESS: 1"{
                                CDAlertView(title: "Share", message: "Song Sucessfully Shared !", type: .success).show()
                                
                                //self.performSegue(withIdentifier: "toMusicSegue", sender: self)
                            }else{
                                CDAlertView(title: "Share", message: "Unable To Share This Song !", type: .error).show()
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                        SwiftSpinner.hide()
                    }
            }
            )
        }else{
            SwiftSpinner.hide()
            let alert = CDAlertView(title: "Alert", message: "No Internet Available" , type: .error)
            let doneAction = CDAlertViewAction(title: "Try again")
            alert.add(action: doneAction)
            alert.show()
        }
        

    }
    
    @IBAction func shareBtn(_ sender: Any) {
        let vc = (SLComposeViewController(forServiceType:SLServiceTypeFacebook))!
        
        
        vc.setInitialText("Listening to " + self.songName + " By " + self.artistName + " on LyriXPlus app\nLyrics :\n" + self.songLyrics)
        var khaled = youtubeUrl
        khaled.append(self.songCodeYT)
        
        vc.add(URL(string: khaled))
        
        self.present(vc, animated: true, completion: nil)
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

    func getYoutubeVideo(artist:String, song:String){
        
        var backToBlack = ""
        
        let param = (artist + " " + song).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let url = "https://www.googleapis.com/youtube/v3/search?part=id&q=" + param! + "&safeSearch=moderate&maxResults=5&type=video&key=AIzaSyByp4usFJQ0srWjFv0P3QXv7WJpp1eKWQ4"
        
        if (self.isInternetAvailable()){
            
            Alamofire.request(url,method : .get ).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    
                    
                    let json1 = JSON(value)
                    
                    //print (json1["feed"]["entry"])
                    self.codes = json1
                    
                    let json = response.result.value as! Dictionary<String, Any>
                    
                    backToBlack = ("\((((json["items"] as! Array<Any>)[0] as! Dictionary<String, Any>)["id"] as! Dictionary<String, Any>)["videoId"]!)")

                    print(backToBlack)
                    
                    self.songCodeYT = backToBlack
                    
                    
                    self.youtubeUrl.append(backToBlack)
                    
                case .failure(let error) :
                    
                    print(error)
                }
            }
        }else{
            SwiftSpinner.hide()
            let alert = CDAlertView(title: "Alert", message: "No Internet Available" , type: .error)
            let doneAction = CDAlertViewAction(title: "Try again")
            alert.add(action: doneAction)
            alert.show()
        }
        
        
        
    }

    
}
