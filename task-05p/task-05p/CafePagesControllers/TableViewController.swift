//  TableViewController.swift
//  D task
//  Copyright © 2019 Lamphai Intathep. All rights reserved.

import UIKit

class TableViewController: UITableViewController {
    var cafes = [Cafe]()
    var filteredCafes = [Cafe]()
    var searchController = UISearchController(searchResultsController: nil)
    var acsSort = true
    var ratingSort = true
    
    @IBOutlet weak var sortByName: UIBarButtonItem!
    @IBOutlet weak var allCafesInMap: UIBarButtonItem!
    @IBOutlet weak var favouriteBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadFile()
        setupSearchController()
        tableView.register(CafeCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Download JSON
    func downloadFile() {
        do {
            let path = Bundle.main.url(forResource: "cafes", withExtension: "json")
            let fm = FileManager.default
            let docurl = try fm.url(for:.documentDirectory,
                                    in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationFileUrl = docurl.appendingPathComponent("cafes.json")
            //try? fm.removeItem(at: destinationFileUrl)
            let filePath = destinationFileUrl.path
            //print(docurl)
            
            if fm.fileExists(atPath: filePath) {
                print("File found")
            } else {
                try fm.copyItem(at: path!, to: destinationFileUrl)
                print("Copy succeeded")
            }
            
            let cafedata = fm.contents(atPath: filePath)
            let cafe = try JSONDecoder().decode([Cafe].self, from: cafedata!)
            self.cafes = cafe
        } catch {
            print("Downloading error")
        }
    }
    
    func setupSearchController() {
        // MARK: - Add a search tab
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search cafe"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        // MARK: - Add a scope buttons
        searchController.searchBar.scopeButtonTitles = ["All", "CBD"]
        searchController.searchBar.delegate = self
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .darkGray
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    @IBAction func sortByNameTapped(_ sender: Any) {
        if (acsSort) {
            cafes.sort { $0.name < $1.name }
            acsSort = false
        } else {
            cafes.sort { $0.name > $1.name }
            acsSort = true
        }
        self.tableView.reloadData()
    }
    
    //MARK: - navigate to favourite list
    @IBAction func showFavourite(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "showFavourite") as? FavouriteTableViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: - Navigate to map
    @IBAction func showAllCafesInMap(_ sender: Any) {
        var newCafeDict: [[String: Any]] = []
        var i = 0
        while i <= cafes.count - 1 {
            let cafeDict: [String: Any] = ["name": cafes[i].name, "latitude": cafes[i].latitude, "longitude": cafes[i].longitude, "location": cafes[i].location]
            newCafeDict.append(cafeDict)
            i += 1
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "showAllMaps") as? AllMapViewController
            vc!.cafeDict = newCafeDict
            navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: - Filter by searching in search textfield or scope buttons
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCafes = cafes.filter({( cafe : Cafe ) -> Bool in
            let doesCategoryMatch = (scope == "All" || cafe.suburb == scope)
            if searchController.searchBar.text == "" {
                return doesCategoryMatch
            } else {
                return (doesCategoryMatch && cafe.name.lowercased().contains(searchText.lowercased())) || (doesCategoryMatch && String(cafe.rating).contains(searchText))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CafeCell
        cell.link = self
        
        if isFiltering() {
            cell.textLabel?.text = filteredCafes[indexPath.row].name
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = "Rating: " + String(filteredCafes[indexPath.row].rating)
            cell.accessoryView?.tintColor = filteredCafes[indexPath.row].isFavourite ? UIColor.blue : .lightGray
            return cell
        } else {
            cell.textLabel?.text = cafes[indexPath.row].name
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = "Rating: " + String(cafes[indexPath.row].rating)
            cell.accessoryView?.tintColor = cafes[indexPath.row].isFavourite ? UIColor.blue : .lightGray
            return cell
        }
    }
    
    //MARK: Delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                if self.isFiltering() {
                    self.filteredCafes.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                    self.saveChangesToFile()
                } else {
                    self.cafes.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                    self.saveChangesToFile()
                }
            })
            alert.addAction(delete)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: View more cafes
    @IBAction func viewMoreOnlineCafes(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "onlineCafes") as? MoreCafesTableViewController
        vc?.delegate = self
        navigationController?.pushViewController(vc!, animated: true)
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
    
    // MARK: - Segue to selected cafe page
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
    
    // MARK: Favourite button tapped
    func isFavouritePressed(cell: UITableViewCell) {
        let indexPathClicked = tableView.indexPath(for: cell)
        let hasFavourite = cafes[indexPathClicked!.row].isFavourite
        cafes[indexPathClicked!.row].isFavourite = !hasFavourite
        let updateFavourite = cafes[indexPathClicked!.row].isFavourite
        cell.accessoryView?.tintColor = updateFavourite ? UIColor.blue : .lightGray
        saveChangesToFile()
    }
    
    //MARK: Save changes to file
    func saveChangesToFile() {
        do {
            let fm = FileManager.default
            let docurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let cafeUrl = docurl.appendingPathComponent("cafes.json")
            try fm.removeItem(at: cafeUrl)
            let jsonData = try! JSONEncoder().encode(cafes)
            try jsonData.write(to: cafeUrl, options: .atomic)
        } catch {
            print("Cannot save favourite item to file")
        }
    }

    @IBAction func isFavouriteBtnClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "showFavourite") as? FavouriteTableViewController
        vc!.favList = cafes
        navigationController?.pushViewController(vc!, animated: true)
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

extension TableViewController: UpdateCafeListDelegate {
    func addCafeToList(toAdd: Cafe) {
        var found: Bool = false
        for cafe in cafes {
            if (cafe.name == toAdd.name) {
                found = true
            }
        }
        if (!found) {
            cafes.append(toAdd)
            saveChangesToFile()
            let alert = UIAlertController(title: "", message: "The cafe is added successfully." , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "The cafe is already added." , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        tableView.reloadData()
    }
}

