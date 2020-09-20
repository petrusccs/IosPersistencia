//
//  User.swift
//  FirebaseDemo4
//
//  Created by Petrus Souza on 20/09/20.
//  Copyright © 2020 Petrus Souza. All rights reserved.
//

import Foundation

class User: Codable {
    var userId: String?
    var idToken: String?
    var fullName: String?
    var givenName: String?
    var familyName: String?
    var email: String?
    
    init(userId: String?, idToken: String?, fullName: String?,
         givenName: String?, familyName: String?, email: String?) {
        self.userId = userId
        self.idToken = idToken
        self.fullName = fullName
        self.familyName = fullName
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
    }
}
