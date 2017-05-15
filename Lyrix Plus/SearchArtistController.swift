//
//  SearchArtistController.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 4/19/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import Kanna
import TabPageViewController
import SwiftSpinner
import UIColor_Hex_Swift
import SystemConfiguration
import CDAlertView
class SearchArtistController:UIViewController,UITableViewDelegate,UITableViewDataSource{


    @IBOutlet weak var tblView: UITableView!
    
    var artistx : JSON = []
    var searchWith = ""
    var 👀 = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchWith = searchWith.replacingOccurrences(of: " ", with: "%20")
        searchArtist(searchKey: self.searchWith)
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
        return self.artistx.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell")!
        
        
        let name:UILabel = cell.viewWithTag(401) as! UILabel
        let picture:UIImageView = cell.viewWithTag(402) as! UIImageView
        
        
        picture.layer.cornerRadius = picture.frame.size.width / 2
        
        picture.clipsToBounds = true
        
        name.text = self.artistx[indexPath.row]["artist"]["artist_name"].stringValue
        getArtistPicture(artistnom: name.text!,image: picture)
        
        

        return cell
    }
    
    
    
    
    
    //message - body - artist_list - index
    //artist_name
    
    
    
    func searchArtist(searchKey:String){
    
        
        let url:String="http://api.musixmatch.com/ws/1.1/artist.search?q_artist="+searchKey+"&apikey=73ddf8ff707c806059b04faa88e4d483&format=json&page_size=10&s_artist_rating=DESC"
        
        SwiftSpinner.show("Loading ...")
        if (self.isInternetAvailable()){
            Alamofire.request(url,method : .get ).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    
                    
                    var json1 = JSON(value)
                    
                    self.artistx = json1["message"]["body"]["artist_list"]
                    
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
    
    func getArtistPicture(artistnom:String,image:UIImageView){
        
        var ur = "https://www.last.fm/music/"
        let ur2 = artistnom.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        ur.append(ur2!)
        if (self.isInternetAvailable()){
        
        
        Alamofire.request(ur).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                //self.parseHTML(html: html)
                
                if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                    
                    for show in doc.css("img[class^='avatar']"){
                        let link = URL(string:show["src"]!)
                        

                        image.sd_setImage(with: URL(string: link!.absoluteString), placeholderImage: UIImage(named: "singer"))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "Artist") as! ArtistController
        nextViewController.artistNom = self.artistx[indexPath.row]["artist"]["artist_name"].stringValue
        
        let nextV = storyboard?.instantiateViewController(withIdentifier: "TopArtist") as! TopSongArtistController
        nextV.artistName = self.artistx[indexPath.row]["artist"]["artist_name"].stringValue

        
        let nextV2 = storyboard?.instantiateViewController(withIdentifier: "TopAlbum") as! CityGuideViewController
        nextV2.artist = self.artistx[indexPath.row]["artist"]["artist_name"].stringValue
        let tc = TabPageViewController.create()
        
        tc.tabItems = [(nextViewController, "Overview"), (nextV, "Top Songs"),(nextV2, "Top Albums")]
        var option = TabPageOption()
        option.tabWidth = view.frame.width / CGFloat(tc.tabItems.count)
        
        
            
       option.hidesTabBarOnSwipe = false
        tc.option = option
        navigationController?.pushViewController(tc, animated: true)
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
