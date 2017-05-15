//
//  DetailAlbum.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 4/26/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import SystemConfiguration
import CDAlertView
class DetailAlbum:UIViewController,UITableViewDelegate,UITableViewDataSource{

    var musix : JSON = []
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var imageAlbum: UIImageView!
    var link = ""
    var mbid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        SwiftSpinner.show("Loading ...")
        
        getAlbumSongs(keyWord: self.mbid)
        
        self.imageAlbum.sd_setImage(with: URL(string: self.link), placeholderImage: UIImage(named: "compact-disk"))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "helloCell")!
        
        
        let songLabel:UILabel = cell.viewWithTag(700) as! UILabel
        
        
        
        songLabel.numberOfLines = 2;
        
        
        songLabel.text? = musix[indexPath.row]["track"]["track_name"].stringValue
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("AZIZ YA BHIM")
        print(musix.count)
        return musix.count
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getAlbumSongs(keyWord:String){
        
        
        //SwiftSpinner.show("Loading...")
        if (self.isInternetAvailable()){
            let url:String="http://api.musixmatch.com/ws/1.1/album.tracks.get?" +
                "album_mbid=" + keyWord + "&page=1&apikey=73ddf8ff707c806059b04faa88e4d483"
            
            print ("URLO" + url)
            //"http://api.musixmatch.com/ws/1.1/album.tracks.get?album_mbid=1bfaab2a-9510-40df-bdce-4d45f56a383e&page=1&apikey=73ddf8ff707c806059b04faa88e4d483"
            
            Alamofire.request(url,method : .get ).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    
                    let json1 = JSON(value)
                    print(json1)
                    //print (json1["feed"]["entry"])
                    self.musix = json1["message"]["body"]["track_list"]
                    
                    print(self.musix)
                    
                    self.tblView.reloadData()
                    
                    
                    SwiftSpinner.hide()
                    
                case .failure(let error) :
                    SwiftSpinner.hide()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SongDetailsController") as! SongDetailsController
        nextViewController.artistName = musix[indexPath.row]["track"]["artist_name"].stringValue
        nextViewController.songName = musix[indexPath.row]["track"]["track_name"].stringValue
        nextViewController.albumName = musix[indexPath.row]["track"]["album_name"].stringValue
        nextViewController.url = ""
        nextViewController.albumPicUrl = self.link
        
        
        self.show(nextViewController, sender: nil)*/
        
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SongController") as! SongController
        nextViewController.artistName = musix[indexPath.row]["track"]["artist_name"].stringValue
        nextViewController.songName = musix[indexPath.row]["track"]["track_name"].stringValue
        nextViewController.albumName = musix[indexPath.row]["track"]["album_name"].stringValue
        nextViewController.url = ""
        nextViewController.albumPicUrl = self.link
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        self.show(nextViewController, sender: nil)
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
