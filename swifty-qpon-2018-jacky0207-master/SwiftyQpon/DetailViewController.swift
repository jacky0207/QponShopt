//
//  DetailViewController.swift
//  SwiftyQpon
//
//  Created by 17200113 on 11/10/2018.
//  Copyright © 2018 Jacky Lam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class DetailViewController: UIViewController {
    var couponId : Int = -9999
    
//    var coupon : Coupon?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var details: UILabel!
    
    @IBOutlet weak var redeem: UIButton!
    @IBAction func RedeemCoupon(_ sender: Any) {
        let alert = UIAlertController(title: "Do you sure?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let parameters : Parameters = ["id": self.couponId, "userId": UserDefaults.standard.string(forKey: "userId") ?? ""]
            
            Alamofire.request("http://localhost:1337/user/addSuperviseeJson", method: .post, parameters: parameters)
                .responseJSON { response in
                    switch response.result {
                        
                    case .success(let value):
                        let message = JSON(value)["message"].stringValue
                        let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        if (message == "Supervisee added.")
                        {
                            self.redeem.isHidden = true
                        }
                    case .failure(let error):
                        print(error)
                        
                        let alertController = UIAlertController(title: "Coupon Not Found", message: "No such coupon", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let config = Realm.Configuration(
            // Get the URL to the bundled file
            fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"),
            // Open the file in read-only mode as application bundles are not writeable
            readOnly: true)

        // Open the Realm with the configuration
        let realm = try! Realm(configuration: config)

        var realmResult:Coupon?
        realmResult = realm.object(ofType: Coupon.self, forPrimaryKey: couponId)

//        self.coupon = realmResult
        let coupon : Coupon? = realmResult

        // Configure the cell...
        let url = coupon?["image"] as? String

        if let unwrappedUrl = url {

            Alamofire.request(unwrappedUrl).responseData {
                response in

                if let data = response.result.value {
                    self.image.image = UIImage(data: data, scale:1)
                }
            }
        }

        self.restaurant.text = coupon?["restaurant"] as? String
        self.details.text = coupon?["details"] as? String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "userId") == nil
        {
            self.redeem.isHidden = true
        }
        else
        {
            var redeemed = false
            
            let parameters : Parameters = ["id": couponId, "userId": UserDefaults.standard.string(forKey: "userId") ?? ""]
            
            Alamofire.request("http://localhost:1337/visitor/detailJson", method: .post, parameters: parameters)
                .responseJSON { response in
                    switch response.result {
                        
                    case .success(let value):
                        let json : JSON = JSON(value)
                        redeemed = json["redeemed"].boolValue
                        self.redeem.isHidden = redeemed
                    case .failure(let error):
                        print(error)
                        
                        let alertController = UIAlertController(title: "Coupon Not Found", message: "No such coupon", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
            }
        }
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
