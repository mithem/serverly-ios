//
//  ServerDetailsViewController.swift
//  MyFirstApp
//
//  Created by Miguel Themann on 11.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class ServerDetailsViewController: UIViewController {
    
    @IBOutlet weak var lSummaryUsers: UILabel!
    
    @IBOutlet weak var lSummaryEndpoints: UILabel!
    
    @IBOutlet weak var lSummaryStatistics: UILabel!
    
    @IBAction func bRefreshTapped(_ sender: UIButton) {
        refresh()
    }
    
    func getAuthenticationString() -> String {
        let userDefaults = UserDefaults()
        return (userDefaults.string(forKey: "username") ?? "root") + ":" + (userDefaults.string(forKey: "password") ?? "1234")
    }
    
    func getServerURL() -> String {
        let userDefaults = UserDefaults()
        var value = userDefaults.string(forKey: "serverURL") ?? "https://google.com/search?q="
        if value.hasSuffix("/") {
            value =  String(value[..<value.index(before: value.endIndex)])
        }
        return value
    }
    
    func loadSummaryUsers() {
        let authenticationString = getAuthenticationString()
        let myurl = URL(string: getServerURL() + "/console/api/summary.users")!
        var request = URLRequest(url: myurl)
        request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.lSummaryUsers.text = String(data: data, encoding: .utf8) ?? "no response"
            }
        }

        task.resume()
    }
    
    func loadSummaryEndpoints() {
        let authenticationString = getAuthenticationString()
        let myurl = URL(string: getServerURL() + "/console/api/summary.endpoints")!
        var request = URLRequest(url: myurl)
        request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.lSummaryEndpoints.text = String(data: data, encoding: .utf8) ?? "no response"
            }
        }

        task.resume()
    }
    
    func loadSummaryStatistics() {
        let authenticationString = getAuthenticationString()
        let myurl = URL(string: getServerURL() + "/console/api/summary.statistics")!
        var request = URLRequest(url: myurl)
        request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.lSummaryStatistics.text = String(data: data, encoding: .utf8) ?? "no response"
            }
        }

        task.resume()
    }
    
    func refresh() {
        loadSummaryUsers()
        loadSummaryEndpoints()
        loadSummaryStatistics()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "serverly"
        refresh()
    }
}
