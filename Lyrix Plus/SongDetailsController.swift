//
//  SongDetailsController.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 3/12/17.
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
class SongDetailsController:UIViewController{

    @IBOutlet weak var PlayerAudio: UIView!
    @IBOutlet weak var listenOnYTlabel: UIButton!
    @IBOutlet weak var cheatLabel: UILabel!
    @IBOutlet weak var previewLab: UILabel!
    var artistName = ""
    var artistPicUrl = ""
    var albumName = ""
    var albumPicUrl = ""
    var songName = ""
    var songLyrics = ""
    var songCodeYT = ""
    
    var tempoState = 100
    
    let server:String="http://193.95.44.118/lyrix/"
    @IBOutlet weak var LogoYT: UIButton!
    
    var codes : JSON = []
    
    @IBOutlet weak var getHighOutlet: UIButton!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var artistPicture: UIImageView!
    @IBOutlet weak var playBtnOutlet: UIButton!
    
    
    
    @IBOutlet weak var pauseBtnOutlet: UIButton!
    
    
    @IBOutlet weak var repeatBtnOutlet: UIButton!
    var 👀 = CGFloat(0)
    
    @IBOutlet weak var labelLyrics: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var player = AVPlayer()
    var duree:Int = 0
    
    var x = 0
    var y = 0
    var w = 0
    var h = 0
    
    var x1 = 0
    var y1 = 0
    var w1 = 0
    var h1 = 0
    
   
    @IBOutlet weak var LyricsLabel: UITextView!
    var url = ""
    
    var youtubeUrl = "https://www.youtube.com/watch?v="
    
    
   
    @IBAction func FbButtonShareTapped(_ sender: Any) {
        
        let vc = (SLComposeViewController(forServiceType:SLServiceTypeFacebook))!
        
        
        vc.setInitialText("Listening to " + self.songName + " By " + self.artistName + " on LyriXPlus app\nLyrics :\n" + self.songLyrics)
        var khaled = youtubeUrl
        khaled.append(self.songCodeYT)
        
        vc.add(URL(string: khaled))
        
        self.present(vc, animated: true, completion: nil)
    }
        
