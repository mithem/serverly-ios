//
//  StatisticsDetailsViewController.swift
//  serverly
//
//  Created by Miguel Themann on 14.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class StatisticsDetailsViewController: UIViewController {

    var tableView = UITableView()
    var endpoints = [EndpointStatistic]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStats()
    }
    
    func configure() {
        DispatchQueue.main.async {
            self.view.addSubview(self.tableView)
            self.tableView.pin(to: self.view)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = 50
            self.tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: "StatisticCell")
        }
    }
    
    func loadStats() {
        let authenticationString = getAuthenticationString()
        let myurl = URL(string: (try? getServerURL()) ?? "https://google.com" + "/console/api/statistics?list=true")!
        var request = URLRequest(url: myurl)
        request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                self.presentOKAlertOnMainThread(title: "Error getting data", message: "The following error occured: \(error!)")
                return
            }
            do {
                self.endpoints = try JSONDecoder().decode([EndpointStatistic].self, from: data!)
                self.endpoints.sort {e1, e2 in
                    return e1.function > e2.function
                }
                self.configure()
            } catch {
                self.presentOKAlertOnMainThread(title: "Error parsing data", message: "The JSON data could not be parsed.")
                return
            }
        }
        task.resume()
    }
}

extension StatisticsDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatisticsTableViewCell(style: .default, reuseIdentifier: "StatisticCell")
        cell.set(endpointStatistic: endpoints[indexPath.row])
        return cell
    }
}
