//
//  TopMusicController.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 3/11/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import CDAlertView
import SwiftSpinner
import SwiftyJSON



class TopMuicController:UIViewController,UITableViewDataSource,UITableViewDelegate,PresentedViewControllerDelegate,UISearchBarDelegate
{
    
    
    @IBOutlet weak var seg: UISegmentedControl!
    
    @IBOutlet weak var topMusicLabel: UILabel!
    
    let countryIso: NSDictionary = [
        "Anguilla" : "ai","Argentina" : "ar","Armenia" : "am","Austria" : "at","Azerbaijan" : "az",
        "Bahamas" : "bs","Bahrain" : "bh","Barbados" : "bb","Belarus" : "by","Belgium" : "be",
        "Belize" : "bz","Bermuda" :"varrm","Bolivia" : "at","Botswana" : "bw","Brazil" : "br",
        "Bulgaria" : "bg","Burkina Faso" : "bf","Cambodia" : "kh","Cape Verde" : "cv","Chile" : "cl",
        "Colombia" : "co","Costa Rica" : "cr","Croatia" : "at",//"Cyprus" : "cp",
        "Czeck Republic" : "cr","Danmark" : "dk","Dominica" : "dm",
        //"Dominican Republic" : "do",
        "Ecuador" : "ec","Egypt" : "eg","El Salvador" : "sv","Estonia" : "ee","Fiji" : "fj",
        "Finland" : "fi",
        "Gambia" : "gm",
        "Ghana" : "gh",
        "Greece" : "gr",
        "Grenada" : "gd",
        "Guatemala" : "gt",
        "Guinea-Bisseau" : "gw",
        "Honduras" : "hn",
        "Hong Kong" : "hk",
        "Hungary" : "hu",
        "India" : "in",
        "Indonesia" : "id",
        "Ireland" : "ie",
        "Jordan" : "jo",
        "Kazakhstan" : "kz",
        "Kyrgistan" : "kg",
        "Lao" : "la",
        "Austria" : "at",
        "Latvia" : "lv",
        "Lebanon" : "lb",
        "Lithuania" : "lt",
        "Luxemboug" : "lu",
        "Macau" : "mo",
        "Malaysia" : "my",
        "Malta" : "mt",
        "Mauritius" : "mu",
        "Mexico" : "mx",
        "Micronesia" : "fm",
        "Moldova" : "md",
        "Mongolia" : "mn",
        "Mozambique" : "mz",
        "Namibia" : "na",
        "Nepal" : "np",
        "Netherlands" : "nl",
        "New Zealand" : "nz",
        "Nicaragana" : "ni",
        "Niger" : "ne",
        "Nigeria" : "ng",
        "Norway" : "no",
        "Oman" : "om",
        "Panama" : "pa",
        "Papua" : "pg",
        "Paraguay" : "py",
        "Peru" : "pe",
        "Philippines" : "ph",
        "Poland" : "pl",
        "Portugual" : "pt",
        "Qatar" : "qa",
        "Romania" : "ro",
        "Russia" : "ru",
        "Saudi Arabia" : "sa",
        "Singapore" : "sk",
        "Slovenia" : "si",
        "Slovakia" : "sk",
        //"Sri Lanka" : "ik",
        "Swaziland" : "sz",
        "Sweden" : "se",
        "Switzerland" : "ch",
        "Taiwan" : "tw",
        "Tajikstan" : "tj",
        "Thailand" : "th",
        "Trinidad & Tobago" : "tt",
        "Turkey" : "tr",
        "Tukhmenistan" : "tm",
        "Uganda" : "ug",
        "Ukraine" : "ua",
        "United Arab Emirates" : "ae",
        "Uzbekistan" : "uz",
        "Venezuella" : "ve",
        "Vietnam" : "vn",
        "Zimbabwe" : "zw",
        "United States" : "us",
        "Canada" : "ca",
        "United Kingdom" : "gb",
        "France" : "fr",
        "Italy" : "it",
        "Spain" : "es",
        "Japan" : "jp",
        "Germany" : "de",
        "Australia" : "au",
        ]
    
    
    
    
    
    var count:Bool = false
    @IBOutlet weak var arrow: UIImageView!
    
    
    var country = ""
    
    
    var searchBy = "us"
    @IBOutlet weak var drop: DropMenuButton!
    var musix : JSON = []
    var server:String="http://193.95.44.118/lyrix/"
    
