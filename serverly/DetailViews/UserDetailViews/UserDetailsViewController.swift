//
//  UserDetailsViewController.swift
//  serverly
//
//  Created by Miguel Themann on 14.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class UserDetailsViewController: UITableViewController {
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsers()
    }
    
    func configure() {
        DispatchQueue.main.async {
            self.view.addSubview(self.tableView)
            self.tableView.pin(to: self.view)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = 40
            self.tableView.register(UserDetailsTableViewCell.self, forCellReuseIdentifier: "UserCell")
        }
    }
    
    func loadUsers() {
        let authenticationString = getAuthenticationString()
        let myurl = URL(string: getServerURL() + "/console/api/users.get?attrs=id,username")!
        var request = URLRequest(url: myurl)
        request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                self.presentOKAlertOnMainThread(title: "Error getting data", message: "The following error occured: \(error!)")
                return
            }
            do {
                self.users = try JSONDecoder().decode([User].self, from: data!)
                self.configure()
            } catch {
                self.presentOKAlertOnMainThread(title: "Error parsing data", message: "The JSON data could not be parsed.")
                return
            }
        }
        task.resume()
    }
}

extension UserDetailsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserDetailsTableViewCell(style: .default, reuseIdentifier: "UserCell")
        cell.set(id: users[indexPath.row].id, username: users[indexPath.row].username)
        return cell
    }
}
