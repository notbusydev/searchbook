//
//  BookRespository.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import Foundation

import Foundation

enum Result<Value: Decodable> {
    case success(Value)
    case error(Error)
}


class BookRepository {
    func search(keyword: String, page: Int, completion: @escaping (Result<SearchBooksResponse>) -> Void) {
        guard let url = URL(string: "https://api.itbook.store/1.0/search/\(keyword)/\(page)") else {
            completion(.error(RequestError.wrongURL))
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 3)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(SearchBooksResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.error(error))
                }
            } else {
                completion(.error(error ?? ResponseError.nonData))
            }
        }.resume()
    }
    
    func book(isbn13: String, completion: @escaping (Result<BookResponse>) -> Void) {
        guard let url = URL(string: "https://api.itbook.store/1.0/books/\(isbn13)") else {
            completion(.error(RequestError.wrongURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(BookResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data), errorResponse.error != "0" {
                        completion(.error(ResponseError.serverMessage(errorResponse.error)))
                    } else {
                        completion(.error(error))
                    }
                }
            } else {
                completion(.error(error ?? ResponseError.nonData))
            }
        }
    }
    
    enum RequestError: Error {
        case nonKeyword
        case nonIsbn13
        case wrongURL
        var errorDescription: String? {
            switch self {
            case .wrongURL:
                return "URL이 잘못되었습니다."
            case .nonKeyword:
                return "검색어를 가"
            case .nonIsbn13:
                return "ISBN이 없습니다."
            }
        }
    }
    
    enum ResponseError: Error {
        case nonData
        case serverMessage(_ message: String)
        
        var errorDescription: String? {
            switch self {
            case .nonData:
                return "데이터를 받지 못했습니다."
            case .serverMessage(let message):
                return message
            }
        }
    }
}







