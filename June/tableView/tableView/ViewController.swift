//
//  ViewController.swift
//  tableView
//
//  Created by P10 on 12/06/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tableData : [String] = ["Rod","Mark","Liam is a male and he goes to college. he lives with his family and wants to move out", "John"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        }
        cell!.textLabel?.text = tableData[indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        
        return cell!
    }


}

