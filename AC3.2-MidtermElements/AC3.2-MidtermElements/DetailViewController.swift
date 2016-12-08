//
//  DetailViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Annie Tung on 12/8/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var element: Element?
    let postEndPoint = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/favorites"
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var discoverYearLabel: UILabel!
    @IBOutlet weak var meltingLabel: UILabel!
    @IBOutlet weak var boilingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let validElement = element else { return }
        titleLabel.text = validElement.name
        symbolLabel.text = validElement.symbol
        numberLabel.text = String(validElement.number)
        weightLabel.text = String(validElement.weight)
        discoverYearLabel.text = "Discovery year: \(validElement.discovery_year)"
        meltingLabel.text = "Melting pt: \(String(validElement.melting_c))"
        boilingLabel.text = "Boiling pt: \(String(validElement.boiling_c))"
        
        
        APIRequestManager.manager.getData(endPoint: validElement.fullImage) { (data: Data?) in
            DispatchQueue.main.async {
                guard let validData = data else { return }
                self.imageView.image = UIImage(data: validData)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        if let validElement = element {
            let newBody: [String:Any] = [
                "my_name": "Annie",
                "favorite_element": "\(validElement.symbol)"
            ]
            
            APIRequestManager.manager.postRequest(endPoint: postEndPoint, data: newBody) { (response) in
                if let validResponse = response {
                    switch validResponse.statusCode {
                    case 200...299:
                        print("Successful post")
                        let alert = UIAlertController.init(title: "Successful", message: "It has been saved!", preferredStyle: .actionSheet)
                        let okay = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(okay)
                        self.present(alert, animated: true, completion: nil)
                    default:
                        print("Unsuccessful post")
                        let alert = UIAlertController.init(title: "Unsuccessful", message: "Try again!", preferredStyle: .alert)
                        let okay = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(okay)
                        self.present(alert, animated: true, completion: nil)
                        break
                    }
                }
            }
        }
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