    @IBAction func ShareButtonTaped(_ sender: Any) {
        
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
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        print("mayma : " + albumPicUrl)
        super.viewWillAppear(true)
        
        if (url == ""){
            self.PlayerAudio.isHidden = true
        }else{
            self.PlayerAudio.isHidden = false
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor("#333333")

        self.navigationController?.navigationBar.tintColor = UIColor("#FF475C")
        SwiftSpinner.show("Loading ...")
        
        
        if (url != ""){
            let playerItem = AVPlayerItem( url:NSURL( string:url )! as URL )
            player = AVPlayer(playerItem:playerItem)
            
            let duration : CMTime = playerItem.asset.duration
            
            self.duree = Int(duration.seconds)
            
            self.timer.text? = "00:" + (String(describing: self.duree))
            

            let seconds : Float64 = CMTimeGetSeconds(duration)
            
            slider.maximumValue = Float(seconds)
            slider.isContinuous = true
            slider.addTarget(self, action: #selector(self.changeAudioTimer(_:)), for: .valueChanged)
        }else{
            self.previewLab.isHidden = true
            self.playBtnOutlet.isHidden = true
            self.playerButtons(indice: 4)
            
            self.slider.isHidden = true
            self.timer.isHidden = true
        }
        
        
        self.👀 = self.listenOnYTlabel.frame.origin.y
        
        self.LogoYT.frame = CGRect(x: self.listenOnYTlabel.frame.width, y: self.listenOnYTlabel.frame.origin.y , width: self.LogoYT.frame.width, height: self.LogoYT.frame.height)
        
        //self.getHighOutlet.frame = CGRect(x: self.webView.frame.width - self.getHighOutlet.frame.width, y: self.getHighOutlet.frame.origin.y, width: self.getHighOutlet.frame.width, height: self.getHighOutlet.frame.height)
        
        self.cheatLabel.frame = CGRect(x: self.cheatLabel.frame.origin.x, y: self.listenOnYTlabel.frame.origin.y - 7 , width: self.listenOnYTlabel.frame.width, height: self.cheatLabel.frame.height)
        

        self.playerButtons(indice: 0)

       
        
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

        self.x = Int(self.LyricsLabel.frame.origin.x)
        self.y = Int(self.LyricsLabel.frame.origin.y)
        self.w = Int(self.LyricsLabel.frame.width)
        self.h = Int(self.LyricsLabel.frame.height)
        
        self.x1 = Int(self.labelLyrics.frame.origin.x)
        self.y1 = Int(self.labelLyrics.frame.origin.y)
        self.w1 = Int(self.labelLyrics.frame.width)
        self.h1 = Int(self.labelLyrics.frame.height)
        

        self.slider.setThumbImage(UIImage(named: "circleSound"), for: .normal)
        
        self.artistPicture.layer.cornerRadius = self.artistPicture.frame.size.width / 2
        
        self.artistPicture.clipsToBounds = true
        
        //1
        self.getArtistPicture(artistnom: self.artistName)
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ReplayBtn(_ sender: Any) {
        
        
        let targetTime2:CMTime = CMTimeMake(0, 1)
        
        self.player.seek(to: targetTime2)
        
        self.player.play()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)

        
        self.playerButtons(indice: 3)
    }
    
    @IBAction func playBtn(_ sender: Any) {
        
        
        
        
        player.play()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)

        self.playerButtons(indice: 1)
    }
    
    @IBAction func PauseBtn(_ sender: Any) {
        
        self.player.pause()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        self.playerButtons(indice: 2)
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
        
        Alamofire.request(url).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                //self.parseHTML(html: html)
                
                
                
                if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                
                    for show in doc.css("p[class^='mxm-lyrics__content']"){
                        self.LyricsLabel.text?.append((show.text)!)
                        self.songLyrics.append((show.text)!)
                    }
                    // Here you go
                    //mui-dropdown__menu-item-link
                    var my = ""
                    for sh in doc.css("div[class^='mui-dropdown__menu-cont']"){
                        
                        print(sh.text!)
                        my.append(sh.text!)
                        my.append(" ")
                    }
                 
                    print ("ùùùùùù : " + my)
                }
                
            }
            SwiftSpinner.hide()
        }
    
    }

    func searchOnGoogle(artist:String,song:String) -> String{

        var finalUrl:String = ""
        let headers: HTTPHeaders = [
            "userAgent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
            
        ]
        
        let keyword = (artist + " " + song + " musixmatch lyrics").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "https://www.google.com/search?q=" + keyword! + "&num=1"
        
  
        Alamofire.request(url,headers:headers).responseString { response in
            //print(response.description)
            
            //print("\(response.result.isFailure)"
            
            if let html = response.result.value {
                //self.parseHTML(html: html)
                
                
                
               
                
                if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                    
                    
                    
                    for show in doc.css("h3.r > a"){
                        
                        
                        
                        
                        print("_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-")
                        
                        var a = (show["href"])!
                        let index = a.index(a.startIndex, offsetBy: 7)
                        a = a.substring(from: index)

                        let 😴 = (a.index(of: "&sa="))

                        a = a.substring(to: 😴!)

                        finalUrl = a
                        
                        print("_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-")
                        
                    }
                    
                    
                }
                
                
            }
        }
        return finalUrl
    }
    
    
    
    @IBAction func changeAudioTimer(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        
        
        player.seek(to: targetTime)
        
        if player.rate == 0
        {
            player.play()
            self.playBtnOutlet.isHidden = true
            self.pauseBtnOutlet.isHidden = false
            self.repeatBtnOutlet.isHidden = false

        }
        
    }
    
    func updateTime(_ timer: Timer) {
        
        if (url != ""){
        
            slider.value = Float(player.currentTime().seconds)
            let 🙏 = self.duree - Int(player.currentTime().seconds)
            
            
            
            if (🙏 > 9){
                self.timer.text? = "00:" + (String(🙏))
            }else{
                self.timer.text? = "00:0" + (String(🙏))
            }
            
            if (🙏==0){
                
                self.playBtnOutlet.isHidden = false
                self.pauseBtnOutlet.isHidden = true
                self.repeatBtnOutlet.isHidden = true
                
            }
        }
       
        
        
    }
    
    func getArtistPicture(artistnom:String){
    
        var ur = "https://www.last.fm/music/"
        let ur2 = artistName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        ur.append(ur2!)
        
        
        Alamofire.request(ur).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                //self.parseHTML(html: html)
                
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
        
        //2
        self.getYoutubeVideo(artist: artistName, song: songName)
        
    
    }
    
    @IBAction func LaunchYoutubeVideo(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {

            self.listenOnYTlabel.frame = CGRect(x: self.listenOnYTlabel.frame.origin.x, y: self.previewLab.frame.origin.y + 20, width: self.listenOnYTlabel.frame.width, height: self.listenOnYTlabel.frame.height)
            
            self.LogoYT.frame = CGRect(x: self.listenOnYTlabel.frame.width, y: self.listenOnYTlabel.frame.origin.y , width: self.LogoYT.frame.width, height: self.LogoYT.frame.height)
            
            //self.getHighOutlet.frame = CGRect(x: self.webView.frame.width - self.getHighOutlet.frame.width, y: self.listenOnYTlabel.frame.origin.y, width: self.getHighOutlet.frame.width, height: self.getHighOutlet.frame.height)
            
            
            //self.cheatLabel.frame = CGRect(x: self.webView.frame.origin.x, y: self.listenOnYTlabel.frame.origin.y - 7 , width: self.webView.frame.width, height: self.cheatLabel.frame.height)
            
            //self.webView.frame = CGRect(x: self.webView.frame.origin.x, y: self.listenOnYTlabel.frame.origin.y - 7 , width: self.webView.frame.width, height: self.webView.frame.height)
            
            
            
            
            
        })

            //self.webView.isHidden = false
            self.getHighOutlet.isHidden = false
            self.cheatLabel.isHidden = false
            if (self.url != ""){
            self.PauseBtn(self)
            }

        
            self.previewLab.isHidden = true
        
            self.playerButtons(indice: 4)
            
            self.slider.isHidden = true
            self.timer.isHidden = true


        let xPosition = LyricsLabel.frame.origin.x
        
        
        //let yPosition = webView.frame.origin.y + webView.frame.height + 24
        
        
        //let height = self.view.frame.height - yPosition
        let width = LyricsLabel.frame.size.width
        
        UIView.animate(withDuration: 0.5, animations: {
            
          //  self.LyricsLabel.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            
           // self.labelLyrics.frame = CGRect(x: xPosition, y: yPosition - 90, width: self.labelLyrics.frame.width, height: self.labelLyrics.frame.width)
        })
    }
    
    
    
    @IBAction func launch(_ sender: Any) {
        self.LaunchYoutubeVideo(self)
    }
    
    func getYoutubeVideo(artist:String, song:String){
        
        var backToBlack = ""
        
        let param = (artist + " " + song).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let url = "https://www.googleapis.com/youtube/v3/search?part=id&q=" + param! + "&safeSearch=moderate&maxResults=5&type=video&key=AIzaSyByp4usFJQ0srWjFv0P3QXv7WJpp1eKWQ4"
        
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
                
                
                self.getLyrics(artist: self.artistName,song:self.songName)
                
                
            case .failure(let error) :
                
                print(error)
            }
        }
        
        
    }
    
    @IBAction func getHigh(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.LyricsLabel.frame = CGRect(x: self.x, y: self.y, width: self.w, height: self.h)
            
            self.labelLyrics.frame = CGRect(x: self.x1, y: self.y1, width: self.w1, height: self.h1)
            
            self.listenOnYTlabel.frame = CGRect(x: self.listenOnYTlabel.frame.origin.x, y: self.👀, width: self.listenOnYTlabel.frame.width, height: self.listenOnYTlabel.frame.height)
            
            self.LogoYT.frame = CGRect(x: self.listenOnYTlabel.frame.width, y: self.listenOnYTlabel.frame.origin.y , width: self.LogoYT.frame.width, height: self.LogoYT.frame.height)
            
           // self.getHighOutlet.frame = CGRect(x: self.webView.frame.width - self.getHighOutlet.frame.width, y: self.listenOnYTlabel.frame.origin.y, width: self.getHighOutlet.frame.width, height: self.getHighOutlet.frame.height)
            
            
            //self.cheatLabel.frame = CGRect(x: self.webView.frame.origin.x, y: self.listenOnYTlabel.frame.origin.y - 7 , width: self.webView.frame.width, height: self.cheatLabel.frame.height)
            
           // self.webView.frame = CGRect(x: self.webView.frame.origin.x, y: self.listenOnYTlabel.frame.origin.y - 7 , width: self.webView.frame.width, height: self.webView.frame.height)
        })
        //self.webView.isHidden = true
        self.getHighOutlet.isHidden = true
        self.cheatLabel.isHidden = true
        
        self.previewLab.isHidden = false
        self.timer.isHidden = false
        self.slider.isHidden = false
        self.playerButtons(indice: self.tempoState)
        
        
        
 
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.PauseBtn(self)
        //self.webView.loadHTMLString("", baseURL: nil)
        
    }
    
    func playerButtons(indice:Int){

    switch indice {
    
    case 0 :
        //Initial State
        self.playBtnOutlet.isHidden = false
        self.pauseBtnOutlet.isHidden = true
        self.repeatBtnOutlet.isHidden = true
        self.tempoState = 0
        break
    
    case 1 :
        //Play Button Clicked
        self.playBtnOutlet.isHidden = true
        self.pauseBtnOutlet.isHidden = false
        self.repeatBtnOutlet.isHidden = false
         self.tempoState = 1
        break
    
        
    case 2 : 
        //Pause Button Clicked
        self.playBtnOutlet.isHidden = false
        self.pauseBtnOutlet.isHidden = true
        self.repeatBtnOutlet.isHidden = false
     self.tempoState = 2
        break
        
    case 3:
        //Repeat Button Clicked
        
        self.playBtnOutlet.isHidden = true
        self.pauseBtnOutlet.isHidden = false
        self.repeatBtnOutlet.isHidden = false
         self.tempoState = 3
        break
    case 4:
        self.playBtnOutlet.isHidden = true
        self.pauseBtnOutlet.isHidden = true
        self.repeatBtnOutlet.isHidden = true
        
    default:
        break
    }
    }
}
extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    func dropLast(_ n: Int = 1) -> String {
        return String(characters.dropLast(n))
    }
    var dropLast: String {
        return dropLast()
    }

}









