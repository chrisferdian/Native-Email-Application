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
    var longPress:UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        bindViewModel()
    }
    private func setupNavigationBar() {
        title = "Inbox"
    }
    private func setupTableView() {
        self.tableView.tableFooterView = UIView()
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPress)
        self.tableView.setStateView(with: .loading)
        self.tableView.register(cellType: ListTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if longPress.state == .began {
            let touchPoint = longPress.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                // your code here, get the row for the indexPath or do whatever you want
                if let email = self.emails?[indexPath.row] {
                    self.viewModel.makeRead(element: email, index: indexPath)
                }
            }
        }
    }
    private func bindViewModel() {
        viewModel.didUpdateState = { [weak self] (state, response) in
            self?.emails = response
            self?.tableView.setStateView(with: state)
        }
        viewModel.didUpdateRead = { [weak self] (index, element) in
            self?.emails?[index.row] = element
            DispatchQueue.main.async {
                self?.tableView.reloadRows(at: [index], with: .fade)
            }
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.makeRead(element: (self.emails?[indexPath.row])!, index: indexPath)
    }
}
