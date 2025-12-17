//
//  My_ListApp.swift
//  My List
//
//  Created by student on 17/12/25.
//

import SwiftUI
import SwiftData

@main
struct My_ListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Item.self)
        }
    }
}
