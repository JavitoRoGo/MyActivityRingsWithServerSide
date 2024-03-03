//
//  AllListedView.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 8/12/23.
//

import SwiftUI

struct AllListedView: View {
	@EnvironmentObject var model: RingsViewModel
	@Environment(\.dismiss) var dismiss
	
	@State private var showingDeleteAlert = false
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(model.ringDatas.sorted(by: { $0.dayRing.date > $1.dayRing.date })) { ring in
					HStack {
						Text(ring.dayRing.date.formatted(date: .numeric, time: .omitted))
						Spacer()
						Text("\(ring.dayRing.movement)").foregroundStyle(.pink)
						Text("\(ring.dayRing.exercise)").foregroundStyle(.green)
						Text("\(ring.dayRing.standUp)").foregroundStyle(.blue)
						if let _ = ring.training {
							Circle()
								.fill(ring.training?.trainingType == .running ? .orange : .green)
								.frame(width: 10)
						}
					}
					.swipeActions(edge: .trailing) {
						Button(role: .destructive) {
							showingDeleteAlert = true
						} label: {
							Label("Borrar", systemImage: "trash")
						}
					}
				}
			}
			.navigationTitle("\(model.ringDatas.count) registros")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					HStack {
						Button {
							showingDeleteAlert = true
						} label: {
							Label("Borrar todo", systemImage: "trash")
						}
						.disabled(model.ringDatas.isEmpty)
						
						Button {
							shareButton()
						} label: {
							Label("Exportar", systemImage: "square.and.arrow.up")
						}
					}
				}
			}
			.alert("Estás a punto de borrar todos los datos.\n¿Estás seguro?", isPresented: $showingDeleteAlert) {
				Button("Cancelar", role: .cancel) { }
				Button("Borrar", role: .destructive) {
					Task {
						try await model.removeAllItems()
						dismiss()
					}
				}
			} message: {
				Text("Esta acción no podrá deshacerse.")
			}
		}
    }
	
	func shareButton() {
		let url = URL.documentsDirectory.appending(path: "ringDatas.json")
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		do {
			let data = try encoder.encode(model.ringDatas)
			try data.write(to: url, options: .atomic)
		} catch {
			print(error.localizedDescription)
		}
		
		let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		let scenes = UIApplication.shared.connectedScenes
		let windowScene = scenes.first as? UIWindowScene
		let window = windowScene?.windows.first
		window?.rootViewController!.present(ac, animated: true)
	}
}

#Preview {
    AllListedView()
		.environmentObject(RingsViewModel())
}
