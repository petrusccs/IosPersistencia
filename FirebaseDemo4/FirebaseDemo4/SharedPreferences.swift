//
//  SharedPreferences.swift
//  FirebaseDemo4
//
//  Created by Petrus Souza on 20/09/20.
//  Copyright © 2020 Petrus Souza. All rights reserved.
//

import Foundation

class SharedPreferences {
    
    static let shared = UserDefaults.standard
    static let KEY_LAST_USER = "user"
    
    static var user: User?
    
    static func saveLastUser(user: Data?){
        shared.set(user, forKey: KEY_LAST_USER)
    }
    
    static func getLastUser() -> User?{
        let userData = shared.object(forKey: KEY_LAST_USER) as? Data
        if(userData != nil){
            do {
                user = try JSONDecoder().decode(User.self, from: userData!)
            }catch{
                user = nil
            }
        }
        return user
    }
}
