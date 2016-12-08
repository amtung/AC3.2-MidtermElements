//
//  APIManager.swift
//  AC3.2-MidtermElements
//
//  Created by Annie Tung on 12/8/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import Foundation

class APIRequestManager {
    
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Error durring GET session: \(error)")
            }
            
            guard let validData = data else { return }
            
            DispatchQueue.main.async {
                callback(validData)
            }
            }.resume()
    }
    
    func postRequest(endPoint: String, data: [String:Any], completion: @escaping (HTTPURLResponse?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        
        var request = URLRequest(url: myURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // this is specifically for the midterm  -- don't change if you want to write there
        request.addValue("Basic a2V5LTE6dHdwTFZPdm5IbEc2ajFBZndKOWI=", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error during POST session: \(error)")
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered: \(error)")
            }
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                print("Response status code: \(httpResponse.statusCode)")
                completion(httpResponse)
            }
            guard let validData = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: []) as? [String:Any]
                if let validJSON = json {
                    print(validJSON)
                }
            } catch {
                print("Error converting back to json: \(error)")
            }
            }.resume()
    }
}

   
