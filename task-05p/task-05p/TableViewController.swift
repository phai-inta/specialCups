//
//  TableViewController.swift
//  task-07p
//
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var cafes = [Cafe]()
    var filteredCafes = [Cafe]()
    var searchController = UISearchController(searchResultsController: nil)
    var acsSort = true
    var ratingSort = true
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var sortByName: UIBarButtonItem!
    @IBOutlet weak var sortByRating: UIBarButtonItem!
    @IBOutlet weak var allCafesInMap: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadFile()
        setupSearchController()
    }
    
    @IBAction func sortByNamePressed(_ sender: Any) {
        if (acsSort) {
            cafes.sort { $0.name < $1.name }
            acsSort = false
        } else {
            cafes.sort { $0.name > $1.name }
            acsSort = true
        }
        self.tableView.reloadData()
    }
    
    @IBAction func sortByRatingPressed(_ sender: Any) {
        if (ratingSort) {
            cafes.sort(by: {$0.rating > $1.rating })
            ratingSort = false
        } else {
            cafes.sort(by: {$0.rating < $1.rating })
            ratingSort = true
        }
        self.tableView.reloadData()
    }
    
    @IBAction func showAllCafesInMap(_ sender: Any) {
        var newCafeDict: [[String: Any]] = []
        var i = 0
        while i <= cafes.count - 1 {
            let cafeDict: [String: Any] = ["name": cafes[i].name,
                                           "latitude": cafes[i].coordinate.latitude,
                                           "longitude": cafes[i].coordinate.longitude]
            newCafeDict.append(cafeDict)
            i += 1
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "showAllMaps") as? AllMapViewController
            vc!.cafeDict = newCafeDict
            navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setupSearchController() {
        
        // MARK: - Add a search tab
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search cafe"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        // MARK: - Add a scope buttons
        searchController.searchBar.scopeButtonTitles = ["All", "Black & White", "Filter", "Cold Brew"]
        searchController.searchBar.delegate = self
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .darkGray
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: - Download JSON
    func downloadFile() {
        do {
            let path = Bundle.main.url(forResource: "cafes", withExtension: "json")
            let fm = FileManager.default
            let docurl = try fm.url(for:.documentDirectory,
                                    in: .userDomainMask, appropriateFor: nil, create: false)

            let destinationFileUrl = docurl.appendingPathComponent("cafes.json")
            try? fm.removeItem(at: destinationFileUrl)
            let filePath = destinationFileUrl.path
            //print(docurl)

            if fm.fileExists(atPath: filePath) {
                //try fm.removeItem(at: myfile)
                print("File found")
            } else {
                try fm.copyItem(at: path!, to: destinationFileUrl)
                print("Copy succeeded")
            }
            
            let cafedata = fm.contents(atPath: filePath)
            let cafe = try JSONDecoder().decode([Cafe].self, from: cafedata!)
            self.cafes = cafe
            //print(filePath)
        } catch {
            print("Downloading error")
        }
    }
    
    // MARK: - Filter by searching in search textfield or scope buttons
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCafes = cafes.filter({( cafe : Cafe ) -> Bool in
            let doesCategoryMatch = (scope == "All" || (cafe.special == scope))
            
            if searchController.searchBar.text == "" {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && cafe.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (searchController.searchBar.text != "" ||
            searchBarScopeIsFiltering)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCafes.count
        }
        return cafes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if isFiltering() {
            cell.textLabel?.text = filteredCafes[indexPath.row].name
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = "Rating: " + String(filteredCafes[indexPath.row].rating)
            return cell
        } else {
            cell.textLabel?.text = cafes[indexPath.row].name
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = "Rating: " + String(cafes[indexPath.row].rating)
            return cell
        }
    }
    
    // MARK: - Sorting
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    var lastContentOffset: CGFloat = 0
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // MARK: - Segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "showSelectedCafe") as? CafeDetailsViewController
        if isFiltering() {
            vc!.selectedCafe = filteredCafes[indexPath.row]
            navigationController?.pushViewController(vc!, animated: true)
        } else {
            vc!.selectedCafe = cafes[indexPath.row]
            navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension TableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let selectedScope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchBar.text!, scope: selectedScope)
    }
}

extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
