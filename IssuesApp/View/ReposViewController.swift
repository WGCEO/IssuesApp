//
//  ReposViewController.swift
//  IssuesApp
//
//  Created by changi kim on 2017. 11. 4..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController {
    
    let datasource: [(owner: String, repo: String)] = GlobalState.instance.repos
    var selectedRepo: (owner: String, repo: String)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ReposViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        let data = datasource[indexPath.row]
        cell.textLabel?.text = "/\(data.owner)/\(data.repo)"
        return cell
    }
}

extension ReposViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datasource[indexPath.row]
        selectedRepo = data
//        DispatchQueue.main.async { [weak self] in
//            self?.performSegue(withIdentifier: "EnterRepoSegue", sender: nil)
//        }
    }
}
