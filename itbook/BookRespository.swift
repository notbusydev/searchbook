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

protocol URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol BookRepositoryProtocol {
    func search(keyword: String, page: Int, completion: @escaping (Result<SearchBooksResponse>) -> Void)
    func book(isbn13: String, completion: @escaping (Result<BookResponse>) -> Void)
}

class BookRepository: BookRepositoryProtocol {
    let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }
    func search(keyword: String, page: Int, completion: @escaping (Result<SearchBooksResponse>) -> Void) {
        guard let url = "https://api.itbook.store/1.0/search/\(keyword)/\(page)".toURL else {
            completion(.error(RequestError.wrongURL))
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 3)
        request.httpMethod = "GET"
        session.dataTask(request: request) { data, _, error in
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
        guard let url = "https://api.itbook.store/1.0/books/\(isbn13)".toURL else {
            completion(.error(RequestError.wrongURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(request: request) { data, _, error in
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
        }.resume()
    }
    
    enum RequestError: Error {
        case nonKeyword
        case nonIsbn13
        case wrongURL
        var errorDescription: String? {
            switch self {
            case .wrongURL:
                return "URL??? ?????????????????????."
            case .nonKeyword:
                return "???????????? ???"
            case .nonIsbn13:
                return "ISBN??? ????????????."
            }
        }
    }
    
    enum ResponseError: Error {
        case nonData
        case serverMessage(_ message: String)
        
        var errorDescription: String? {
            switch self {
            case .nonData:
                return "???????????? ?????? ???????????????."
            case .serverMessage(let message):
                return message
            }
        }
    }
}







