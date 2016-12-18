//
//  AnotherOneTableViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Annie Tung on 12/15/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class AnotherOneTableViewController: UITableViewController {
    var elements = [Element]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "The Elements"
        
        getData()
        
        
        tableView.register(UINib(nibName: "AnotherOneTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        
    }
    
    func getData() {
        APIRequestManager.manager.getData(endPoint: "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements") { data in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options:[]),
                    let elements = jsonData as? [[String:Any]] {
                    
                    self.elements = Element.getElements(from: elements)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AnotherOneTableViewCell
        
        let element = self.elements[indexPath.row]
        cell.textLabel?.text = element.name
       // cell.detailLabel?.text = "\(element.symbol)(\(element.number)) \(element.weight)"
        cell.imageView?.image = nil
        
        APIRequestManager.manager.getData(endPoint: "https://s3.amazonaws.com/ac3.2-elements/\(element.symbol)_200.png") { data in
            if let validData = data,
                let image = UIImage(data: validData) {
                
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "elementViewController") as! ElementViewController
        controller.element = elements[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
