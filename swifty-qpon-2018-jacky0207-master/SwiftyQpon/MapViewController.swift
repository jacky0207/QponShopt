//
//  MapViewController.swift
//  SwiftyQpon
//
//  Created by 17200113 on 10/10/2018.
//  Copyright © 2018 Jacky Lam. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Foundation

class MapViewController: UIViewController {
    var mall : String = ""
    
    var xAxis : Double = 9999
    var yAxis : Double = 9999
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func bt_click(_ sender: Any) {
        let nextLocation = CLLocation(latitude: self.xAxis, longitude: self.yAxis)
        
        let regionRadius: CLLocationDistance = 300

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            nextLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)

        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = mall
        
        let malls = Mall()
        let json = JSON(malls.location)
        
        let locationString : String = json[mall].stringValue
        var location : [String] = locationString.components(separatedBy: ", ")
        self.xAxis = Double(location[0])!
        self.yAxis = Double(location[1])!
        
        let config = Realm.Configuration(
            // Get the URL to the bundled file
            fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"),
            // Open the file in read-only mode as application bundles are not writeable
            readOnly: true)

        // Open the Realm with the configuration
        let realm = try! Realm(configuration: config)

        var realmResults:Results<Mall>?
        realmResults = realm.objects(Mall.self)

        for result in realmResults! {
//            self.location = result
            print(result)
        }

        // set initial location
        let initialLocation = CLLocation(latitude: self.xAxis, longitude: self.yAxis)

        let regionRadius: CLLocationDistance = 300

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            initialLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)

        mapView.setRegion(coordinateRegion, animated: true)

        mapView.showsUserLocation = true

        let waiHang = MKPointAnnotation()

        waiHang.coordinate = CLLocationCoordinate2D(latitude: self.xAxis, longitude: self.yAxis)
        waiHang.title = "Wai Hang"
        waiHang.subtitle = "Sports Center"

        mapView.addAnnotation(waiHang)
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
