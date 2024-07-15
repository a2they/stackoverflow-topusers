//
//  ProfileListViewModel.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import Foundation

class ProfileListViewModel: ObservableObject {
    /// StackOverflow profiles
    @Published var profiles: [UserProfile] = []
    /// Set when profiles are being loaded
    @Published var isLoading: Bool = false
    /// Any error during profiles fetch
    @Published var error: Error?
    
    private let stackOverflowService: StackOverflowService
    
    init(stackOverflowService: StackOverflowService = StackOverflowService()) {
        self.stackOverflowService = stackOverflowService
    }
    
    func fetchProfiles() {
        guard !isLoading else { return }
        isLoading = true
        stackOverflowService.fetchTopProfiles { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                    case .success(let profiles):
                        self.profiles = profiles
                    case .failure(let error):
                        self.error = error
                }
            }
        }
    }
    
    
}
