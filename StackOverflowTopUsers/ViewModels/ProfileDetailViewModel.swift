//
//  ProfileDetailViewModel.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import Foundation

import SwiftUI

class ProfileDetailViewModel: ObservableObject {
    let profile: UserProfile
    let imageLoader: ImageLoader
    
    init(profile: UserProfile, imageLoader: ImageLoader) {
        self.profile = profile
        self.imageLoader = imageLoader
    }
        
    func performFaceDetection() {
        // todo
    }
    
    func cancelFaceDetection() {
        // todo
    }
}