    @IBOutlet weak var tblView: UITableView!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.firstBar()
        
        
        navigationController?.navigationBar.barTintColor = UIColor("#333333")
        
        //self.navigationController?.title = "Top Music"
        
        
        drop.initMenu(["United States", "Canada", "United Kingdom","France","Italy","Germany","Spain","Japan","Australia",
                       "Click to select an other country"],
                      actions: [({ () -> (Void) in self.getTopSongs(country:self.returnIso(pays: "United States"));self.arrow.image = UIImage(named: "down"); })
                        
                        , ({ () -> (Void) in self.getTopSongs(country:self.returnIso(pays: "Canada"));self.arrow.image = UIImage(named: "down"); })
                        
                        , ({ () -> (Void) in self.getTopSongs(country:self.returnIso(pays: "United Kingdom"));self.arrow.image = UIImage(named: "down"); })
                        
                        , ({ () -> (Void) in self.getTopSongs(country:self.returnIso(pays: "France"));self.arrow.image = UIImage(named: "down"); })
                        
                        , ({ () -> (Void) in self.getTopSongs(country:self.returnIso(pays: "Italy"));self.arrow.image = UIImage(named: "down");})
                        
                        , ({ () -> (Void) in self.getTopSongs(country:self.returnIso(pays: "Germany"));self.arrow.image = UIImage(named: "down"); })
                        
                        , ({ () -> (Void) in self.getTopSongs(country:self.returnIso(pays: "Spain"));self.arrow.image = UIImage(named: "down");  })
                        
                        , ({ () -> (Void) in self.getTopSongs(country:self.returnIso(pays: "Japan"));self.arrow.image = UIImage(named: "down"); })
                        
                        , ({ () -> (Void) in self.getTopSongs(country:self.returnIso(pays: "Australia"));self.arrow.image = UIImage(named: "down"); })
                        
                        , ({ () -> (Void) in self.doPresent();self.arrow.image = UIImage(named: "down"); self.arrow.image = UIImage(named: "down"); })])
        
        
        
        tblView!.delegate = self
        
        tblView!.dataSource = self
        
        self.getTopSongs(country:searchBy)
        print("------------------------")
        print(self.searchBy)
        
