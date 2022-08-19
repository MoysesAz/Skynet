//
//  UserService.swift
//  Skynet
//
//  Created by Lais Godinho on 16/08/22.
//

import Foundation

class UserService: API {
    static func getUsers(completion: @escaping ([User]) -> ()) {
        guard let url = URL(string: "\(baseURL)/users") else { fatalError("missing url") }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let users = try! JSONDecoder().decode([User].self, from: data!)
            DispatchQueue.main.async {
                completion(users)
            }
        }
        .resume()
    }
    
    static func getUserByID(id: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/users/\(id)") else { fatalError("missing url") }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let user = try JSONDecoder().decode(User.self, from: data)
        
        return user
    }
    
    static func setUser(user: User) async throws -> User.withToken {
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)/users")!)
        //Tratar
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = [
            "Content-Type": "application/json",
        ]
        
        urlRequest.httpBody = try JSONEncoder().encode(user)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let user = try JSONDecoder().decode(User.withToken.self, from: data)
        
        return user
    }
    
    static func authenticateUser(user: User.authentication) async throws -> (Int, User.withToken?) {
        let loginString = "\(user.username):\(user.password)"
        
        guard let loginData = loginString.data(using:String.Encoding.utf8) else {
            fatalError("Nome de usuario ou senha invalidos")
        }
        
        let base64LoginString = loginData.base64EncodedString()
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)/users/login")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        urlRequest.httpBody = try JSONEncoder().encode(user)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let status = (response as? HTTPURLResponse)?.statusCode else {
            fatalError("Algo está errado com a resposta do servidor")
        }
        
        do {
            let user = try JSONDecoder().decode(User.withToken.self, from: data)
            
            return (status, user)
        } catch {
            return (status, nil)
        }
    }
    
    static func logout(token: String) async throws -> Int {
        
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)/users/logout")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let responseHeader = response as? HTTPURLResponse {
            return responseHeader.statusCode
        }
        
        let user = try JSONDecoder().decode(User.withToken.self, from: data)
        print(user)
        
        let internalServerError = 500
        return internalServerError
    }
}
