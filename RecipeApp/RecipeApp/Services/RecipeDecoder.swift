//
//  RecipeDecoder.swift
//  RecipeApp
//
//  Created by ossama mikhail on 10/23/24.
//

import Foundation

protocol RecipeDecoder {
    func decodeData<T: Decodable>(from data: Data, responseType: T.Type) throws -> T
}

extension RecipeDecoder {
    func decodeData<T: Decodable>(from data: Data, responseType: T.Type) throws -> T {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
}
