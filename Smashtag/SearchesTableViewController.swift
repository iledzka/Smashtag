//
//  SearchesTableViewController.swift
//  Smashtag
//
//  Created by Iza Ledzka on 14/01/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class SearchesTableViewController: UITableViewController {

    private var searches = [String]()
    
    func refreshUI() {
        searches.removeAll()
        searches = UserDefaultsManager.searches
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Searches"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchesCell", for: indexPath)

        let searchedPhrase = searches[indexPath.row]

        if let searchesCell = cell as? SearchesTableViewCell {
            searchesCell.savedSearch = searchedPhrase
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchText = searches[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "mainTableViewController") as? MainTableViewController {
            vc.searchText = searchText
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
