//
//  Records.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 16/02/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import Foundation
import SwiftSpinner
import Alamofire
import SwiftyJSON
import UIColor_Hex_Swift
import MapleBacon

class Records : UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tableview: UITableView!
    var records : JSON  = []
  
    let url = "http://193.95.44.118/lyrics/getRecords.php"

    @IBOutlet weak var micImg: UIImageView!
    @IBOutlet weak var labelNotFound: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor("#333333")
        tableview.backgroundColor = UIColor("#3D3D3D")


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (records.arrayObject?.count)!
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let lblNom:UILabel = cell.viewWithTag(20) as! UILabel
        let img:UIImageView = cell.viewWithTag(10) as! UIImageView
        let lblDate:UILabel = cell.viewWithTag(30) as! UILabel
        let lblNomSong:UILabel = cell.viewWithTag(60) as! UILabel

        if let imageUrl = URL(string: self.records[indexPath.row]["id_user"][0]["picture"].stringValue), let placeholder = UIImage(named: "placeholder") {
            img.setImage(withUrl: imageUrl , placeholder: placeholder)
        }
        img.layer.cornerRadius = img.frame.size.width / 2
        img.clipsToBounds = true
        lblNom.text = self.records[indexPath.row]["id_user"][0]["username"].stringValue
        lblDate.text = self.records[indexPath.row]["dateRecord"].stringValue
        lblNomSong.text = self.records[indexPath.row]["title"].stringValue

        
        
        return cell 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SwiftSpinner.show("Loading...")
        let parameters: [String: String] = [
            "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! as String ,
            ]
        Alamofire.request(url,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                let json1 = JSON(value)
                
                if json1.arrayObject?.count == 0 {
                    SwiftSpinner.hide()
                    self.labelNotFound.isHidden = false
                    self.tableview.isHidden = true
                    self.micImg.isHidden = false
                }else{
                    SwiftSpinner.hide()
                    self.records = json1
                    
                    self.tableview.reloadData()
                    self.labelNotFound.isHidden = true
                    self.tableview.isHidden = false
                    self.micImg.isHidden = true
                }
            case .failure(let error) :
                SwiftSpinner.hide()
                print(error)
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailsRecord")
        {
        let indexPath:IndexPath = tableview.indexPathForSelectedRow!
        let svc:MusicViewController=segue.destination as! MusicViewController
        svc.shares = self.records[indexPath.row]
        svc.page = "record"
        }
        
    }
    

    
    
}
