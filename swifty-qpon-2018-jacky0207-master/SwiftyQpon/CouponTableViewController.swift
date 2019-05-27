//
//  CouponTableViewController.swift
//  SwiftyQpon
//
//  Created by 17200113 on 10/10/2018.
//  Copyright © 2018 Jacky Lam. All rights reserved.
//

import UIKit

class CouponTableViewController: UITableViewController {
    var hkIsland = ["IFC", "金鐘太古廣場", "時代廣場", "銅鑼灣世貿中心", "太古城中心", "杏花新城商場", "數碼港商場"]
    var kowloon = ["圓方", "Elements", "Harbour", "City", "海港城", "美麗華商場", "黃埔新天地", "又一城", "朗豪坊商場", "新世紀廣場", "奧海城", "MegaBox", "德福廣場商場", "荷里活廣場", "APM"]
    var newTerritories = ["荃新天地", "荃灣廣場", "悅來坊商場", "綠楊坊商場", "新都會廣場", "青衣城商場", "屯門市廣場", "東港城", "君薈坊商場", "連理街", "沙田新城市廣場", "大埔超級城"]
    var numberOfRowsAtSection: [Int] = []
    
    var mallArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.numberOfRowsAtSection = [self.hkIsland.count, self.kowloon.count, self.newTerritories.count]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.numberOfRowsAtSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return self.hkIsland.count + self.kowloon.count + self.newTerritories.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath)
        
        if indexPath.section == 0
        {
            self.mallArray = hkIsland
        }
        else if indexPath.section == 1
        {
            self.mallArray = kowloon
        }
        else if indexPath.section == 2
        {
            self.mallArray = newTerritories
        }

        cell.textLabel?.text = self.mallArray[indexPath.row]
        
//        if (indexPath.row < self.hkIsland.count + self.kowloon.count + self.newTerritories.count) {
//            if (indexPath.row < self.hkIsland.count) {
//                cell.textLabel?.text = self.hkIsland[indexPath.row]
//            }
//            else if (indexPath.row < self.hkIsland.count + self.kowloon.count) {
//                cell.textLabel?.text = self.kowloon[indexPath.row - self.hkIsland.count]
//            }
//            else {
//                cell.textLabel?.text = self.newTerritories[indexPath.row - self.hkIsland.count - self.kowloon.count]
//            }
//        }
        
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
        if segue.identifier == "couponFound" {
            
            if let viewController = segue.destination as? CouponFoundTableViewController {
                
                var selectedIndex = tableView.indexPathForSelectedRow!
//
//                if (selectedIndex.row < self.hkIsland.count) {
//                    viewController.mall = self.hkIsland[selectedIndex.row]
//                }
//                else if (selectedIndex.row < self.hkIsland.count + self.kowloon.count) {
//                    viewController.mall = self.kowloon[selectedIndex.row - self.hkIsland.count]
//                }
//                else {
//                    viewController.mall = self.newTerritories[selectedIndex.row - self.hkIsland.count - self.kowloon.count]
//                }
                if selectedIndex.section == 0
                {
                    viewController.mall = self.hkIsland[selectedIndex.row]
                }
                else if selectedIndex.section == 1
                {
                    viewController.mall = self.kowloon[selectedIndex.row]
                }
                else if selectedIndex.section == 2
                {
                    viewController.mall = self.newTerritories[selectedIndex.row]
                }
            }
        }
    }

}
