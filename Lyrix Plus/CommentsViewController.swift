//
//  CommentsViewController.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 13/03/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
import ImageOpenTransition
import UIColor_Hex_Swift
import CDAlertView
import MapleBacon
extension JSON {
    mutating func merge(other: JSON) {
        if self.type == other.type {
            switch self.type {
            case .dictionary:
                for (key, _) in other {
                    self[key].merge(other: other[key])
                }
            case .array:
                self = JSON(self.arrayValue + other.arrayValue)
            default:
                self = other
            }
        } else {
            self = other
        }
    }
    
    func merged(other: JSON) -> JSON {
        var merged = self
        merged.merge(other: other)
        return merged
    }
}
class CommentsViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{
   
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var tableview: UITableView!
    var comments : JSON  = []
    let url = "http://193.95.44.118/lyrics/getComments.php"
    let url1 = "http://193.95.44.118/lyrics/addComment.php"
    let url2 = "http://193.95.44.118/lyrics/deleteComment.php"
    var id:Int = 0
    var iduser : String = ""
    var verif = "no"
    @IBOutlet weak var labelNotFound: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor("#333333")
        tableview.backgroundColor = UIColor("#333333")
        
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
        if(comments.arrayObject?.count == 0 )
        {
            return 0
        }
        else {
            return (comments.arrayObject?.count)!
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let lblNom:UILabel = cell.viewWithTag(20) as! UILabel
        let img:UIImageView = cell.viewWithTag(10) as! UIImageView
        let lblDate : UILabel = cell.viewWithTag(40) as! UILabel
        let lblComment:UILabel = cell.viewWithTag(30) as! UILabel
        let del : customButton = cell.viewWithTag(111) as! customButton
        if let imageUrl = URL(string: self.comments[indexPath.row]["id_user"][0]["picture"].stringValue) ,let placeholder = UIImage(named: "placeholder"){
            img.setImage(withUrl: imageUrl , placeholder: placeholder)
        }
     // let url = NSURL(string:self.comments[indexPath.row]["id_user"][0]["picture"].stringValue)
       // let data = NSData(contentsOf:url! as URL)
        //img.image = UIImage(data : data as! Data)
        img.layer.cornerRadius = img.frame.size.width / 2
        img.clipsToBounds = true
        lblNom.text = self.comments[indexPath.row]["id_user"][0]["username"].stringValue
        lblDate.text = self.comments[indexPath.row]["date_comment"].stringValue
        lblComment.text = self.comments[indexPath.row]["text"].stringValue
        if ( SharedPreferences.sharedpref.prefs.string(forKey: "id")! == self.comments[indexPath.row]["id_user"][0]["id"].stringValue || SharedPreferences.sharedpref.prefs.string(forKey: "id")! == self.iduser)
        {
            del.isHidden = false
        del.indexPath = indexPath.row
        del.index = indexPath
        del.addTarget(self, action: #selector(CommentsViewController.deleteComment), for: .touchUpInside)
        }
        else {
            del.isHidden = true
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            
        let parameters: [String: Int] = [
            "id_share" : self.id ,
            ]

            SwiftSpinner.show("Loading...")
            
            Alamofire.request(url,method : .post , parameters : parameters).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    let json1 = JSON(value)
                    
                    if json1.arrayObject?.count == 0 {
                        SwiftSpinner.hide()
                        self.labelNotFound.isHidden = false
                        self.tableview.isHidden = true
                        self.commentImg.isHidden = false
                    }else{
                        SwiftSpinner.hide()
                        self.comments = json1
                        
                        
                        self.tableview.reloadData()
                        self.labelNotFound.isHidden = true
                        self.tableview.isHidden = false
                        self.commentImg.isHidden = true
                    }
                case .failure(let error) :
                    SwiftSpinner.hide()
                    print(error)
                }
            }
        
        
    }
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        if verif == "yes"{
            let indexpath = IndexPath(row: ((self.comments.arrayObject?.count)! - 1), section: 0)
            
            return indexpath
        }else{
            let indexpath = IndexPath(row: 0, section: 0)
            return indexpath
        }

    }
   
    
    
    @IBAction func comment(_ sender: Any) {
        if(comment.text == "")
        {
            let alert = CDAlertView(title: "Alert", message: "Enter comment", type: .notification  )
            alert.alertBackgroundColor = UIColor("#333333")
            alert.actionSeparatorColor = UIColor("#FF475C")
            alert.tintColor = UIColor("#FF475C")
            alert.titleTextColor = UIColor.white
            alert.messageTextColor = UIColor.white
            let doneAction = CDAlertViewAction(title: " Nevermind 😑")
            doneAction.buttonTextColor = UIColor("#FF475C")
            alert.add(action: doneAction)
            alert.show()
        }
        else {
      
        let parameters: [String: Any] = [
            "id_share" : self.id ,
            "id_user" : SharedPreferences.sharedpref.prefs.string(forKey: "id")! ,
            "text" : self.comment.text! ,
            ]
        
        
        Alamofire.request(url1,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                let json1 = JSON(value)
        
                self.comments =  self.comments.merged(other: json1)
         
               

           
                self.tableview.beginUpdates()
                self.tableview.insertRows(at: [IndexPath(row: (self.comments.arrayObject?.count)!-1, section: 0)], with: .automatic)
                self.verif = "yes"
            self.tableview.endUpdates()
             self.tableview.reloadData()
                self.tableview.setNeedsLayout()
                self.tableview.scrollToRow(at: IndexPath(row: (self.comments.arrayObject?.count)!-1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)

                self.comment.text = ""
                self.labelNotFound.isHidden = true
                self.tableview.isHidden = false
                self.commentImg.isHidden = true
            case .failure(let error) :
                let alert = CDAlertView(title: "Erreur", message: "Failed to comment", type: .error  )
                alert.alertBackgroundColor = UIColor("#333333")
                alert.actionSeparatorColor = UIColor("#FF475C")
                alert.tintColor = UIColor("#FF475C")
                alert.titleTextColor = UIColor.white
                alert.messageTextColor = UIColor.white
                let doneAction = CDAlertViewAction(title: " Nevermind 😑")
                doneAction.buttonTextColor = UIColor("#FF475C")
                alert.add(action: doneAction)
                alert.show()
                print(error)
            }
        }
        }
        
    }
    
    func deleteComment (sender : customButton)
    {
        
        let parameters: [String: String] = [
            "id_comment" : self.comments[sender.indexPath!]["id"].stringValue ,
                       ]
        
        print (sender.indexPath!)
        Alamofire.request(url2,method : .post , parameters : parameters).responseJSON {
            response in
            switch response.result {
                
            case .success(let value) :
                print (value)
                if(value as! NSNumber == 1)
                {
                    self.comments.arrayObject?.remove(at: sender.indexPath!)
                     self.tableview.beginUpdates()
                   self.tableview.deleteRows(at: [sender.index], with: .automatic)
                    self.tableview.endUpdates()
                    self.tableview.reloadData()
                       self.tableview.setNeedsLayout()
                }
                else {
                    print("heeey")
                }
            
            case .failure(let error) :
            print(error)
            }
        }

    }
    }
