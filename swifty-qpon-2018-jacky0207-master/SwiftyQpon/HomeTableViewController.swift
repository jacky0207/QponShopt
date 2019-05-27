//
//  HomeTableViewController.swift
//  SwiftyQpon
//
//  Created by Jacky Lam on 7/10/2018.
//  Copyright © 2018 Jacky Lam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class HomeTableViewController: UITableViewController {
//    var validCoupons:Results<Coupon>?
    
    var hkIslandValidCoupons = [Coupon]()
    var kowloonValidCoupons = [Coupon]()
    var newTerritoriesValidCoupons = [Coupon]()
    
    var numberOfRowsAtSection: [Int] = []
    
    var couponsArray = [Coupon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(downloadJson), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
		
        downloadJson()
    }
	
    @objc func downloadJson() {
		
        // The Realm + Alamofire codes in `viewDidLoad()`
        let url = "http://localhost:1337/visitor/validQPonJson"
        let realm = try! Realm()
		
        Alamofire.request(url, method: .get).validate().responseJSON { response in
			
//            print("Result: \(response.result)") // response serialization result
			
            switch response.result {

            case .success(let value):
                // self.json = JSON(value)         // deserialization
                // print("A record: \(self.json?[0]["name"].stringValue ?? "No Data" )")

                let json:JSON = JSON(value)

                // Delete all objects from the realm
                try! realm.write {
                    realm.deleteAll()
                }

                for index in 0..<json.count {

                    let coupon = Coupon()
                    coupon.id.value = json[index]["id"].intValue
                    coupon.title = json[index]["title"].stringValue
                    coupon.restaurant = json[index]["restaurant"].stringValue
                    coupon.district = json[index]["district"].stringValue
                    coupon.mall = json[index]["mall"].stringValue
                    coupon.image = json[index]["image"].stringValue
                    coupon.coin = json[index]["coin"].stringValue
                    coupon.till = json[index]["till"].stringValue
                    coupon.quota = json[index]["quota"].stringValue
                    coupon.details = json[index]["details"].stringValue
                    
                    try! realm.write {
                        realm.add(coupon)
                    }
                    
                    if (coupon.district == "HK Island")
                    {
                        self.hkIslandValidCoupons.append(coupon)
                    }
                    else if (coupon.district == "Kowloon")
                    {
                        self.kowloonValidCoupons.append(coupon)
                    }
                    else if (coupon.district == "New Territories")
                    {
                        self.newTerritoriesValidCoupons.append(coupon)
                    }
                }
                
                self.numberOfRowsAtSection = [self.hkIslandValidCoupons.count, self.kowloonValidCoupons.count, self.newTerritoriesValidCoupons.count]

//                self.validCoupons = realm.objects(Coupon.self)

//                print("\(self.validCoupons!.count)")

                self.tableView.reloadData()

            case .failure(let error):
                print(error)
            }
        }
		
        refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        return 1
        return self.numberOfRowsAtSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return self.validCoupons?.count ?? 0
        return self.numberOfRowsAtSection[section]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "HK Island"
        }
        else if section == 1
        {
            return "Kowloon"
        }
        else if section == 2
        {
            return "New Territories"
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)

		// Configure the cell...
        
        if indexPath.section == 0
        {
            self.couponsArray = hkIslandValidCoupons
        }
        else if indexPath.section == 1
        {
            self.couponsArray = kowloonValidCoupons
        }
        else if indexPath.section == 2
        {
            self.couponsArray = newTerritoriesValidCoupons
        }
        
        if let cellDistrict = cell.viewWithTag(100) as? UILabel {
            cellDistrict.text = ""
        }
		if let cellImage = cell.viewWithTag(101) as? UIImageView {
//            let url = validCoupons?[indexPath.row]["image"] as? String
            let url = couponsArray[indexPath.row]["image"] as? String
			
			if let unwrappedUrl = url {
				
				Alamofire.request(unwrappedUrl).responseData {
					response in
					
					if let data = response.result.value {
						cellImage.image = UIImage(data: data, scale:1)
					}
				}
			}
			
		}
		if let cellRestaurant = cell.viewWithTag(102) as? UILabel {
//            cellRestaurant.text = validCoupons?[indexPath.row]["restaurant"] as? String
            cellRestaurant.text = couponsArray[indexPath.row]["restaurant"] as? String
		}
		if let cellTitle = cell.viewWithTag(103) as? UILabel {
//            cellTitle.text = validCoupons?[indexPath.row]["title"] as? String
            cellTitle.text = couponsArray[indexPath.row]["title"] as? String
		}
		if let cellCoin = cell.viewWithTag(104) as? UILabel {
//            let text = validCoupons?[indexPath.row]["coin"] as? String ?? ""
            let text = couponsArray[indexPath.row]["coin"] as? String ?? ""
            cellCoin.text = "Coins: " + text
		}

		return cell
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
        if segue.identifier == "couponDetail" {
			
            if let viewController = segue.destination as? DetailViewController {
				
                var selectedIndex = tableView.indexPathForSelectedRow!
				
//                viewController.couponId = validCoupons?[selectedIndex.row].id.value as Int? ?? -9999
                
                var coupon = Coupon()
                
                if selectedIndex.section == 0
                {
                    coupon = self.hkIslandValidCoupons[selectedIndex.row]
                }
                else if selectedIndex.section == 1
                {
                    coupon = self.kowloonValidCoupons[selectedIndex.row]
                }
                else if selectedIndex.section == 2
                {
                    coupon = self.newTerritoriesValidCoupons[selectedIndex.row]
                }
                viewController.couponId = coupon.id.value!
            }
        }
    }


}
