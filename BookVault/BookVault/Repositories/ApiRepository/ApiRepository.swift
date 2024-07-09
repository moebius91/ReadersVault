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
    
    func getAuthors(author: String) async throws -> [String] {
        guard let url = URL(string: "https://api2.isbndb.com/authors/\(author.replacingOccurrences(of: " ", with: "%20"))") else {
            throw ApiError.invalidUrl
        }
        
        let urlRequest = urlRequest(url)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let apiAuthorsResult = try JSONDecoder().decode(ApiAuthorsResult.self, from: data)
        
        return apiAuthorsResult.authors
    }
    
    func getBooksByTitle(title: String) async throws -> [ApiBook] {
        guard let url = URL(string: "https://api2.isbndb.com/books/\(title.replacingOccurrences(of: " ", with: "%20"))?page=1&pageSize=20&column=title") else {
            throw ApiError.invalidUrl
        }
        
        let urlRequest = urlRequest(url)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let apiTitlesResult = try JSONDecoder().decode(ApiTitlesResult.self, from: data)
        
        return apiTitlesResult.books
    }
    
    // Hilfsfunktion URL -> URLRequest
    private func urlRequest(_ url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(ApiKeys.isbnDb.key, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("api2.isbndb.com", forHTTPHeaderField: "Host")
        
        return urlRequest
    }
}
