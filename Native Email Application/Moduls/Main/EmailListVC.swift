//
//  EmailListVC.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import UIKit

class EmailListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    internal var viewModel: EmailListVM?
    private var emails: EmailResponse? = nil {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var longPress:UILongPressGestureRecognizer!
    let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    var tableState: TableState = .normal {
        didSet {
            switch tableState {
            case .normal:
                self.tableView.allowsMultipleSelection = false
                self.toolbar.isHidden = true
                navigationItem.setLeftBarButton(editBarItem, animated: true)
                self.selectedEmail.removeAll()
            case .selection:
                self.tableView.allowsMultipleSelection = true
                self.toolbar.isHidden = false
                navigationItem.setLeftBarButton(cancelBarItem, animated: true)
            }
        }
    }
    var editBarItem:UIBarButtonItem!
    var cancelBarItem:UIBarButtonItem!
    var selectedEmail:[EmailResponseElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        bindViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    private func setupNavigationBar() {
        title = "Inbox"
        editBarItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editAction))
        cancelBarItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
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
                if let _ = self.emails?[indexPath.row] {
                    self.heavyImpact.impactOccurred()
                    self.tableState = .selection
                }
            }
        }
    }
    private func bindViewModel() {
        viewModel?.didUpdateState = { [weak self] (state, response) in
            self?.emails = response
            self?.tableView.setStateView(with: state)
            if state == .success {
                DispatchQueue.main.async {
                    self?.navigationItem.leftBarButtonItem = self?.editBarItem
                }
            }
        }
        viewModel?.didUpdateRead = { [weak self] (index, element) in
            self?.emails?[index.row] = element
            DispatchQueue.main.async {
                self?.tableView.reloadRows(at: [index], with: .fade)
            }
        }
        viewModel?.didDeleted = { [weak self] (index, _) in
            if self?.tableState == .normal {
                DispatchQueue.main.async {
                    if self?.tableState == .normal {
                        if let _ = self?.emails?[index.row] {
                            self?.emails?.remove(at: index.row)
                            self?.tableView.deleteRows(at: [index], with: .automatic)
                            if (self?.emails?.isEmpty ?? false) {
                                self?.tableView.setStateView(with: .empty)
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func editAction() {
        tableState = .selection
    }
    @objc func cancelAction() {
        tableState = .normal
    }
    @IBAction func didReadTapped() {
        if let selected = tableView.indexPathsForSelectedRows {
            print(selected)
            selected.forEach { (indexPath) in
                if let email = emails?[indexPath.row] {
                    if !email.getRead() {
                        DispatchQueue.main.async {
                            self.viewModel?.makeRead(element: email, index: indexPath)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableState = .normal
            }
        }
    }
    @IBAction func didDeleteTapped() {
        if !self.selectedEmail.isEmpty {
            selectedEmail.forEach { (email) in
                if let i = self.emails?.firstIndex(of: email) {
                    self.emails?.remove(at: i)
                    self.viewModel?.makeDelete(element: email, index: IndexPath(row: i, section: 0))
                    self.tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                }
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
        switch tableState {
        case .normal:
            if let email = emails?[indexPath.row] {
                if !email.getRead() {
                    self.viewModel?.makeRead(element: (self.emails?[indexPath.row])!, index: indexPath)
                }
                DispatchQueue.main.async {
                    
                    self.viewModel?.didTapToDetail?(email)
                }
            }
        case .selection:
            if let email = emails?[indexPath.row] {
                self.selectedEmail.append(email)
            }
            print(tableState.hashValue)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let email = emails?[indexPath.row] {
                self.viewModel?.makeDelete(element: email, index: indexPath)
            }
        }
    }
}
