//
//  SharedPreferences.swift
//  Lyrix Plus
//
//  Created by Ahmed Haddar on 16/02/2017.
//  Copyright © 2017 Ahmed Haddar. All rights reserved.
//

import Foundation
class SharedPreferences {
    
    
    
    static var sharedpref  = SharedPreferences ()
    var prefs:UserDefaults = UserDefaults.standard
    
    
    private init() {}
    
    var id : String!
    var username : String!
    var fullName : String!
    var gender : String!
    var email : String!
    var birthday : String!
    var location : String!
    var picture : String!
    var password : String!
    var isLoggedin : Int!
   
    
    func setSharedprefs (email:String,id:String,username:String,gender:String, birthday: String,location: String,fullName : String , picture : String ,password : String,isLogged:Int){
        
        prefs.set(email, forKey: "email")
        prefs.set(id, forKey: "id")
        prefs.set(username, forKey: "username")
        prefs.set(gender, forKey: "gender")
        prefs.set(birthday, forKey: "birthday")
        prefs.set(location, forKey: "location")
        prefs.set(fullName, forKey: "fullname")
        prefs.set(picture, forKey: "picture")
        prefs.set(password, forKey: "password")

       
        
        prefs.set(isLogged, forKey: "ISLOGGEDIN")
        
        prefs.synchronize()
        
        
        
    }
    
}
