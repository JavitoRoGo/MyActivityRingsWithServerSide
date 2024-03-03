//
//  ContentView.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 6/12/23.
//

import SwiftUI

struct ContentView: View {
	@State private var showingProgressView = true
	
    var body: some View {
		ZStack {
			TabView {
				MainView()
					.tabItem { Image(systemName: "clock") }
				ChartView()
					.tabItem { Image(systemName: "calendar") }
			}
			if showingProgressView {
				ZStack {
					Color.white
					ProgressView()
				}
			}
		}
		.task {
			sleep(1)
			showingProgressView = false
		}
    }
}

#Preview {
    ContentView()
}
