//
//  LoginViewController.swift
//  SwiftyQpon
//
//  Created by 17200113 on 11/10/2018.
//  Copyright © 2018 Jacky Lam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginButtonClicked(_ sender: Any) {
//        print(username.text!);
        let parameters : Parameters = ["username": username.text!, "password": password.text!]
        
        Alamofire.request("http://localhost:1337/user/loginJson", method: .post, parameters: parameters)
            .responseJSON { response in
            switch response.result {
                
                case .success(let value):
                    let json : JSON = JSON(value)
                    print(json["user"]["id"])
                    print(json["user"]["image"])
                    UserDefaults.standard.set(json["user"]["id"].intValue, forKey: "userId")
                    UserDefaults.standard.set(self.username.text!, forKey: "username")
                    UserDefaults.standard.set(json["user"]["image"].stringValue, forKey: "userImage")
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                    
                    let alertController = UIAlertController(title: "Login Failure", message: "No such user", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
