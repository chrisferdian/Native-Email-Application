//
//  EmailResponse.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import Foundation
// MARK: - EmailResponseElement
struct EmailResponseElement: Codable {
    let id, createdAt, name: String
    let avatar: String
    let content, email: String
    let isRead: Bool
}

typealias EmailResponse = [EmailResponseElement]
