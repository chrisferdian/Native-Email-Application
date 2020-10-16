//
//  EmailListVM.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import Foundation

class EmailListVM: BaseViewModel {
    @Request<EmailResponse>(url: "/emails")
    var emailRequest
    var state: ListProcessingState = .loading
    
    var didUpdateState: ((ListProcessingState, EmailResponse?) -> Void)?
    @Request<EmailResponseElement>(url: "/emails", method: .put, body: nil, headers: nil)
    var updateRequest
    
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
    }
    
    struct Output {
        let emails:EmailResponse
        let tableViewState: ListProcessingState
    }
    
    func transform(input: Input) -> Output {
        return Output(emails: input.response, tableViewState: .loading)
    }
    
    func makeRead(element: EmailResponseElement) {
        
    }
}
