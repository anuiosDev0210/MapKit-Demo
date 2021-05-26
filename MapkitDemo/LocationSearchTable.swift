//
//  LocationSearchTable.swift
//  MapkitDemo
//
//  Created by Anu Agrawal on 5/26/21.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController,UISearchResultsUpdating{
   
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
                let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchBarText
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
        search.start { response, _ in
                guard let response = response else {
                    return
                }
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)

        let selectedItem = matchingItems[indexPath.row].placemark
                cell.textLabel?.text = selectedItem.name
                let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        cell.detailTextLabel?.text = address
                return cell
            }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }

   
}
