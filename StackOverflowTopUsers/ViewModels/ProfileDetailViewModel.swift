//
//  ProfileDetailViewModel.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import Foundation

import SwiftUI

class ProfileDetailViewModel: ObservableObject {
    /// Profile from StackOverflow
    let profile: UserProfile
    /// Loads profile image and caches
    let imageLoader: ImageLoader
    
    /// Set when face processing model is running
    @Published var isProcessingFace: Bool = false
    /// Result of face processing
    @Published var faceDetectionResult: FaceDetectionResult?
    /// Error of face processing
    @Published var processingFaceError: FaceDetectionService.FaceDetectionError?
    
    private let faceDetectionService: FaceDetectionService
    private var cancellationToken: CancellationToken?
    
    init(profile: UserProfile, imageLoader: ImageLoader, faceDetectionService: FaceDetectionService = FaceDetectionService()) {
        self.profile = profile
        self.imageLoader = imageLoader
        self.faceDetectionService = faceDetectionService
    }
        
    func performFaceDetection() {
        guard let image = imageLoader.image else {
            processingFaceError = .invalidImage
            return
        }
        guard !isProcessingFace else { return }
        isProcessingFace = true
        cancellationToken = faceDetectionService.detectFace(image: image) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isProcessingFace = false
                switch result {
                case .success(let faceDetectionResult):
                    self.faceDetectionResult = faceDetectionResult
                    self.processingFaceError = nil
                case .failure(let error):
                    self.faceDetectionResult = FaceDetectionResult(faceDetected: false, faceBounds: nil)
                    self.processingFaceError = error
                }
            }
        }
    }
    
    func cancelFaceDetection() {
        if isProcessingFace {
            cancellationToken?.cancel()
            isProcessingFace = false
            processingFaceError = .cancelled
        }
    }
}
