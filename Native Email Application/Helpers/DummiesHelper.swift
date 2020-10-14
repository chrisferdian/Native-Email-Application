//
//  DummiesHelper.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 13/10/20.
//

import UIKit

struct DummiesHelper {
    
    static func createDummiesUsers() {
        let userDef = UserDefaults.standard
        let isFirst = userDef.value(forKey: "isFirst")
        if (isFirst == nil) {
            userDef.set(true, forKey: "isFirst")
    //        CDHelper.initializeWithMainContext(appDel.persistentContainer.viewContext)
            let steve = Users.new()
            steve.email = "steve@mail.com"
            steve.name = "Steve Me"
            steve.userId = 0
            steve.save()
            
            let john = Users.new()
            john.email = "john@mail.com"
            john.name = "John Sliem"
            john.userId = 1
            john.save()

            let message1 = Messages.new()
            message1.mId = 0
            message1.sendAt = Date()
            message1.sender = john
            message1.subject = "Subject"
            john.message = message1
            john.save()
            
            let mark = Users.new()
            mark.email = "mark@mail.com"
            mark.name = "Mark Low"
            mark.userId = 2
            mark.save()
        }
        
    }
}
extension Users: CDHelperEntity {
    public static var entityName: String! {
        return "Users"
    }
}

extension Messages: CDHelperEntity {
    public static var entityName: String! {
        return "Messages"
    }
}
