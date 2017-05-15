//
//  ArtistController.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 4/19/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna
import SwiftSpinner
import SDWebImage
import SystemConfiguration
import CDAlertView
class ArtistController:UIViewController{

    
    
    
    @IBOutlet weak var artistName: UILabel!
    var artistNom = ""
    
    
    
    
    @IBOutlet weak var artistBio: UITextView!
    @IBOutlet weak var artistImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SwiftSpinner.show("Loading ...")
        
        self.artistName.text = self.artistNom
        
        self.artistImage.layer.cornerRadius = self.artistImage.frame.size.width / 2
        
        self.artistImage.clipsToBounds = true

        self.getArtistPicture(artistnom: self.artistNom, image: self.artistImage)
        
        self.getBiography(artist:self.artistNom,bio:self.artistBio)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

        
    
    
    func getBiography(artist:String, bio:UITextView){
        
        
        //wiki-content
        var ur = "https://www.last.fm/music/"
        let ur2 = artist.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        ur.append(ur2!)
        ur.append("/+wiki")
        
        if (self.isInternetAvailable()){
            Alamofire.request(ur).responseString { response in
                print("\(response.result.isSuccess)")
                if let html = response.result.value {
                    //self.parseHTML(html: html)
                    
                    if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                        
                        for show in doc.css("div[class^='wiki-content']"){
                            var omar = (show.content)!
                            
                            omar = omar.replacingOccurrences(of: "  ", with: "")
                            bio.text = omar
                            
                            SwiftSpinner.hide()
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
