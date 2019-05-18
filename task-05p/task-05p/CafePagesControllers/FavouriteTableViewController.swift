//
//  FavouriteTableViewController.swift
//  D task
//
//  Created by Lamphai Intathep on 5/5/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import UIKit

class FavouriteTableViewController: UITableViewController {

    var favList = [Cafe]()
    var markedFavourite = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        selectOnlyFavourtie()
    }
    
    func selectOnlyFavourtie() {
        var i = 0
        while i <= favList.count - 1 {
            if (favList[i].isFavourite == true) {
                let dict = ["name": favList[i].name, "rating": favList[i].rating, "latitude": favList[i].latitude, "longitude": favList[i].longitude, "location": favList[i].location, "suburb": favList[i].suburb, "isFavourite": favList[i].isFavourite, "phone": favList[i].phone] as [String : Any]
                markedFavourite.append(dict)
            }
            i += 1
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markedFavourite.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let info = markedFavourite[indexPath.row]
        cell.textLabel?.text = info["name"] as? String
        cell.detailTextLabel?.text = info["rating"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "showSelectedCafe") as? CafeDetailsViewController
        let name = markedFavourite[indexPath.row]["name"]
        let rating = markedFavourite[indexPath.row]["rating"]
        let latitude = markedFavourite[indexPath.row]["latitude"]
        let longitude = markedFavourite[indexPath.row]["longitude"]
        let phone = markedFavourite[indexPath.row]["phone"]
        let suburb = markedFavourite[indexPath.row]["suburb"]
        let location = markedFavourite[indexPath.row]["location"]
        let toSend = Cafe(name: name as! String, rating: rating as! Double, location: location as! String, suburb: suburb as! String, phone: phone as! String, latitude: latitude as! Double, longitude: longitude as! Double, isFavourite: true)
        vc!.selectedCafe = toSend
        navigationController?.pushViewController(vc!, animated: true)
    }
}
