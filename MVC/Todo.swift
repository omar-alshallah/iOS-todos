//
//  Todo.swift
//  MVC
//
//  Created by Omar Alshallah Mhd Wajih on 22/03/2023.
//

import Foundation

struct Todo: Codable {
    var completed: Bool
    var id: Int
    var title: String
    var userId: Int
}
