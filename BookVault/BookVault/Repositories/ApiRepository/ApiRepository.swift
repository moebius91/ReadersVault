//
//  ApiRepository.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 03.07.24.
//

import Foundation

class ApiRepository {
    
    static let shared = ApiRepository()
    
    private init() {
        
    }
    
    func getBookByIsbn(isbn: String) async throws -> ApiBook {
        guard let url = URL(string: "https://api2.isbndb.com/book/\(isbn)") else {
            throw ApiError.invalidUrl
        }
        
        let urlRequest = urlRequest(url)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let apiBookResult = try JSONDecoder().decode(ApiBookResult.self, from: data)
        
        return apiBookResult.book
    }
    
    func getBooksByAuthor(author: String) {
        
    }
    
    func getBooksByTitle(title: String) {
        
    }
    
    private func urlRequest(_ url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(ApiKeys.isbnDb.key, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("api2.isbndb.com", forHTTPHeaderField: "Host")
        
        return urlRequest
    }
}
