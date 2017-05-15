//
//  PagerController.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 4/19/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftSpinner
import CDAlertView
import SwiftyJSON
import Kanna
import SDWebImage
import SystemConfiguration
class TopSongArtistController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tblView: UITableView!
    var artistName = ""
    var musix : JSON = []
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor("#FF475C")]
        SwiftSpinner.show("Loading ...")
        self.artistName = artistName.replacingOccurrences(of: " ", with: "%20")
        self.getArtistTopSongs(keyWord:self.artistName)
        tblView.delegate = self
        tblView.dataSource = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musix.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "helloCell")!
        
        
        let artistLabel:UILabel = cell.viewWithTag(301) as! UILabel
        let titleLabel:UILabel = cell.viewWithTag(302) as! UILabel
        
        
        artistLabel.numberOfLines = 2;
        titleLabel.numberOfLines = 2;
        
        artistLabel.text? = musix[indexPath.row]["artist"]["name"].stringValue
        titleLabel.text? = musix[indexPath.row]["name"].stringValue
        
        print(artistLabel.text!)
        
        //artistImg.image = UIImage(named : "LogoRound")
        
        //getAlbumPicture(artistNom: artistLabel.text!,albumNom: albumName,image: artistImg)
        
        
        
        return cell
    }

    func getArtistTopSongs(keyWord:String){
        
        if (self.isInternetAvailable()){
            SwiftSpinner.show("Loading...")
            
            let url:String="http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=" + keyWord + "&api_key=2216aa2485da699f4d04a85899b2ce30&format=json&limit=10"
            
            Alamofire.request(url,method : .post ).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    
                    let json1 = JSON(value)
                    
                    //print (json1["feed"]["entry"])
                    self.musix = json1["toptracks"]["track"]
                    
                    print("***")
                    //print(self.musix)
                    
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
        nextViewController.artistName = musix[indexPath.row]["artist"]["name"].stringValue
        nextViewController.songName = musix[indexPath.row]["name"].stringValue
        nextViewController.albumName = "Unknown"
        nextViewController.url = ""
        nextViewController.albumPicUrl = "http://193.95.44.118/lyrix/disk.png"
        
        
        self.show(nextViewController, sender: nil)*/
        
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SongController") as! SongController
        nextViewController.artistName = musix[indexPath.row]["artist"]["name"].stringValue
        nextViewController.songName = musix[indexPath.row]["name"].stringValue
        nextViewController.albumName = "Unknown"
        nextViewController.url = ""
        nextViewController.albumPicUrl = "http://193.95.44.118/lyrix/disk.png"
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