        if(self.drop.titleLabel?.text == "Click to select an other country"){
            print ("yes")
            
            let tim = self.country.characters.count
            var prin=""
            var num = 0
            if (tim % 2 == 0){
                
                num = (16 - (tim/2)+9)
                
                
            }else{
                num = (16 - (tim/2)+10)
            }
            
            for _ in 1...num{
                prin.append(" ")
            }
            
            
            prin.append(self.country)
            
            self.drop.titleLabel?.text = prin
            
            
        }else{
            print ("no")
        }
        print(self.country)
        print("------------------------")
        
    }
    
    func firstBar(){
        
        let searchImage = UIImage(named: "search")!
        print("YO")
        
        //let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: Selector(("didTapSearchButton:")))
        
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton))
        
        searchButton.tintColor = UIColor.red
        navigationItem.rightBarButtonItems = [searchButton]
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        let a = ((seg.titleForSegment(at: seg.selectedSegmentIndex)))!
        print (a)
        searchBar.endEditing(true)
        
        
        switch a{
        case "Music":
            let hello = self.storyboard?.instantiateViewController(withIdentifier: "SearchForMusic") as! SearchMusicController
            
            hello.searchedVal = searchBar.text!
            hello.searchWith = "Music"
            self.navigationController?.pushViewController(hello, animated: true)
            
            break
        case "Lyrics":
            let hello = self.storyboard?.instantiateViewController(withIdentifier: "SearchForMusic") as! SearchMusicController
            
            hello.searchedVal = searchBar.text!
            hello.searchWith = "Lyrics"
            self.navigationController?.pushViewController(hello, animated: true)
            break
            
        case "Artist":
            break
        default:
            print("nothing")
            break
            
        }
    }
    
    
    func createSearchView(){
        
        
        seg.isHidden = false
        drop.isHidden = true
        topMusicLabel.isHidden = true
        //.titleForSegment(at: segmented.selectedSegmentIndex)
        arrow.isHidden = true
        let searchBar = UISearchBar()
        searchBar.tintColor = UIColor.lightGray
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        
        searchBar.delegate = self
        
        let cancelImage = UIImage(named: "cancel")!
        
        
        let cancelButton = UIBarButtonItem(image: cancelImage,  style: .plain, target: self, action: #selector(didTapCancelButton))
        
        cancelButton.tintColor = UIColor.red
        navigationItem.rightBarButtonItems = [cancelButton]
        self.navigationItem.titleView = searchBar
        
        
    }
    
    func didTapSearchButton(sender: AnyObject){
        createSearchView()
        print("hello")
    }
    
    
    func didTapCancelButton(sender: AnyObject){
        firstBar()
        seg.isHidden = true
        drop.isHidden = false
        
        arrow.isHidden = false
        topMusicLabel.isHidden = false
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Welcome to LyricX Plus"
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func DidselectDropDownMenu(_ sender: Any) {
        
        if (self.count == false){
            self.count = true
            self.arrow.image = UIImage(named: "up")
        }else{
            self.count = false
            self.arrow.image = UIImage(named: "down")
        }
        
        
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musix.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        
        
        
        let artistLabel:UILabel = cell.viewWithTag(101) as! UILabel
        let titleLabel:UILabel = cell.viewWithTag(102) as! UILabel
        let albumLabel:UILabel = cell.viewWithTag(104) as! UILabel
        let numberLabel:UILabel = cell.viewWithTag(105) as! UILabel
        let AlbumImg:UIImageView = cell.viewWithTag(103) as! UIImageView
        
        artistLabel.numberOfLines = 2;
        titleLabel.numberOfLines = 2;
        albumLabel.numberOfLines = 2;
        
        albumLabel.text? = musix[indexPath.row]["im:collection"]["im:name"]["label"].stringValue
        
        
        numberLabel.text? = "N° " + (String(indexPath.row + 1))
        
        
        artistLabel.text? = musix[indexPath.row]["im:artist"]["label"].stringValue
        titleLabel.text? = musix[indexPath.row]["im:name"]["label"].stringValue
        
        let url1 = NSURL(string:musix[indexPath.row]["im:image"][2]["label"].stringValue)
        
        let data1 = NSData(contentsOf:url1! as URL)
        
        if (data1 != nil){
            AlbumImg.image = UIImage(data : data1! as Data)
        }else{
            AlbumImg.image = UIImage(named: "image")
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SongDetailsController") as! SongDetailsController
        nextViewController.artistName = musix[indexPath.row]["im:artist"]["label"].stringValue
        nextViewController.songName = musix[indexPath.row]["im:name"]["label"].stringValue
        nextViewController.url = musix[indexPath.row]["link"][1]["attributes"]["href"].stringValue
        nextViewController.albumName = musix[indexPath.row]["im:collection"]["im:name"]["label"].stringValue
        nextViewController.albumPicUrl = musix[indexPath.row]["im:image"][2]["label"].stringValue
        
        
        self.show(nextViewController, sender: nil)
        
        //self.performSegue(withIdentifier: "SongDetailsSegue", sender: self)
    }
    
    
    
    func getTopSongs(country:String){
        
        
        SwiftSpinner.show("Loading...")
        
        let url:String="http://itunes.apple.com/" + country + "/rss/topsongs/limit=10/json"
        
        Alamofire.request(url,method : .post ).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                
                let json1 = JSON(value)
                
                //print (json1["feed"]["entry"])
                self.musix = json1["feed"]["entry"]
                self.tblView.reloadData()
                
                
                SwiftSpinner.hide()
                
            case .failure(let error) :
                SwiftSpinner.hide()
                print(error)
            }
        }
    }
    
    
    
    func returnIso(pays:String) -> String{
        
        var iso:String=""
        
        iso = self.countryIso.value(forKey: pays) as! String
        
        return iso
    }
    
    
    func acceptData(data: AnyObject!,data2:AnyObject!) {
        self.searchBy = "\(data!)"
        self.country = "\(data2!)"
        print(data2)
    }
    
    
    func doPresent() {
        
        let pvc = storyboard?.instantiateViewController(withIdentifier: "SelectCountryController") as! SelectCountryController
        pvc.data = "important data sent via delegate!" as AnyObject?
        pvc.delegate = self
        self.present(pvc, animated: true, completion: nil)
    }
    
    
    
    
}



