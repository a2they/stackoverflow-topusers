//
//  ProfileListView.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import SwiftUI

struct ProfileListView: View {
    
    @ObservedObject var viewModel: ProfileListViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ProfileListView(viewModel: ProfileListViewModel())
}
