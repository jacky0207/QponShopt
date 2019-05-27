//
//  AccountTableViewController.swift
//  SwiftyQpon
//
//  Created by 17200113 on 10/10/2018.
//  Copyright © 2018 Jacky Lam. All rights reserved.
//

import UIKit
import Alamofire

class AccountViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var redeemedCoupon: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    @IBAction func Logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "userImage")
        
        login.isHidden = false
        redeemedCoupon.isHidden = true
        logout.isHidden = true
        
        let url = UserDefaults.standard.string(forKey: "userImage") ?? Optional("https://blog.xamarin.com/wp-content/uploads/2017/05/GuestLectures.png")
        
        if let unwrappedUrl = url {
            
            Alamofire.request(unwrappedUrl).responseData {
                response in
                
                if let data = response.result.value {
                    self.image.image = UIImage(data: data, scale:1)
                }
            }
        }
        self.username.text = "Guest"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "userId") == nil
        {
            login.isHidden = false
            redeemedCoupon.isHidden = true
            logout.isHidden = true
        }
        else
        {
            login.isHidden = true
            redeemedCoupon.isHidden = false
            logout.isHidden = false
        }
        
        let url = UserDefaults.standard.string(forKey: "userImage") ?? Optional("https://blog.xamarin.com/wp-content/uploads/2017/05/GuestLectures.png")
        
        if let unwrappedUrl = url {
            
            Alamofire.request(unwrappedUrl).responseData {
                response in
                
                if let data = response.result.value {
                    self.image.image = UIImage(data: data, scale:1)
                }
            }
        }
        self.username.text = UserDefaults.standard.string(forKey: "username") ?? "Guest"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
