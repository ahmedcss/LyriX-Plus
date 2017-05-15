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
import CoreData
import DropDownMenuKit
import SDWebImage
import SystemConfiguration

class TopMuicController:UIViewController,UITableViewDataSource,UITableViewDelegate,PresentedViewControllerDelegate,UISearchBarDelegate,DropDownMenuDelegate
{
    
    let countryIso: NSDictionary = [
        "Anguilla" : "ai","Argentina" : "ar","Armenia" : "am","Austria" : "at","Azerbaijan" : "az",
        "Bahamas" : "bs","Bahrain" : "bh","Barbados" : "bb","Belarus" : "by","Belgium" : "be",
        "Belize" : "bz","Bermuda" : "bm","Bolivia" : "at","Botswana" : "bw","Brazil" : "br",
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
    
    
    
    
    var searchs:[NSManagedObject] = []
    
    
    @IBOutlet weak var navigationBarMenu: DropDownMenu!
    var selectSegment = "Music"
    var titleView: DropDownTitleView!
    let streets = ["Albemarle", "Brandywine", "Chesapeake"]
    var count:Bool = false
    @IBOutlet weak var arrow: UIImageView!
    
    
    var country = ""
    
    
    var searchBy = "us"
    @IBOutlet weak var drop: DropMenuButton!
    var musix : JSON = []
    var server:String="http://193.95.44.118/lyrix/"
    
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.tintColor = UIColor("#FF475C")
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor("#FF475C")]
        self.displayAll()
        let title = prepareNavigationBarMenuTitleView()
        
        prepareNavigationBarMenu(title)
        
