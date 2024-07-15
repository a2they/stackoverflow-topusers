//
//  StackOverflowTopUsersApp.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import SwiftUI

@main
struct StackOverflowTopUsersApp: App {
    var body: some Scene {
        WindowGroup {
            ProfileListView(viewModel: ProfileListViewModel())
        }
    }
}
