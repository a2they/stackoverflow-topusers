//
//  ProfileDetailView.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import SwiftUI

struct ProfileDetailView: View {
    @ObservedObject var viewModel: ProfileDetailViewModel
    
    var body: some View {
        let profile = viewModel.profile
        VStack(alignment: .center) {
            if let image = viewModel.imageLoader.image {
                Image(uiImage: image)
                    .scaledToFit()
                    .cornerRadius(10)
            } else {
                ProgressView().onAppear {
                    viewModel.imageLoader.loadImage(from: viewModel.profile.profileImage)
                }
            }
            
        }
        .padding()
        .navigationTitle(viewModel.profile.displayName)

        VStack(alignment: .leading) {
            Text("Profile ID: \(profile.id)")
            Text("Display Name: \(profile.displayName)")
            Text("Reputation: \(profile.reputation)")
            Text("Location: \(profile.location)")
        }
        .padding()
        Spacer()
    }
}

#Preview {
    ProfileDetailView(viewModel: ProfileDetailViewModel(profile: UserProfile.example(), imageLoader: ImageLoader()))
}
