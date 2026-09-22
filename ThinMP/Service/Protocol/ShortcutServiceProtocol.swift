//
//  ShortcutServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol ShortcutServiceProtocol {
    func findAll() async -> [ShortcutModel]
}
