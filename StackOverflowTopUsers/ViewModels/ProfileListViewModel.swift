//
//  ProfileListViewModel.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import Foundation

class ProfileListViewModel: ObservableObject {
    @Published var profiles: [UserProfile] = []
}
