//
//  ElementsTableViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Annie Tung on 12/8/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class ElementsTableViewController: UITableViewController {
    
    var element = [Element]()
    let elementEndPoint = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100
        self.title = "Elements"
        
        APIRequestManager.manager.getData(endPoint: elementEndPoint) { (data: Data?) in
            guard let validData = data else { return }
            if let validObject = Element.parse(from: validData) {
                self.element = validObject
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return element.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let eachElement = element[indexPath.row]
        cell.textLabel?.text = eachElement.name
        cell.detailTextLabel?.text = "\(eachElement.symbol)" + "(\(eachElement.id))" + " \(eachElement.weight)"
        
        APIRequestManager.manager.getData(endPoint: eachElement.thumbnail) { (data: Data?) in
            guard let validData = data else { return }
            cell.imageView?.image = UIImage(data: validData)
            cell.setNeedsLayout()
            cell.imageView?.layer.cornerRadius = 50
            cell.imageView?.layer.masksToBounds = true
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailViewController, let cell = sender as? UITableViewCell, let selectedPath = self.tableView.indexPath(for: cell) {
            let selectedRow = element[selectedPath.row]
            destinationVC.element = selectedRow
        }
    }
    
    
}
