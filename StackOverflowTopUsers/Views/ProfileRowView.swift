//
//  ProfileRowView.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import SwiftUI

import UIKit

struct ProfileRowView: View {
    
    let profile: UserProfile
    
    @StateObject var imageLoader: ImageLoader
    
    var body: some View {
        HStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            } else {
                ProgressView().onAppear {
                    imageLoader.loadImage(from: profile.profileImage)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(profile.displayName)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    ProfileRowView(profile: UserProfile.example(), imageLoader: ImageLoader())
}
