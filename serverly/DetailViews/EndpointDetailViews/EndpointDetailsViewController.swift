//
//  EndpointDetailsViewController.swift
//  serverly
//
//  Created by Miguel Themann on 14.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class EndpointDetailsViewController: UIViewController {
    
    var tableView = UITableView()
    var endpointCount: Int = 0
    var getEndpoints = [Dictionary<String, String>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "endpoints"
        loadEndpoints()
    }
    
    func loadEndpoints() {
        let authenticationString = getAuthenticationString()
        let myurl = URL(string: getServerURL() + "/console/api/endpoints")!
        var request = URLRequest(url: myurl)
        request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            // let str = String(data: data, encoding: .utf8)!
            let parsedData: Dictionary? = try? readJson(data: Data(data))
            let d = parsedData ?? Dictionary<String, Dictionary<String, String>>()
            for (method, endpoints) in d {
                if method == "get" {
                    for(path, name) in d["get"]! {
                        self.getEndpoints.append(["path": path, "name": name])
                    }
                }
            }
            print(self.getEndpoints)
            self.endpointCount = parsedData?.count ?? 0
            self.drawEndpoints(parsedData)
        }

        task.resume()
    }
    
    func drawEndpoints(_ data: Dictionary<String, Dictionary<String, String>>?){
        if let data = data {
            // MARK: - TableView setup
            DispatchQueue.main.async {
                self.view.addSubview(self.tableView)
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                
                self.tableView.rowHeight = 60
                
                self.tableView.register(EndpointDetailsTableViewCell.self, forCellReuseIdentifier: "EndpointCell")
                
                self.tableView.pin(to: self.view)
            }
            print("success!")
        } else {
            let alert = UIAlertController(title: "No data", message: "Unable to receive data from server.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension EndpointDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpointCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EndpointCell") as! EndpointDetailsTableViewCell
        cell.set(path: getEndpoints[indexPath.row]["path"] ?? "(none)", name: getEndpoints[indexPath.row]["name"] ?? "(none)")
        return cell
    }
    
    
}
