//
//  MainView.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 6/12/23.
//

import SwiftUI

struct MainView: View {
	@EnvironmentObject var model: RingsViewModel
	@State private var showingAddNew = false
	
    var body: some View {
		NavigationStack {
			if model.ringDatas.isEmpty {
				VStack(spacing: 100) {
					Text("Añade algunos datos para\n comenzar a usar la app...")
						.font(.title)
					
					Button {
						showingAddNew = true
					} label: {
						Text("Añadir")
							.font(.largeTitle)
							.padding()
					}
					.buttonStyle(.borderedProminent)
				}
			} else {
				VStack {
					ScrollView(.horizontal) {
						LazyHStack {
							ForEach(model.ringDatas.sorted(by: { $0.dayRing.date > $1.dayRing.date })) { ring in
								VStack {
									Text("\(ring.dayRing.date.formatted(date: .complete, time: .omitted))")
										.font(.title2)
									
									RingView(data: ring.dayRing)
										.padding()
									
									ListView(data: ring)
								}
								.padding(.trailing)
								.containerRelativeFrame(.horizontal)
							}
						}
						.safeAreaPadding(.horizontal)
						.scrollTargetLayout()
					}
					.scrollIndicators(.hidden)
					.scrollTargetBehavior(.viewAligned)
				}
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						NavigationLink(destination: AllListedView()) {
							Image(systemName: "list.bullet")
						}
						.disabled(model.ringDatas.isEmpty)
					}
					ToolbarItem(placement: .topBarTrailing) {
						Button {
							showingAddNew = true
						} label: {
							Image(systemName: "plus")
						}
					}
				}
			}
		}
		.sheet(isPresented: $showingAddNew) {
			NavigationStack {
				AddNewView()
			}
		}
    }
}

#Preview {
    MainView()
		.environmentObject(RingsViewModel())
}
