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
    
    func loadSummaryUsers() {
        let authenticationString = "mithem:migpasswort123"
        let myurl = URL(string: "https://helix2.ddns.net/console/api/summary.users")!
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
        let authenticationString = "mithem:migpasswort123"
        let myurl = URL(string: "https://helix2.ddns.net/console/api/summary.endpoints")!
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
        let authenticationString = "mithem:migpasswort123"
        let myurl = URL(string: "https://helix2.ddns.net/console/api/summary.statistics")!
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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
