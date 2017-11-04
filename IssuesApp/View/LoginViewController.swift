//
//  ViewController.swift
//  IssuesApp
//
//  Created by changi kim on 2017. 10. 28..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    static var viewController: LoginViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return LoginViewController() }
        return viewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
  
    }


}

extension LoginViewController {
    @IBAction func loginToGitHubButtonTapped() {
        App.api.getToken { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            
        }
    }
}

