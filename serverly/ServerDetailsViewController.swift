//
//  ServerDetailsViewController.swift
//  serverly
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
    
    private func getLabelText(data: Data?, error: Error?) -> String{
        var str = String(data: ((data ?? "no data".data(using: .utf8)!)), encoding: .utf8) ?? "no response"
        if error != nil {
            str = "Error: \(String(describing: error!.localizedDescription))"
        }
        return str
    }
    
    func loadSummaryUsers() {
        let authenticationString = getAuthenticationString()
        let myurl = URL(string: getServerURL() + "/console/api/summary.users")!
        var request = URLRequest(url: myurl)
        request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                self.lSummaryUsers.text = self.getLabelText(data: data, error: error)
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
            DispatchQueue.main.async {
                self.lSummaryEndpoints.text = self.getLabelText(data: data, error: error)
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
            DispatchQueue.main.async {
                self.lSummaryStatistics.text = self.getLabelText(data: data, error: error)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
}
