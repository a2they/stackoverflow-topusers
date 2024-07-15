//
//  ProfileListViewModel.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import Foundation

class ProfileListViewModel: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @Published var isLoading: Bool = false
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
