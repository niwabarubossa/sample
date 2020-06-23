//
//  NewNavTableViewController.swift
//  sample
//
//  Created by Ni Ryogo on 2020/06/23.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class NewNavTableViewController: UITableViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataSource:[String] = ["sample","sample2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.setup()
    }


    private func searchData(text:String){
        self.dataSource = ["retult1","result2"]
        self.tableView.reloadData()
    }

}

extension NewNavTableViewController{
    
    private func tableViewSetup(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell") as? MyTableViewCell {
            cell.backgroundColor = UIColor.orange
            cell.myLabel.text = self.dataSource[indexPath.row]
            return cell
        }
        return MyTableViewCell()
    }
}


extension NewNavTableViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {
            self.view.endEditing(true)
            print("hello")
            self.searchData(text:searchBar.text!)
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

