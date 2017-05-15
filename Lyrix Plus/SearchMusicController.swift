//
//  SearchMusicController.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 4/5/17.
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
class SearchMusicController:UIViewController,UITableViewDelegate,UITableViewDataSource{

    var musix : JSON = []
    
    var 👀 = [String]()
    var server:String="http://193.95.44.118/lyrix/"
    var albumPicUrl = ""
    @IBOutlet weak var tblView: UITableView!
    var searchedVal = ""
    var searchWith = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tblView.delegate = self
        tblView.dataSource = self
        navigationController?.navigationBar.barTintColor = UIColor("#333333")
        self.navigationController?.title = "Results for \" " + self.searchedVal
        
        print("ssess : " + searchedVal)
        
        searchedVal = searchedVal.replacingOccurrences(of: " ", with: "%20")
        self.search(keyword: searchedVal)
        
        
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

        let artistImg:UIImageView = cell.viewWithTag(303) as! UIImageView
        
        artistLabel.numberOfLines = 2;
        titleLabel.numberOfLines = 2;
        
        artistLabel.text? = musix[indexPath.row]["track"]["artist_name"].stringValue
        titleLabel.text? = musix[indexPath.row]["track"]["track_name"].stringValue

        let albumName = musix[indexPath.row]["track"]["album_name"].stringValue
        
        //artistImg.image = UIImage(named : "LogoRound")
        
        getAlbumPicture(artistNom: artistLabel.text!,albumNom: albumName,image: artistImg)
        
        return cell
    }
    
    
    func search(keyword : String){
        

        //SwiftSpinner.show("Loading...")
        
        
        switch searchWith{
        case "Music":
            let url:String="http://api.musixmatch.com/ws/1.1/track.search?q_track=" + keyword + "&s_track_rating=DESC&apikey=73ddf8ff707c806059b04faa88e4d483&format=json&page_size=10"
            
            print ("URL9 : " + url)
            //let url:String="http://api.musixmatch.com/ws/1.1/track.search?q_track=Hello&s_track_rating=DESC&apikey=73ddf8ff707c806059b04faa88e4d483&format=json&page_size=10"
            
            if (self.isInternetAvailable()){
                Alamofire.request(url,method : .get ).responseJSON {
                    response in
                    switch response.result {
                        
                    case .success(let value) :
                        
                        var json1 = JSON(value)
                        
                        //self.musix = json1["message"]["body"]["track_list"]
                        
                        let musix2 = json1["message"]["body"]["track_list"]
                        
                        var array:[Any] = []
                        
                        
                        for (keyValue, object) in musix2 {
                            let name = object["track"]["track_name"].stringValue
                            // alternative: not case sensitive
                            if (((name.lowercased().range(of:"remix") != nil)) || ((name.lowercased().range(of:"acoustic") != nil)) || ((name.lowercased().range(of:"exclusive") != nil))) {
                                print("Aziz : " + name)
                                print (keyValue)
                            }
                                
                            else
                            {
                                
                                array.append(object)
                                
                                
                            }
                        }
                        //self.musix = nil
                        self.musix = JSON(array)
                        
                        
                        print("my array \(self.musix) with size \(self.musix.count)")
                        
                        
                        self.tblView.reloadData()
                        
                        
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
            
            break
        case "Lyrics":
            let url:String="http://api.musixmatch.com/ws/1.1/track.search?q_lyrics=" + keyword + "&s_track_rating=DESC&apikey=73ddf8ff707c806059b04faa88e4d483&format=json"
            //let url:String="http://api.musixmatch.com/ws/1.1/track.search?q_track=Hello&s_track_rating=DESC&apikey=73ddf8ff707c806059b04faa88e4d483&format=json&page_size=10"
            
            if (self.isInternetAvailable()){
                Alamofire.request(url,method : .get ).responseJSON {
                    response in
                    switch response.result {
                        
                    case .success(let value) :
                        
                        let json1 = JSON(value)
                        
                        //print (json1["feed"]["entry"])
                        self.musix = json1["message"]["body"]["track_list"]
                        print (self.musix)
                        
                        self.tblView.reloadData()
                        
                        
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
            
            break
        case "Artist":
            break
        default:
            print("nothing")
            break
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SongDetailsController") as! SongDetailsController
        nextViewController.artistName = musix[indexPath.row]["track"]["artist_name"].stringValue
        nextViewController.songName = musix[indexPath.row]["track"]["track_name"].stringValue
        
        
        nextViewController.albumName = musix[indexPath.row]["track"]["album_name"].stringValue
        nextViewController.albumPicUrl = 👀[indexPath.row]
        
        
        
        self.show(nextViewController, sender: nil)*/
        
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SongController") as! SongController
        nextViewController.artistName = musix[indexPath.row]["track"]["artist_name"].stringValue
        nextViewController.songName = musix[indexPath.row]["track"]["track_name"].stringValue
        
        nextViewController.albumName = musix[indexPath.row]["track"]["album_name"].stringValue
        nextViewController.albumPicUrl = 👀[indexPath.row]
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        self.show(nextViewController, sender: nil)
    }
    
    
    func getAlbumPicture(artistNom:String,albumNom:String,image:UIImageView){
        
        var ur = "https://www.last.fm/music/"
        let ur2 = artistNom.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        ur.append(ur2!)
        ur.append("/")
        let ur3 = albumNom.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        ur.append(ur3!)
        
        if (self.isInternetAvailable()){
            Alamofire.request(ur).responseString { response in
                
                
                print("\(response.result.isSuccess)")
                if let html = response.result.value {
                    //self.parseHTML(html: html)
                    
                    if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                        for show in doc.css("img[class^='cover-art']"){
                            let link = URL(string:show["src"]!)
                            
                            image.sd_setImage(with: URL(string: self.albumPicUrl), placeholderImage: UIImage(named: "compact-disk"))
                            self.👀.append(link!.absoluteString)
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
