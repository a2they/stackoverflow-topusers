//
//  StackOverflowService.swift
//  StackOverflowTopUsers
//
//  Created by Andrey Leonov on 2024-07-14.
//

import Foundation

enum StackoverflowAPIError: Error, CustomStringConvertible {
    case decodingError(Error)
    case requestFailed(Error)
    case invalidResponse

    var description: String {
        switch self {
        case .decodingError(let error):
            return "Decoding Error: \(error)"
        case .requestFailed(let error):
            return "Request Failed: \(error)"
        case .invalidResponse:
            return "Invalid Response"
        }
    }
}

class StackOverflowService {
    
    func fetchTopProfiles(max: Int = 10, completion: @escaping (Result<[UserProfile], StackoverflowAPIError>) -> Void) {
        guard let url = URL(string: "https://api.stackexchange.com/2.2/users?order=desc&sort=reputation&site=stackoverflow&pagesize=\(max)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error response: \(response.debugDescription)")
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ProfilesAPIResponse.self, from: data)
                completion(.success(response.items))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }

}

private struct ProfilesAPIResponse : Codable {
    let items: [UserProfile]
}
