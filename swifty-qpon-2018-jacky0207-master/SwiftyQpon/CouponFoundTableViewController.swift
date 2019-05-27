//
//  CouponFoundTableViewController.swift
//  SwiftyQpon
//
//  Created by 17200113 on 10/10/2018.
//  Copyright © 2018 Jacky Lam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class CouponFoundTableViewController: UITableViewController {
    var mall : String = ""
    var coin : Int = -9999
    var direction : String = ""
    
    var coupons = [Coupon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = self.mall
        
        let config = Realm.Configuration(
            // Get the URL to the bundled file
            fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"),
            // Open the file in read-only mode as application bundles are not writeable
            readOnly: true)
        
        // Open the Realm with the configuration
        let realm = try! Realm(configuration: config)
        
        var realmResults:Results<Coupon>?
        if (mall != "") {
            realmResults = realm.objects(Coupon.self).filter("mall == '\(mall)'")
            
            for result in realmResults! {
                self.coupons.append(result)
            }
        }
        else if (coin != -9999 && direction != "") {
            realmResults = realm.objects(Coupon.self)
            if (direction == "<")
            {
                for result in realmResults!
                {
                    if (Int(result.coin!)! >= self.coin)
                    {
                        continue
                    }
                    self.coupons.append(result)
                }
            }
            else
            {
                for result in realmResults!
                {
                    if (Int(result.coin!)! < self.coin)
                    {
                        continue
                    }
                    self.coupons.append(result)
                }
            }
        }
        
        print(self.coupons)
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
        return self.coupons.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponFoundCell", for: indexPath)

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

    // MARK: - Navigation

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
