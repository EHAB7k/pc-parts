//
//  NewPiece.swift
//  BP
//
//  Created by Ehab Hakami on 20/05/1443 AH.
//


import Foundation
import Firebase
struct NewPeice {
    var id = ""
    var title = ""
    var description = ""
    var productInformation = ""
    var phoneNumber = ""
    var imageUrl = ""
    var user:User
    var createdAt:Timestamp?
    
    init(dict:[String:Any],id:String,user:User) {
        if let title = dict["title"] as? String,
           let description = dict["description"] as? String,
           let phoneNumber = dict["phoneNumber"] as? String,
           let productInformation = dict["productInformation"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
            let createdAt = dict["createdAt"] as? Timestamp{
            self.title = title
            self.description = description
            self.productInformation = productInformation
            self.phoneNumber = phoneNumber
            self.imageUrl = imageUrl
            self.createdAt = createdAt
        }
        self.id = id
        self.user = user
    }
}
