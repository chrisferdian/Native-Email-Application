//
//  ViewController.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 13/10/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testState()
    }
    
    private func testState() {
        tableView.setStateView(with: .loading)
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.tableView.setStateView(with: .retry) {
                print("RETRY")
                self.testState()
            }
        }
    }
}

