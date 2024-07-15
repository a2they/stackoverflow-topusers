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
                    .onAppear {
                        viewModel.performFaceDetection()
                    }
            } else {
                ProgressView().onAppear {
                    viewModel.imageLoader.loadImage(from: viewModel.profile.profileImage)
                }
            }
            
        }
        .padding()
        .navigationTitle(viewModel.profile.displayName)
        .onDisappear {
            viewModel.cancelFaceDetection()
        }

        VStack(alignment: .leading) {
            
            Text("Profile")
                .font(.headline)
            
            Text("ID: \(profile.id)")
            Text("Reputation: \(profile.reputation)")
            Text("Location: \(profile.location)")

            Text("Face Model: ")
                .font(.headline)
                .padding(.top, 20)
            
            if let faceDetectionResult = viewModel.faceDetectionResult {
                Text("Face Detected: \(faceDetectionResult.faceDetected ? "Yes" : "No")")
                Text("Face Bounds: \(faceDetectionResult.faceBounds?.debugDescription ?? "N/A")")
            } else {
                Text("Face Detection Result: In Progress...")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        Spacer()
    }
}

#Preview {
    ProfileDetailView(viewModel: ProfileDetailViewModel(profile: UserProfile.example(), imageLoader: ImageLoader()))
}
