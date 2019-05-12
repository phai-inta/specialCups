//
//  AddCafeTableViewController.swift
//  D task
//
//  Created by Lamphai Intathep on 10/5/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddCafeTableViewController: UITableViewController {
    
    var cafeList = [Cafe]()
    var onlineCafes = [OnlineCafe]()//[OnlineCafe]()
    var onlineCafeJSON : JSON? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        getOnlineCafeData()
        //print(cafeList)
    }
    
    func getOnlineCafeData() {
        let zomatoUrl = "https://developers.zomato.com/api/v2.1/search?q=australia&cuisines=161&category=6"
        
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "user-key" : "8595b315ae3b79244fe14b5979454b0e"
        ]
        
        Alamofire.request(zomatoUrl, method: .get, parameters: ["":""], encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                print("API loading successful")
                self.onlineCafeJSON = JSON(response.result.value!)
                //print(self.onlineCafeJSON!)
                for (_, object) in self.onlineCafeJSON!["restaurants"] {
                    let name = object["restaurant"]["name"].stringValue
                    let rating = object["restaurant"]["user_rating"]["aggregate_rating"].doubleValue
                    let latitude = object["restaurant"]["location"]["latitude"].doubleValue
                    let longitude = object["restaurant"]["location"]["longitude"].doubleValue
                    let location = object["restaurant"]["location"]["address"].stringValue
                    let suburb = object["restaurant"]["location"]["locality"].stringValue
                    let phone = ""
                    let special = ""
                    let isFavourite = false
                    
                    let onlineCafe = OnlineCafe(name: name, rating: rating, latitude: latitude, longitude: longitude, location: location, suburb: suburb, phone: phone, special: special, isFavourite: isFavourite)
                    self.onlineCafes.append(onlineCafe)
                    //print("here + \(address) + \(suburb)")
                }
            } else {
                print("API loading error")
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlineCafes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = onlineCafes[indexPath.row].name
        cell.detailTextLabel?.text = String(onlineCafes[indexPath.row].rating)
        
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(named: "add"), for: .normal)
        addButton.frame = CGRect(x: 350, y: 50, width: 30, height: 30)
        addButton.tintColor = UIColor.lightGray
        addButton.addTarget(self, action: #selector(handleAddCafe), for: .touchUpInside)
        cell.contentView.addSubview(addButton)
        return cell
    }
    
    @objc func handleAddCafe(sender: UIButton) {
        // MARK: to get the tapped row
        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let selectedPath = tableView.indexPathForRow(at: point)
        
        // MARK: change the add button color when clicked
        if sender.tintColor == UIColor.lightGray {
            sender.tintColor = UIColor.blue
            
            // MARK: add selected online cafe to the cafe list
            let selectedCafe = onlineCafes[(selectedPath?.row)!]
            let object = Cafe(name: selectedCafe.name, rating: selectedCafe.rating, location: selectedCafe.location, suburb: selectedCafe.suburb, phone: selectedCafe.phone, special: selectedCafe.special, latitude: selectedCafe.latitude, longitude: selectedCafe.longitude, isFavourite: selectedCafe.isFavourite)
            cafeList.append(object)
            //print(cafeList)
        } else {
            sender.tintColor = UIColor.lightGray
        }
        
        //MARK: save changes to the cafe list
        do {
            let fm = FileManager.default
            let docurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let cafeUrl = docurl.appendingPathComponent("cafes.json")
            try fm.removeItem(at: cafeUrl)
            let jsonData = try! JSONEncoder().encode(cafeList)
            try jsonData.write(to: cafeUrl, options: .atomic)
            print("Selected online cafe saved successfully")
        } catch {
            print("Cannot save selected online cafe to the file")
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
