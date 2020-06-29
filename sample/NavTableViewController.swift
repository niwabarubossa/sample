//
//  NavTableViewController.swift
//  sample
//
//  Created by Ni Ryogo on 2020/06/23.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class NavTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataSource:[String] = [
        "a",
        "a",
        "a",
        "a",
        "a",
        "abb",
        "abb",
        "abb"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.dataSource.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension NavTableViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {
            self.view.endEditing(true)
           return false
        }
        return true
    }
    
    private func setup(){
        self.searchBar.becomeFirstResponder()
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
    }
}
