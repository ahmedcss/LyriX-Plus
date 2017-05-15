//
//  HomeViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 08/03/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

import UIColor_Hex_Swift
import CDAlertView
import MapleBacon
import NotificationCenter


class HomeViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{
 
    @IBOutlet weak var tableview: UITableView!
    var shares : JSON  = []
   
    let url = "http://193.95.44.118/lyrics/getAllShare.php"
  private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var conex: UILabel!
    @IBOutlet weak var btnrefrech: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor("#FF475C")]
        navigationController?.navigationBar.barTintColor = UIColor("#333333")
        tableview.backgroundColor = UIColor("#3D3D3D")
        tableview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshData(sender:)), for: .valueChanged)

        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(shares.arrayObject?.count == 0 )
        {
            return 0
        }
        else {
        return (shares.arrayObject?.count)!
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let lblNom:UILabel = cell.viewWithTag(20) as! UILabel
        let img:UIImageView = cell.viewWithTag(10) as! UIImageView
        let lblDate:UILabel = cell.viewWithTag(30) as! UILabel
        let lblNomSinger:UILabel = cell.viewWithTag(50) as! UILabel
        let lblNomSong:UILabel = cell.viewWithTag(60) as! UILabel
        let imgAlbum:UIImageView = cell.viewWithTag(40) as! UIImageView
        let imgmic:UIImageView = cell.viewWithTag(100) as! UIImageView
        let v:UIView = cell.viewWithTag(101)!
      /*  let url = NSURL(string:self.shares[indexPath.row]["id_user"][0]["picture"].stringValue)
        let data = NSData(contentsOf:url! as URL)*/
        if Reachability.isConnectedToNetwork() == true {
            if let imageUrl = URL(string: self.shares[indexPath.row]["id_user"][0]["picture"].stringValue),let placeholder = UIImage(named: "placeholder") {
                img.setImage(withUrl: imageUrl, placeholder: placeholder)
            }
       // img.image = UIImage(data : data! as Data)
        img.layer.cornerRadius = img.frame.size.width / 2
        img.clipsToBounds = true
        imgmic.image = UIImage(named: "microphone_red")
        lblNom.text = self.shares[indexPath.row]["id_user"][0]["username"].stringValue
        lblDate.text = self.shares[indexPath.row]["date_share"].stringValue
        if (self.shares[indexPath.row]["id_record"] == [] )
        {
            lblNomSinger.text = self.shares[indexPath.row]["id_song"][0]["id_singer"][0]["name"].stringValue
            lblNomSong.text = self.shares[indexPath.row]["id_song"][0]["title"].stringValue
            if let imageUrl1 = URL(string: self.shares[indexPath.row]["id_song"][0]["id_singer"][0]["picture"].stringValue),let placeholder = UIImage(named: "placeholder") {
                imgAlbum.setImage(withUrl: imageUrl1, placeholder: placeholder)
            }
            
          /*  let url1 = NSURL(string:self.shares[indexPath.row]["id_song"][0]["id_singer"][0]["picture"].stringValue)
            let data1 = NSData(contentsOf:url1! as URL)
            imgAlbum.image = UIImage(data : data1! as Data)*/
            imgmic.isHidden = true
        }
        else {
            lblNomSinger.text = self.shares[indexPath.row]["id_record"][0]["id_user"][0]["fullname"].stringValue
            lblNomSong.text = self.shares[indexPath.row]["id_record"][0]["title"].stringValue
            
            imgAlbum.image = UIImage(named: "default_record")
            imgmic.isHidden = false
        }
        
        }
        v.layer.cornerRadius = 10
            
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                     if  SharedPreferences.sharedpref.prefs.integer(forKey: "ISLOGGEDIN") as Int == 0 {
            let view = self.storyboard?.instantiateViewController(withIdentifier: "login") as! ViewController
            DispatchQueue.main.async (execute : {
                
                self.navigationController?.present(view, animated: true, completion: nil)
                
            })
        }
        else {
            
            if Reachability.isConnectedToNetwork() == true {
               
                self.conex.isHidden = true
                self.tableview.isHidden = false
                self.btnrefrech.isHidden = true
                SwiftSpinner.show("Loading...")
                
                Alamofire.request(url,method : .post ).responseJSON {
                    response in
                    switch response.result {
                        
                    case .success(let value) :
                        let json1 = JSON(value)
                        
                        if json1.arrayObject?.count == 0 {
                            SwiftSpinner.hide()
                            
                        }else{
                            SwiftSpinner.hide()
                            self.shares = json1
                            
                            
                            self.tableview.reloadData()
                            
                        }
                    case .failure(let error) :
                        SwiftSpinner.hide()
                        print(error)
                    }
                }
            } else {
                
                self.conex.isHidden = false
                self.tableview.isHidden = true
                self.btnrefrech.isHidden = false

                let alert = CDAlertView(title: " Failed ", message: "No internet conextion", type: .notification  )
                alert.alertBackgroundColor = UIColor("#333333")
                alert.actionSeparatorColor = UIColor("#FF475C")
                alert.tintColor = UIColor("#FF475C")
                alert.titleTextColor = UIColor.white
                alert.messageTextColor = UIColor.white
                let doneAction = CDAlertViewAction(title: "Nevermind 😑")
                doneAction.buttonTextColor = UIColor("#FF475C")
                alert.add(action: doneAction)
                alert.show()
            }
                    }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath:IndexPath = tableview.indexPathForSelectedRow!
        let svc:DetailsViewController=segue.destination as! DetailsViewController
        svc.shares = self.shares[indexPath.row]
        svc.page = "home" 
                   }
    

    func refreshData(sender: UIRefreshControl) {
       
        if Reachability.isConnectedToNetwork() == true {
           
            self.conex.isHidden = true
            self.tableview.isHidden = false
            self.btnrefrech.isHidden = true
            SwiftSpinner.show("Loading...")
            
            Alamofire.request(url,method : .post ).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    let json1 = JSON(value)
                    
                    if json1.arrayObject?.count == 0 {
                        SwiftSpinner.hide()
                        
                    }else{
                        SwiftSpinner.hide()
                        self.shares = json1
                        
                        
                        self.tableview.reloadData()
                        
                    }
                case .failure(let error) :
                    SwiftSpinner.hide()
                    print(error)
                }
            }
             refreshControl.endRefreshing()
        } else {
           
            self.conex.isHidden = false
            self.tableview.isHidden = true
            self.btnrefrech.isHidden = false
            
            let alert = CDAlertView(title: " Failed ", message: "No internet conextion", type: .notification  )
            alert.alertBackgroundColor = UIColor("#333333")
            alert.actionSeparatorColor = UIColor("#FF475C")
            alert.tintColor = UIColor("#FF475C")
            alert.titleTextColor = UIColor.white
            alert.messageTextColor = UIColor.white
            let doneAction = CDAlertViewAction(title: "Nevermind 😑")
            doneAction.buttonTextColor = UIColor("#FF475C")
            alert.add(action: doneAction)
            alert.show()
             refreshControl.endRefreshing()
    }
    }
    @IBAction func refresh(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
                       self.conex.isHidden = true
            self.tableview.isHidden = false
            self.btnrefrech.isHidden = true
            SwiftSpinner.show("Loading...")
            
            Alamofire.request(url,method : .post ).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    let json1 = JSON(value)
                    
                    if json1.arrayObject?.count == 0 {
                        SwiftSpinner.hide()
                        
                    }else{
                        SwiftSpinner.hide()
                        self.shares = json1
                        
                        
                        self.tableview.reloadData()
                        
                    }
                case .failure(let error) :
                    SwiftSpinner.hide()
                    print(error)
                }
            }
             refreshControl.endRefreshing()
        } else {
            
            self.conex.isHidden = false
            self.tableview.isHidden = true
            self.btnrefrech.isHidden = false
            
            let alert = CDAlertView(title: " Failed ", message: "No internet conextion", type: .notification  )
            alert.alertBackgroundColor = UIColor("#333333")
            alert.actionSeparatorColor = UIColor("#FF475C")
            alert.tintColor = UIColor("#FF475C")
            alert.titleTextColor = UIColor.white
            alert.messageTextColor = UIColor.white
            let doneAction = CDAlertViewAction(title: "Nevermind 😑")
            doneAction.buttonTextColor = UIColor("#FF475C")
            alert.add(action: doneAction)
            alert.show()
             refreshControl.endRefreshing()
        }

    }
    
    @IBAction func Logout(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Are u sure to logout ?", preferredStyle: UIAlertControllerStyle.alert )
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            SharedPreferences.sharedpref.prefs.set(0, forKey: "ISLOGGEDIN")
            UserDefaults.init(suiteName: "group.Lyrix")?.setValue("" , forKey: "username")
            
            let view2 = self.storyboard?.instantiateViewController(withIdentifier: "login") as! ViewController
            self.tabBarController?.selectedIndex = 0
            
            DispatchQueue.main.async (execute : {
                
                self.navigationController?.present(view2, animated: true, completion: nil)
            })
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        alert.view.backgroundColor = UIColor("#333333")
        alert.view.tintColor = UIColor("#FF475C")
        

    }
    
}