        updateMenuContentOffsets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationBarMenu.container = view
        
        
        
        
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
         
        
    }
    
    func firstBar(){
    
        let searchImage = UIImage(named: "search")!
        print("YO")
        
        //let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: Selector(("didTapSearchButton:")))
        
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton))

        searchButton.tintColor = UIColor("#E85660")
        navigationItem.rightBarButtonItems = [searchButton]
    
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        
        searchBar.endEditing(true)
        
        
        self.addToCoreData(key:searchBar.text! , by:selectSegment)
        
        switch selectSegment{
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
            let hello = self.storyboard?.instantiateViewController(withIdentifier: "SearchForArtist") as! SearchArtistController
            
            hello.searchWith = searchBar.text!
            
            self.navigationController?.pushViewController(hello, animated: true)

            break
        default:
            print("nothing")
            break
        }
            }
    

    
    
    func didTapSearchButton(sender: AnyObject){
        print("Sent did toggle navigation bar menu action")
        
        let cancelImage = UIImage(named: "cancel")!
        
        
        let cancelButton = UIBarButtonItem(image: cancelImage,  style: .plain, target: self, action: #selector(didTapCancelButton))
        
        cancelButton.tintColor = UIColor.red
        navigationItem.rightBarButtonItems = [cancelButton]
        
        
        let searchBar = UISearchBar()
        searchBar.tintColor = UIColor.lightGray
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        navigationBarMenu.show()
        
        
    }
    func didTapCancelButton(sender: AnyObject){
        titleView = DropDownTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        titleView.titleLabel.textColor = UIColor.black
        titleView.title = "LyriXPlus"
        
        let searchImage = UIImage(named: "search")!
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton))
        searchButton.tintColor = UIColor.red
        
        
        
        navigationItem.rightBarButtonItems = [searchButton]
        navigationItem.titleView = titleView
        navigationBarMenu.hide()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func DidselectDropDownMenu(_ sender: Any) {
        
        if (self.count == false){
            self.count = true
            self.arrow.image = UIImage(named: "up")
            print("up")
        }else{
            self.count = false
            self.arrow.image = UIImage(named: "down")
            print("down")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musix.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SongCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! SongCell
  
        let artistLabel:UILabel = cell.viewWithTag(101) as! UILabel
        let titleLabel:UILabel = cell.viewWithTag(102) as! UILabel
        //let albumLabel:UILabel = cell.viewWithTag(104) as! UILabel
        let numberLabel:UILabel = cell.viewWithTag(105) as! UILabel
        let AlbumImg:UIImageView = cell.viewWithTag(103) as! UIImageView
        
        artistLabel.numberOfLines = 2;
        titleLabel.numberOfLines = 2;
        //albumLabel.numberOfLines = 2;
        
        //albumLabel.text? = musix[indexPath.row]["im:collection"]["im:name"]["label"].stringValue
        
        cell.Button.tag = indexPath.row
        
        cell.Button.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)

        numberLabel.text? = "N° " + (String(indexPath.row + 1))
        
        artistLabel.text? = musix[indexPath.row]["im:artist"]["label"].stringValue
        titleLabel.text? = musix[indexPath.row]["im:name"]["label"].stringValue

        //######
        
        let url1 = musix[indexPath.row]["im:image"][2]["label"].stringValue

        AlbumImg.sd_setImage(with: URL(string: url1), placeholderImage: UIImage(named: "compact-disk"))

        //######
        
        return cell
    }

    func buttonClicked(_ sender:UIButton) {
        
        let buttonRow = sender.tag
       
        let itunesLink = NSURL(string:musix[buttonRow]["im:collection"]["link"]["attributes"]["href"].stringValue)
        
        let 😡 = itunesLink! as URL
        print(😡)
        UIApplication.shared.open(😡 as URL, options: [:], completionHandler: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        /*let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SongDetailsController") as! SongDetailsController
        nextViewController.artistName = musix[indexPath.row]["im:artist"]["label"].stringValue
        nextViewController.songName = musix[indexPath.row]["im:name"]["label"].stringValue
        nextViewController.url = musix[indexPath.row]["link"][1]["attributes"]["href"].stringValue
        nextViewController.albumName = musix[indexPath.row]["im:collection"]["im:name"]["label"].stringValue
        nextViewController.albumPicUrl = musix[indexPath.row]["im:image"][2]["label"].stringValue
        
        
        self.show(nextViewController, sender: nil)*/
        
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SongController") as! SongController
        nextViewController.artistName = musix[indexPath.row]["im:artist"]["label"].stringValue
        nextViewController.songName = musix[indexPath.row]["im:name"]["label"].stringValue
        nextViewController.url = musix[indexPath.row]["link"][1]["attributes"]["href"].stringValue
        nextViewController.albumName = musix[indexPath.row]["im:collection"]["im:name"]["label"].stringValue
        nextViewController.albumPicUrl = musix[indexPath.row]["im:image"][2]["label"].stringValue
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        self.show(nextViewController, sender: nil)
        
        //self.performSegue(withIdentifier: "SongDetailsSegue", sender: self)
    }
    
    
    
    func getTopSongs(country:String){
    
        
        
        
        
        
        if (self.isInternetAvailable()){
        
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
        }else{
            SwiftSpinner.hide()
            let alert = CDAlertView(title: "Alert", message: "No Internet Available" , type: .error)
            let doneAction = CDAlertViewAction(title: "Try again")
            alert.add(action: doneAction)
            alert.show()
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

    
    func prepareNavigationBarMenuTitleView() -> String {
        
        titleView = DropDownTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        titleView.titleLabel.textColor = UIColor.black
        titleView.title = "LyriXPlus"
        
        let searchImage = UIImage(named: "search")!
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton))
        searchButton.tintColor = UIColor.red
        
        
        
        navigationItem.rightBarButtonItems = [searchButton]
        navigationItem.titleView = titleView
        
        return titleView.title!
    }
    
    @IBAction func select() {
        print("Sent select action")
        
        
        //let searchAudio = self.storyboard?.instantiateViewController(withIdentifier: "SearchAudio") as! RecongnitionController
        let searchAudio = self.storyboard?.instantiateViewController(withIdentifier: "SearchAudi") as! RecognitionController
        
        
        self.navigationController?.pushViewController(searchAudio, animated: true)
        
        
    }
    
    
    
    
    
    @IBAction func showToolbarMenu() {
        if titleView.isUp {
            titleView.toggleMenu()
        }
        
        //toolbarMenu.show()
    }
    func prepareNavigationBarMenu(_ currentChoice: String) {
        navigationBarMenu = DropDownMenu(frame: view.bounds)
        navigationBarMenu.delegate = self
        
        
        let sortKeys = ["Artist","Music", "Lyrics"]
        let sortCell = DropDownMenuCell()
        sortCell.backgroundColor = UIColor("#444")
        let sortSwitcher = UISegmentedControl(items: sortKeys)
        sortSwitcher.tintColor = UIColor("#E85660")
        sortSwitcher.setWidth(CGFloat((sortCell.frame.size.width - 20) / 3), forSegmentAt: 0)
        sortSwitcher.setWidth(CGFloat((sortCell.frame.size.width - 20) / 3), forSegmentAt: 1)
        sortSwitcher.setWidth(CGFloat((sortCell.frame.size.width - 20) / 3), forSegmentAt: 2)
        sortSwitcher.selectedSegmentIndex = sortKeys.index(of: "Music")!
        sortSwitcher.addTarget(self, action: #selector(sort(_:)), for: .valueChanged)
        
        sortCell.customView = sortSwitcher
        sortCell.textLabel!.text = "Sort"
        //sortCell.imageView!.image = UIImage(named: "Ionicons-ios-search")
        sortCell.showsCheckmark = false
        
        let audioCell = DropDownMenuCell()
        audioCell.backgroundColor = UIColor("#444")
        
        audioCell.textLabel!.text = "Search By Sound"
        audioCell.showsCheckmark = false
        audioCell.textLabel?.textColor = UIColor.black
        
        audioCell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)
        audioCell.menuAction = #selector(TopMuicController.select as (TopMuicController) -> () -> ())
        audioCell.menuTarget = self
        
        
        
        if (searchs.count > 0){
            let latestCell = DropDownMenuCell()
            
            
            latestCell.backgroundColor = UIColor("#444")
            
            latestCell.textLabel!.text = "Latest Search"
            latestCell.showsCheckmark = false
            latestCell.textLabel?.textColor = UIColor.black
            
            
            latestCell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 24.0)
            
            
            
            navigationBarMenu.menuCells = [sortCell,audioCell,latestCell]
        }else{
            navigationBarMenu.menuCells = [sortCell,audioCell]
        }
        
        
        
        
        
        for street in searchs {
            let selectCell = DropDownMenuCell()
            
            
            selectCell.backgroundColor = UIColor("#444")
            
            var searchLine:String = (street.value(forKey: "by") as! String?)!
            searchLine.append(" : ")
            searchLine.append((street.value(forKey: "key") as! String?)!)
            
            selectCell.textLabel!.text = searchLine
            selectCell.showsCheckmark = false
            
            selectCell.textLabel?.textColor = UIColor.lightGray
            
            
            
            selectCell.menuAction = #selector(sortCoreData(_:))
            selectCell.menuTarget = self
            
            navigationBarMenu.menuCells.append(selectCell)
        }
        
        navigationBarMenu.direction = .down
        
        
        
        
        
        
        
        //navigationBarMenu.selectMenuCell(secondCell)
        
        // If we set the container to the controller view, the value must be set
        // on the hidden content offset (not the visible one)
        navigationBarMenu.visibleContentOffset =
            navigationController!.navigationBar.frame.size.height + statusBarHeight()
        
        // For a simple gray overlay in background
        navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
        navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
        navigationBarMenu.backgroundAlpha = 0.7
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            // If we put this only in -viewDidLayoutSubviews, menu animation is
            // messed up when selecting an item
            self.updateMenuContentOffsets()
        }, completion: nil)
    }
    
    
    func updateMenuContentOffsets() {
        navigationBarMenu.visibleContentOffset =
            navigationController!.navigationBar.frame.size.height + statusBarHeight()
        //toolbarMenu.visibleContentOffset = navigationController!.toolbar.frame.size.height
    }
    @IBAction func sort(_ sender: UISegmentedControl) {
        print("Sent sort action")
        
        let a = ((sender.titleForSegment(at: sender.selectedSegmentIndex)))!
        
        self.selectSegment = a
    }

    @IBAction func sortCoreData(_ sender: UITableViewCell) {
        
        
        let b = (sender.textLabel?.text)!
        print("©©©©©©©©©©©©©©©©©©©©©©©")
        
        
        let 💩 = b.characters.split{$0 == ":"}.map(String.init)
        
        let searchedBySeg = String(💩[0].characters.dropLast(1))
        
        let searchedVal = String(💩[1].characters.dropFirst(1))
        
        
        
        if (searchedBySeg == "Artist"){
        
            let hello = self.storyboard?.instantiateViewController(withIdentifier: "SearchForArtist") as! SearchArtistController
            
            hello.searchWith = searchedVal
            
            self.navigationController?.pushViewController(hello, animated: true)
            
        
        }else{
        
            let hello = self.storyboard?.instantiateViewController(withIdentifier: "SearchForMusic") as! SearchMusicController
            
            hello.searchedVal = String(💩[1].characters.dropFirst(1))
            hello.searchWith = String(💩[0].characters.dropLast(1))
            self.navigationController?.pushViewController(hello, animated: true)
        }
        
        
        
        
        
        
    }
    
    
    
    @IBAction func didToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        print("Sent did toggle navigation bar menu action")
        
        
        let cancelImage = UIImage(named: "cancel")!
        
        
        let cancelButton = UIBarButtonItem(image: cancelImage,  style: .plain, target: self, action: #selector(didTapCancelButton))
        
        cancelButton.tintColor = UIColor("#E85660")
        navigationItem.rightBarButtonItems = [cancelButton]
        
        
        let searchBar = UISearchBar()
        searchBar.tintColor = UIColor.lightGray
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
    }
    
    func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
        if menu == navigationBarMenu {
            titleView.toggleMenu()
        }
        else {
            menu.hide()
        }
    }
    
    
    func addToCoreData(key:String, by:String){
    
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext  =  appdelegate.persistentContainer.viewContext
        
        let newPerson = NSEntityDescription.entity(forEntityName: "Search", in: managedContext)
        let transc = NSManagedObject(entity: newPerson!, insertInto: managedContext)
        
        
        transc.setValue(key, forKey: "key")
        transc.setValue(by, forKey: "by")
        
        
        do {
            try managedContext.save()
            print("Add Done")
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    public func displayAll(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        // let fetchRequest = NSFetchRequest<>
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Search")
        
        do {
            self.searchs = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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



func statusBarHeight() -> CGFloat {
    let statusBarSize = UIApplication.shared.statusBarFrame.size
    return min(statusBarSize.width, statusBarSize.height)
}



