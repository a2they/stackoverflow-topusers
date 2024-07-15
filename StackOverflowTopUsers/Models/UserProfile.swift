//
//  UserProfile.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import Foundation

struct UserProfile: Codable, Identifiable {
    let id: Int
    let reputation: Int
    let profileImage: String
    let displayName: String
    let location: String

    enum CodingKeys: String, CodingKey {
        case id = "account_id"
        case reputation
        case profileImage = "profile_image"
        case displayName = "display_name"
        case location
    }
    
    init(id: Int, reputation: Int, profileImage: String, displayName: String, location: String) {
        self.id = id
        self.reputation = reputation
        self.profileImage = profileImage
        self.displayName = displayName
        self.location = location
    }
    
    static func example() -> UserProfile {
        return UserProfile(id: 12345, reputation: 100000, profileImage: "https://avatars.githubusercontent.com/u/15901479?v=4", displayName: "Andrey", location: "Toronto, Canada")
    }
}
