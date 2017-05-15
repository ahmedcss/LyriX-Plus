//
//  SelectCountryController.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 3/13/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit



protocol PresentedViewControllerDelegate {
    func acceptData(data: AnyObject!,data2: AnyObject!)
}


class SelectCountryController:UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    // create a variable that will recieve / send messages
    // between the view controllers.
    var delegate : PresentedViewControllerDelegate?
    // another data outlet
    var data : AnyObject?
    var data2 : AnyObject?
    
    var isoBack=""
    var countryBack=""
    
    @IBOutlet weak var countryTableView: UITableView!
    
    
    let countryIso: NSDictionary = [
        "Anguilla" : "ai","Argentina" : "ar","Armenia" : "am","Austria" : "at","Azerbaijan" : "az",
        "Bahamas" : "bs","Bahrain" : "bh","Barbados" : "bb","Belarus" : "by","Belgium" : "be",
        "Belize" : "bz","Bermuda" : "bm","Bolivia" : "at","Botswana" : "bw","Brazil" : "br",
        "Bulgaria" : "bg","Burkina Faso" : "bf","Cambodia" : "kh","Cape Verde" : "cv","Chile" : "cl",
        "Colombia" : "co","Costa Rica" : "cr","Croatia" : "at",//"Cyprus" : "cp",
        "Czeck Republic" : "cr","Danmark" : "dk","Dominica" : "dm",
        //"Dominican Republic" : "do",
        "Ecuador" : "ec","Egypt" : "eg","El Salvador" : "sv","Estonia" : "ee","Fiji" : "fj",
        "Finland" : "fi","Gambia" : "gm","Ghana" : "gh","Greece" : "gr","Grenada" : "gd",
        "Guatemala" : "gt","Guinea-Bisseau" : "gw","Honduras" : "hn","Hong Kong" : "hk",
        "Hungary" : "hu","India" : "in","Indonesia" : "id","Ireland" : "ie","Jordan" : "jo",
        "Kazakhstan" : "kz","Kyrgistan" : "kg","Lao" : "la","Austria" : "at","Latvia" : "lv",
        "Lebanon" : "lb","Lithuania" : "lt","Luxemboug" : "lu","Macau" : "mo","Malaysia" : "my",
        "Malta" : "mt","Mauritius" : "mu","Mexico" : "mx","Micronesia" : "fm","Moldova" : "md",
        "Mongolia" : "mn","Mozambique" : "mz","Namibia" : "na","Nepal" : "np","Netherlands" : "nl",
        "New Zealand" : "nz","Nicaragana" : "ni","Niger" : "ne","Nigeria" : "ng","Norway" : "no",
        "Oman" : "om","Panama" : "pa","Papua" : "pg","Paraguay" : "py","Peru" : "pe",
        "Philippines" : "ph","Poland" : "pl","Portugual" : "pt","Qatar" : "qa","Romania" : "ro",
        "Russia" : "ru","Saudi Arabia" : "sa","Singapore" : "sk","Slovenia" : "si","Slovakia" : "sk",
        //"Sri Lanka" : "ik",
        "Swaziland" : "sz","Sweden" : "se","Switzerland" : "ch","Taiwan" : "tw","Tajikstan" : "tj",
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
        "Zimbabwe" : "zw"
    ]
    
    
    
    
    var countries = ["Finland"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor("#FF475C")
        super.viewWillAppear(true)
    
        
        countries = countryIso.allKeys as! [String]
        
        countries.sort{ $0 < $1 }
        
        countryTableView!.delegate = self
        
        countryTableView!.dataSource = self
  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryIso.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        
        
        let name:UILabel = cell.viewWithTag(201) as! UILabel
        let flag:UIImageView = cell.viewWithTag(202) as! UIImageView
        
        
        name.text? = self.countries[indexPath.row]
        
        let c = self.returnIso(pays: self.countries[indexPath.row])
        
        
        flag.image = UIImage(named: c)
        
        return cell
    }
    
    
    
    
    func returnIso(pays:String) -> String{
    
        var iso:String=""
        
        iso = self.countryIso.value(forKey: pays) as! String
        
        return iso
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.isoBack = self.returnIso(pays: countries[indexPath.row])
        self.countryBack = countries[indexPath.row]
        
        
        self.presentingViewController!.dismiss(animated: true, completion: nil)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            self.delegate?.acceptData(data: self.isoBack as AnyObject!,data2: self.countryBack as AnyObject!)
        }
    }
    
   

    }
