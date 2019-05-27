//
//  RedeemedCouponTableViewController.swift
//  SwiftyQpon
//
//  Created by 17200113 on 11/10/2018.
//  Copyright © 2018 Jacky Lam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RedeemedCouponTableViewController: UITableViewController {
    var coupons = [Coupon]()

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
        let id = UserDefaults.standard.string(forKey: "userId")
        let parameters : Parameters = ["id": id!]
        
        Alamofire.request("http://localhost:1337/user/mycouponJson", method: .post, parameters: parameters)
            .responseJSON { response in
                var json = JSON(response.result.value!)["qpons"]
                for index in 0..<json.count {
//                    print(json[index])
                    let coupon = Coupon()
                    coupon.id.value = json[index]["id"].intValue
                    coupon.title = json[index]["title"].stringValue
                    coupon.restaurant = json[index]["restaurant"].stringValue
                    self.coupons.append(coupon)
                }
            self.tableView.reloadData()
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.coupons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCouponCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.coupons[indexPath.row].restaurant! + " - " + self.coupons[indexPath.row].title!
        
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "couponDetail" {
            
            if let viewController = segue.destination as? DetailViewController {
                
                var selectedIndex = tableView.indexPathForSelectedRow!
                
                viewController.couponId = coupons[selectedIndex.row].id.value as Int? ?? -9999
            }
        }
    }

}
