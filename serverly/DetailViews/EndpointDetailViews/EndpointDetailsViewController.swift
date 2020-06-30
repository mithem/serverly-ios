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
    var postEndpoints = [Dictionary<String, String>]()
    var putEndpoints = [Dictionary<String, String>]()
    var deleteEndpoints = [Dictionary<String, String>]()
    var colors = Dictionary<String, UIColor>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "endpoints"
        loadSettings()
        loadEndpoints()
    }
    
    func loadSettings() {
        func getColor(_ c: Int) -> UIColor {
            switch(c) {
            case 1:
                return UIColor.systemGreen
            case 2:
                return UIColor.systemBlue
            case 3:
                return UIColor.systemYellow
            case 4:
                return UIColor.systemRed
            default:
                return UIColor.label
            }
        }
        let userDefaults = UserDefaults()
        colors["get"] = getColor(userDefaults.integer(forKey: "colorForGET"))
        colors["post"] = getColor(userDefaults.integer(forKey: "colorForPOST"))
        colors["put"] = getColor(userDefaults.integer(forKey: "colorForPUT"))
        colors["delete"] = getColor(userDefaults.integer(forKey: "colorForDELETE"))
    }
    
    func loadEndpoints() {
        let authenticationString = getAuthenticationString()
        let myurl = URL(string: (try? getServerURL()) ?? "https://google.com" + "/console/api/endpoints")!
        var request = URLRequest(url: myurl)
        request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            if error != nil {
                self.presentOKAlertOnMainThread(title: "An error occured", message: "The following error occured while getting the response from the server: \(String(describing: error))")
            }
            
            let parsedData: Dictionary? = try? readJson(data: Data(data))
            let d = parsedData ?? Dictionary<String, Dictionary<String, String>>()
            for (method, endpoint) in d {
                var arr = [Dictionary<String, String>]()
                for(path, name) in endpoint {
                    arr.append(["path": path, "name": name])
                }
                switch method {
                    case "get":
                        self.getEndpoints = arr
                    case "post":
                        self.postEndpoints = arr
                    case "put":
                            self.putEndpoints = arr
                    case "delete":
                        self.deleteEndpoints = arr
                    default:
                        self.presentOKAlertOnMainThread(title: "Error parsing server data", message: "It seems like the method \(method) is unsupported by this app :/")
                }
            }
            self.getEndpoints.sort {d1, d2 in
                return d2["path"]?.replacingOccurrences(of: "/", with: "") ?? "a" > d1["path"]?.replacingOccurrences(of: "/", with: "") ?? "b"
            }
            self.configureTableView()
        }
        task.resume()
    }
    
    func configureTableView(){
        // MARK: - TableView setup
        DispatchQueue.main.async {
            self.view.addSubview(self.tableView)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.rowHeight = 60
            
            self.tableView.register(EndpointDetailsTableViewCell.self, forCellReuseIdentifier: "EndpointCell")
            
            self.tableView.pin(to: self.view)
        }
    }
}

extension EndpointDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getEndpoints.count + postEndpoints.count + putEndpoints.count + deleteEndpoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EndpointCell") as! EndpointDetailsTableViewCell
        var method: String
        var offset: Int
        var arr: [Dictionary<String, String>]
        if indexPath.row >= getEndpoints.count + postEndpoints.count + putEndpoints.count {
            method = "delete"
            offset = getEndpoints.count + postEndpoints.count + putEndpoints.count
        }
        else if indexPath.row >= getEndpoints.count + postEndpoints.count {
            method = "put"
            offset = getEndpoints.count + postEndpoints.count
        }
        else if indexPath.row >= getEndpoints.count {
            method = "post"
            offset = getEndpoints.count
        }
        else {
            method = "get"
            offset = 0
        }
        switch method {
        case "get":
            arr = getEndpoints
        case "post":
            arr = postEndpoints
        case "put":
            arr = putEndpoints
        case "delete":
            arr = deleteEndpoints
        default:
            arr = [Dictionary<String, String>]()
            self.presentOKAlertOnMainThread(title: "Something went wrong", message: "This app is really not designed well :/")
        }
        cell.set(path: arr[indexPath.row - offset]["path"] ?? "invalid path", name: arr[indexPath.row - offset]["name"] ?? "invalid name", method: method, color: colors[method] ?? UIColor.label)
        return cell
    }
}
