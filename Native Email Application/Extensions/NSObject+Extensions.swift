//
//  NSObject+Extensions.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//
import Foundation

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
