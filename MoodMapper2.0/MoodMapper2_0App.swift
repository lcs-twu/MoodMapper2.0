//
//  MoodMapper2_0App.swift
//  MoodMapper2.0
//
//  Created by Tom Wu on 2023-04-13.
//

import SwiftUI

@main
struct MoodMapper2_0App: App {
    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.blackbirdDatabase, AppDatabase.instance)
        }
    }
}
