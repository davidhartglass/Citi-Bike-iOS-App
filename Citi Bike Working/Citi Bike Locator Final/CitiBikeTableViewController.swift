//
//  CitiBikesTableViewController.swift
//  Citi Bike Locator
//
//  Created by David Hartglass on 4/24/18.
//  Copyright © 2018 David Hartglass. All rights reserved.
//

import UIKit
import CoreData
class CitiBikesTableViewController: UITableViewController {
    
    let myBikes = CitiBikeCollection()
    var refresher: UIRefreshControl!
    let myRefreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredBikes = [CitiBike]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search addresses..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        myBikes.getRecent() {
            ()->() in
            print("In getRecent Closure: count is \(self.myBikes.currentBikes.count) - reloading data")
            self.tableView?.reloadData()
        }
        //print("almost done with VDL. Count is \(myBikes.currentBikes.count)")
        //print("really almost done with VDL. Count is \(myBikes.currentBikes.count)")
        if #available(iOS 10.0, *) {
            tableView?.refreshControl = myRefreshControl
        }
        else{
            tableView?.addSubview(myRefreshControl)
        }
        myRefreshControl.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
        myRefreshControl.attributedTitle? = NSAttributedString(string: "Reloading Bikes...")
    }
    
    // MARK: Refresh
    @objc func doRefresh(){
        myBikes.getRecent()
        self.tableView?.reloadData()
        self.tableView?.refreshControl?.endRefreshing()
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
        if isFiltering(){
            return filteredBikes.count
        }
        
        return myBikes.currentBikes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiBikeCell", for: indexPath)
        let bike: CitiBike
        if let actualCell = cell as? CitiBikeTableViewCell {
            let index = indexPath.row
            //print("loading index \(index)")
            
            if isFiltering(){
                bike = filteredBikes[index]
            }
            else{
                bike = myBikes.currentBikes[index]
            }
            
            actualCell.BikeIDLabel.text = bike.stAddress1
        } else {
            print("cell type mismatch.")
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
        let destinationVC =  segue.destination
        let row = tableView.indexPathForSelectedRow?.row
        
        if let actualDestVC = destinationVC as? CitiBikeDetailViewController {
            actualDestVC.rowNum = row!
            actualDestVC.myModel = myBikes
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredBikes = myBikes.currentBikes.filter({( bike : CitiBike) -> Bool in
            return bike.stAddress1.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension CitiBikesTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

