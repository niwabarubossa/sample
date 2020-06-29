//
//  MyTableViewController.swift
//  sample
//
//  Created by Ni Ryogo on 2020/06/16.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class MyTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
    var secondDataSource:[String] = [
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
    }
}

extension MyTableViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.dataSource.count
        }
        if section == 1 {
            return self.secondDataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell") as? MyTableViewCell {
            cell.backgroundColor = UIColor.orange
            cell.myLabel.text = "hello world"
            return cell
        }
        return MyTableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //高さ200px ここで決まる
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if indexPath.section == 0 {
                self.dataSource.remove(at: indexPath.row)
            }
            if indexPath.section == 1 {
                self.secondDataSource.remove(at: indexPath.row)
            }
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
}
