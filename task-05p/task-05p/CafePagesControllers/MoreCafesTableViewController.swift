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

protocol UpdateCafeListDelegate {
    func addCafeToList(toAdd: Cafe)
}

class MoreCafesTableViewController: UITableViewController {
    @IBOutlet weak var sortRatingBtn: UIBarButtonItem!
    @IBOutlet weak var sortNameBtn: UIBarButtonItem!
    
    var cafe = [Cafe]()
    var onlineCafes = [OnlineCafe]()
    var onlineCafeJSON : JSON? = nil
    var searchController = UISearchController(searchResultsController: nil)
    var filteredOnlineCafes = [OnlineCafe]()
    var nameSort = true
    var ratingSort = true
    var delegate: UpdateCafeListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOnlineCafeData()
        setupSearchController()
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
                    let isFavourite = false
                    let image = object["restaurant"]["featured_image"].stringValue
                    
                    let onlineCafe = OnlineCafe(name: name, rating: rating, latitude: latitude, longitude: longitude, location: location, suburb: suburb, phone: phone, isFavourite: isFavourite, image: image)
                    self.onlineCafes.append(onlineCafe)
                    //print("here + \(address) + \(suburb)")
                }
            } else {
                print("API loading error")
                let alert = UIAlertController(title: "Error", message: "Opps, something went wrong. Please try again later." , preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "homepage") as? TableViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                })
                alert.addAction(action)
                DispatchQueue.main.async(execute: {self.present(alert, animated: true, completion: nil)})
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func handleAddCafe(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let selectedPath = tableView.indexPathForRow(at: point)
        let selectedCafe = onlineCafes[(selectedPath?.row)!]
        print(selectedCafe)
        let object = Cafe(name: selectedCafe.name, rating: selectedCafe.rating, location: selectedCafe.location, suburb: selectedCafe.suburb, phone: selectedCafe.phone, latitude: selectedCafe.latitude, longitude: selectedCafe.longitude, isFavourite: selectedCafe.isFavourite)
            delegate!.addCafeToList(toAdd: object)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredOnlineCafes.count
        }
        return onlineCafes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(named: "add"), for: .normal)
        addButton.frame = CGRect(x: 350, y: 50, width: 30, height: 30)
        addButton.tintColor = UIColor.lightGray
        addButton.addTarget(self, action: #selector(handleAddCafe), for: .touchUpInside)
        cell.addSubview(addButton)
        
        if isFiltering() {
            cell.textLabel?.text = filteredOnlineCafes[indexPath.row].name
            cell.detailTextLabel?.text = "Rating: " + String(filteredOnlineCafes[indexPath.row].rating)
        } else {
            cell.textLabel?.text = onlineCafes[indexPath.row].name
            cell.detailTextLabel?.text = "Rating: " + String(onlineCafes[indexPath.row].rating)
        }
        return cell
    }
    
    // MARK: - Add a search tab
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search cafe from Zomato"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredOnlineCafes = onlineCafes.filter({( onlineCafe : OnlineCafe) -> Bool in return onlineCafe.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    @IBAction func sortRatingClicked(_ sender: Any) {
        if (ratingSort) {
            onlineCafes.sort(by: {$0.rating > $1.rating })
            ratingSort = false
        } else {
            onlineCafes.sort(by: {$0.rating < $1.rating })
            ratingSort = true
        }
        self.tableView.reloadData()
    }
    
    @IBAction func sortNameClicked(_ sender: Any) {
        if (nameSort) {
            onlineCafes.sort { $0.name < $1.name }
            nameSort = false
        } else {
            onlineCafes.sort { $0.name > $1.name }
            nameSort = true
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "onlineCafeView") as? OnlineViewController
        if isFiltering() {
            vc!.onlineCafe = filteredOnlineCafes[indexPath.row]
            navigationController?.pushViewController(vc!, animated: true)
            print("here")
        } else {
            vc!.onlineCafe = onlineCafes[indexPath.row]
            navigationController?.pushViewController(vc!, animated: true)
            print("there")
        }
    }
}

extension MoreCafesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
