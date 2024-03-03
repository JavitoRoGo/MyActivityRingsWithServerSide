//
//  MyActivityRingsWithServerSideApp.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 6/12/23.
//

import SwiftUI

@main
struct MyActivityRingsWithServerSideApp: App {
	@StateObject var model = RingsViewModel()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(model)
        }
    }
}
