//
//  EmailResponse.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import Foundation
// MARK: - EmailResponseElement
struct EmailResponseElement: Codable {
    var id, createdAt, name: String
    var avatar: String
    var content, email: String
    var isRead: String
    var subject: String
    
    func getRead() -> Bool {
        return Bool(isRead) ?? false
    }
}

typealias EmailResponse = [EmailResponseElement]
