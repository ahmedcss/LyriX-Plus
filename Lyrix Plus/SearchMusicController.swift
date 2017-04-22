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
class SearchMusicController:UIViewController,UITableViewDelegate,UITableViewDataSource{

    var musix : JSON = []
    var server:String="http://193.95.44.118/lyrix/"
    
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


        
        
        
        
        
        artistImg.image = UIImage(named : "LogoRound")
        
        
        return cell
    }
    
    
    func search(keyword : String){
        

        //SwiftSpinner.show("Loading...")
        
        
        switch searchWith{
        case "Music":
            let url:String="http://api.musixmatch.com/ws/1.1/track.search?q_track=" + keyword + "&s_track_rating=DESC&apikey=73ddf8ff707c806059b04faa88e4d483&format=json&page_size=10"
            //let url:String="http://api.musixmatch.com/ws/1.1/track.search?q_track=Hello&s_track_rating=DESC&apikey=73ddf8ff707c806059b04faa88e4d483&format=json&page_size=10"
            
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
            
            
            break
        case "Lyrics":
            let url:String="http://api.musixmatch.com/ws/1.1/track.search?q_lyrics=" + keyword + "&s_track_rating=DESC&apikey=73ddf8ff707c806059b04faa88e4d483&format=json&page_size=10"
            //let url:String="http://api.musixmatch.com/ws/1.1/track.search?q_track=Hello&s_track_rating=DESC&apikey=73ddf8ff707c806059b04faa88e4d483&format=json&page_size=10"
            
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

            break
            
        case "Artist":
            break
        default:
            print("nothing")
            break
            
        }

            }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SongDetailsController") as! SongDetailsController
        nextViewController.artistName = musix[indexPath.row]["track"]["artist_name"].stringValue
        nextViewController.songName = musix[indexPath.row]["track"]["track_name"].stringValue
        
        
        self.show(nextViewController, sender: nil)
    }
    
    
   
}
