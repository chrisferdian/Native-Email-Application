//
//  EmailListVM.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import Foundation

struct HasWrapper {
    
}

class EmailListVM: BaseViewModel {
    @Request<EmailResponse>(url: "emails")
    var emailRequest
    @Request<EmailResponseElement>(url: "emails", id: nil, method: .put, body: nil, headers: ["Content-Type": "application/x-www-form-urlencoded"])
    var updateRequest
    @Request<EmailResponseElement>(url: "emails", method: .delete)
    var deleteRequest
    
    var state: ListProcessingState = .loading
    var didUpdateState: ((ListProcessingState, EmailResponse?) -> Void)?
    var didUpdateRead: ((IndexPath, EmailResponseElement) -> Void)?
    var didDeleted: ((IndexPath, EmailResponseElement) -> Void)?
    var didTapToDetail: ((EmailResponseElement) -> Void)?

    init() {
        emailRequest { res in
            switch res {
            case .success(let response):
                if !response.isEmpty {
                    self.didUpdateState?(.success, response)
                    return
                } else {
                    self.didUpdateState?(.empty, response)
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.didUpdateState?(.retry, nil)
            }
        }
    }
    
    struct Input {
        let response: EmailResponse
        var parameters:EmailResponseElement?
    }
    
    struct Output {
        let emails:EmailResponse
        let tableViewState: ListProcessingState
    }
    
    func transform(input: Input) -> Output {
        return Output(emails: input.response, tableViewState: .loading)
    }
    
    func makeRead(element: EmailResponseElement, index: IndexPath) {
        var elemet = element
        elemet.isRead = "true"
        let param = ["isRead": "true"]
        _updateRequest.setParameters(body: param)
        _updateRequest.setId(with: elemet.id)
        updateRequest { res in
            switch res {
            case .success(let response):
                print(response)
                self.didUpdateRead?(index, elemet)
            case .failure(let error):
                print("resErr")
                print(error)
            }
        }
    }
    
    func makeDelete(element: EmailResponseElement, index: IndexPath) {
        _deleteRequest.setId(with: element.id)
        deleteRequest { res in
            switch res {
            case .success(let response):
                print(response)
                self.didDeleted?(index, element)
            case .failure(let error):
                print("resErr")
                print(error)
            }
        }
    }
}
