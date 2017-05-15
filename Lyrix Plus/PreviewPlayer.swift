//
//  PreviewPlayer.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 5/4/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CDAlertView
import SystemConfiguration


class PreviewPlayer:UIViewController{
    
    
    @IBOutlet weak var hideGif: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timerDeb: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    @IBOutlet weak var lyricsText: UITextView!
    @IBOutlet weak var playBtnOutlet: UIButton!
    @IBOutlet weak var repeatBtnOutlet: UIButton!
    @IBOutlet weak var pauseBtnOutlet: UIButton!
    @IBOutlet weak var SongName: UILabel!
    @IBOutlet weak var albumPic: UIImageView!
    @IBOutlet weak var gif: UIImageView!
    
    var song = ""
    var lyrics = ""
    var albumPicUrl = "http://is1.mzstatic.com/image/thumb/Music111/v4/0e/ca/58/0eca58c9-81ed-33be-ce7f-9bdd76c2e00f/UMG_cvrart_00602557661286_01_RGB72_1800x1800_17UMGIM94431.jpg/170x170bb-85.jpg"
    
    var prev = "http://audio.itunes.apple.com/apple-assets-us-std-000001/AudioPreview111/v4/be/b6/b7/beb6b70a-80de-a13c-ecc0-485ce96f5735/mzaf_4001047311589447280.plus.aac.p.m4a"
    
    var player = AVPlayer()
    var duree:Int = 0
    var tempoState = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SongName.text = self.song
        lyricsText.text = self.lyrics
        let imageData = NSData(contentsOf: Bundle.main.url(forResource : "bgg",withExtension : "gif")!)
        
        let imageGif = UIImage.gifWithData(data: imageData!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        gif.image = imageGif
        
        self.slider.setThumbImage(UIImage(named: "circleSound"), for: .normal)
        
        let link = NSURL(string: self.albumPicUrl)
        let data1 = NSData(contentsOf:link! as URL)
        self.albumPic.image = UIImage(data : data1! as Data)
        
        //circle the images
        self.albumPic.layer.cornerRadius = self.albumPic.frame.size.width / 2
        
        self.albumPic.clipsToBounds = true
        
        if (self.isInternetAvailable()){
            let playerItem = AVPlayerItem( url:NSURL( string:self.prev )! as URL )
            player = AVPlayer(playerItem:playerItem)
            
            let duration : CMTime = playerItem.asset.duration
            
            self.duree = Int(duration.seconds)
            
            self.timer.text? = "00:" + (String(describing: self.duree))
            
            
            
            let seconds : Float64 = CMTimeGetSeconds(duration)
            
            slider.maximumValue = Float(seconds)
            slider.isContinuous = true
            slider.addTarget(self, action: #selector(self.changeAudioTimer(_:)), for: .valueChanged)
        }else{
            let alert = CDAlertView(title: "Alert", message: "No Internet Available" , type: .error)
            let doneAction = CDAlertViewAction(title: "Try again")
            alert.add(action: doneAction)
            alert.show()
        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func updateTime(_ timer: Timer) {
        
        if (prev != ""){
            
            slider.value = Float(player.currentTime().seconds)
            let 🙏 = self.duree - Int(player.currentTime().seconds)
            let 🕺🏿 = Int(player.currentTime().seconds)
            
            if (🕺🏿 < 9){
                self.timerDeb.text? = "00:0" + (String(🕺🏿))
            }
            else{
                self.timerDeb.text? = "00:" + (String(🕺🏿))
            }
            
            
            
            if (🙏 > 9){
                self.timer.text? = "00:" + (String(🙏))
            }
            else{
                self.timer.text? = "00:0" + (String(🙏))
            }
            
            if (🙏==0){
                
                self.playBtnOutlet.isHidden = false
                self.pauseBtnOutlet.isHidden = true
                self.repeatBtnOutlet.isHidden = true
                
            }
        }
        
        
        
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
    
    @IBAction func changeAudioTimera(_ playbackSlider:UISlider) {
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

    @IBAction func pauseBtn(_ sender: Any) {
        self.player.pause()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        self.playerButtons(indice: 2)
        
    }
    @IBAction func repeatBtn(_ sender: Any) {
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
            self.hideGif.isHidden = true
            
            self.tempoState = 1
            break
            
            
        case 2 :
            //Pause Button Clicked
            self.playBtnOutlet.isHidden = false
            self.pauseBtnOutlet.isHidden = true
            self.repeatBtnOutlet.isHidden = false
            self.hideGif.isHidden = false
            
            self.tempoState = 2
            break
            
        case 3:
            //Repeat Button Clicked
            
            self.playBtnOutlet.isHidden = true
            self.pauseBtnOutlet.isHidden = false
            self.repeatBtnOutlet.isHidden = false
            self.hideGif.isHidden = true
            
            self.tempoState = 3
            break
        case 4:
            self.playBtnOutlet.isHidden = true
            self.pauseBtnOutlet.isHidden = true
            self.repeatBtnOutlet.isHidden = true
            self.hideGif.isHidden = true
            
        default:
            break
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.pauseBtn(self)
        
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
    
