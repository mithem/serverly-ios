//
//  EndpointDetailsViewController.swift
//  serverly
//
//  Created by Miguel Themann on 14.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class EndpointDetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableGET: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadEndpoints()
    }
    
    func loadEndpoints() {
        let authenticationString = getAuthenticationString()
        let myurl = URL(string: getServerURL() + "/console/api/endpoints.get")!
        var request = URLRequest(url: myurl)
        request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let parsedData = try? readJson(data: Data(data))
            self.drawEndpoints(parsedData)
        }

        task.resume()
    }
    
    func drawEndpoints(_ data: Dictionary<String, Any>?){
        if data == nil {
            let alert = UIAlertController(title: "No data", message: "Unable to receive data from server.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            print(data)
        }
    }
}
