//
//  ProfileListView.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import SwiftUI

/// List view to show profile photo and display name
struct ProfileListView: View {
    
    @ObservedObject var viewModel: ProfileListViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                if error is StackoverflowAPIError {
                    Text("Error: something went wrong interacting with stackoverflow.")
                } else {
                    Text("Error: \(error)")
                }
            } else {
                NavigationView {
                    List {
                        ForEach(viewModel.profiles) { profile in
                            let imageLoader = ImageLoader()
                            NavigationLink {
                                ProfileDetailView(viewModel: ProfileDetailViewModel(profile: profile, imageLoader: imageLoader))
                            } label: {
                                ProfileRowView(profile: profile, imageLoader: imageLoader)
                            }
                        }
                    }
                    .navigationTitle("Top Users")
                }
            }
        }
        .onAppear {
            viewModel.fetchProfiles()
        }
    }
        
}

#Preview {
    ProfileListView(viewModel: ProfileListViewModel())
}
