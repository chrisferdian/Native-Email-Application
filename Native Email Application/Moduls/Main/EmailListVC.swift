//
//  EmailListVC.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import UIKit

class EmailListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: EmailListVM = EmailListVM()
    private var emails: EmailResponse? = nil {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    private func setupTableView() {
        self.tableView.register(cellType: ListTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    private func bindViewModel() {
        viewModel.didUpdateState = { [weak self] (state, response) in
            self?.emails = response
            self?.tableView.setStateView(with: state)
        }
    }
}

extension EmailListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ListTableViewCell.self, for: indexPath)
        if let email = emails?[indexPath.row] {
            cell.bindCell(with: email)
        }
        
        return cell
    }
}

extension EmailListVC: UITableViewDelegate {
    
}
