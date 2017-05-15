// The MIT License (MIT)
//
// Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
import SDWebImage
import SystemConfiguration
import CDAlertView
class CityGuideViewController: UIViewController {
    
    var musix : JSON = []
    var artist = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.artist = artist.replacingOccurrences(of: " ", with: "%20")
        getArtistTopSongs(keyWord: self.artist)
    }
  @IBOutlet weak var collectionView: UICollectionView!
  
    func getArtistTopSongs(keyWord:String){
        
        
        if (self.isInternetAvailable()){
            let url:String="http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist="+keyWord+"&api_key=2216aa2485da699f4d04a85899b2ce30&format=json&limit=10"
            
            Alamofire.request(url,method : .post ).responseJSON {
                response in
                switch response.result {
                    
                case .success(let value) :
                    
                    let json1 = JSON(value)
                    
                    //print (json1["feed"]["entry"])
                    self.musix = json1["topalbums"]["album"]
                    
                    print("***")
                    //print(self.musix)
                    
                    self.collectionView.reloadData()
                    
                    
                    //SwiftSpinner.hide()
                    
                case .failure(let error) :
                    //SwiftSpinner.hide()
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
}

extension CityGuideViewController:UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return musix.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) )
    

    //let name:UILabel = cell.viewWithTag(601) as! UILabel
    let picture:UIImageView = cell.viewWithTag(602) as! UIImageView
    
    //name.text = musix[indexPath.row]["name"].stringValue
    
    let url1 = musix[indexPath.row]["image"][3]["#text"].stringValue
    
    picture.sd_setImage(with: URL(string: url1), placeholderImage: UIImage(named: "compact-disk"))
    
    
    return cell
  }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "DetailAlbum") as! DetailAlbum
        nextViewController.link = musix[indexPath.row]["image"][3]["#text"].stringValue
        nextViewController.mbid = musix[indexPath.row]["mbid"].stringValue
       
        
        
        self.show(nextViewController, sender: nil)
        
        
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
