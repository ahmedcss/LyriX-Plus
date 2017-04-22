//
//  MusicPlayerViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 26/03/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation
import Kanna
import Alamofire
import MapleBacon

class MusicPlayerViewController: UIViewController {

    @IBOutlet weak var lyricsText: UITextView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var slid: UISlider!
    @IBOutlet weak var replayBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    var shares : JSON  = []
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var nomAlbum: UILabel!
    @IBOutlet weak var imgAlbum: UIImageView!
    var page = ""
    var player = AVPlayer()
    var duree:Int = 0
    var playerItem : AVPlayerItem? = nil
    let url = "http://audio.itunes.apple.com/apple-assets-us-std-000001/AudioPreview111/v4/65/ca/83/65ca8336-2e09-a0bb-a810-2a6b8864e770/mzaf_3545919152242528717.plus.aac.p.m4a"
    
    var updater : CADisplayLink! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if(page == "music")
        {
        if (self.shares["id_record"] == [] )
        {
            nomAlbum.text = shares["id_song"][0]["album"][0]["name"].stringValue
            nameSong.text = shares["id_song"][0]["title"].stringValue
            if let imageUrl = URL(string:shares["id_song"][0]["album"][0]["picture"].stringValue) ,let placeholder = UIImage(named: "placeholder"){
                imgAlbum.setImage(withUrl: imageUrl , placeholder: placeholder)
            }
           /* let url1 = NSURL(string:shares["id_song"][0]["album"][0]["picture"].stringValue)
            let data1 = NSData(contentsOf:url1! as URL)
            imgAlbum.image = UIImage(data : data1! as Data)*/
            lyricsText.text = shares["id_song"][0]["lyrics"].stringValue
             playerItem = AVPlayerItem( url:NSURL( string:url )! as URL )
            player = AVPlayer(playerItem:playerItem)

        }
        else
        {
            imgAlbum.image = UIImage(named: "default_record")
            nomAlbum.text = "No album"
            
            nameSong.text = shares["id_record"][0]["title"].stringValue
            lyricsText.text = shares["id_record"][0]["lyrics"].stringValue
            playerItem = AVPlayerItem( url:NSURL( string:shares["id_record"][0]["song"].stringValue )! as URL )
            player = AVPlayer(playerItem:playerItem)
        }
        }
        else {
            imgAlbum.image = UIImage(named: "default_record")
            nomAlbum.text = "No album"
            
            nameSong.text = shares["title"].stringValue
            if(shares["lyrics"].string != nil)
            {
            lyricsText.text = shares["lyrics"].stringValue
            }
            else {
                lyricsText.text = "no lyrics"
            }
            playerItem = AVPlayerItem( url:NSURL( string:shares["song"].stringValue )! as URL )
            player = AVPlayer(playerItem:playerItem)

        }
        // Do any additional setup after loading the view.
        
        let duration : CMTime = playerItem!.asset.duration
        
        self.duree = Int(duration.seconds)
        
        self.time.text? = "00:" + (String(describing: self.duree))
        
                let seconds : Float64 = CMTimeGetSeconds(duration)
        
        slid.maximumValue = Float(seconds)
        slid.isContinuous = true
        
        slid.addTarget(self, action: #selector(self.slider(_:)), for: .valueChanged)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.player.pause()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replay(_ sender: Any) {
        let targetTime2:CMTime = CMTimeMake(0, 1)
        
        self.player.seek(to: targetTime2)
        
        self.player.play()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        
        self.playBtn.isHidden = true
        self.pauseBtn.isHidden = false
        self.replayBtn.isHidden = false
    }
    @IBAction func play(_ sender: Any) {
        player.play()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        self.playBtn.isHidden = true
        self.pauseBtn.isHidden = false
        self.replayBtn.isHidden = false

    }
    @IBAction func pause(_ sender: Any) {
        self.player.pause()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        self.playBtn.isHidden = false
        self.pauseBtn.isHidden = true
        self.replayBtn.isHidden = false
    }
    @IBAction func slider(_ sender: Any) {
        let seconds : Int64 = Int64(slid.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        
        
        player.seek(to: targetTime)
        
        if player.rate == 0
        {
            player.play()
        }

    }
    
    func updateTime(_ timer: Timer) {
        slid.value = Float(player.currentTime().seconds)
        let 🙏 = self.duree - Int(player.currentTime().seconds)
        
        if (🙏 > 9){
            self.time.text? = "00:" + (String(🙏))
        }else{
            self.time.text? = "00:0" + (String(🙏))
        }
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        player.pause()
        
    }
    
    

   
}
