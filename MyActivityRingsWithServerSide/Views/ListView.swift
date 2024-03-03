//
//  ListView.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 7/12/23.
//

import SwiftUI

struct ListView: View {
	@EnvironmentObject var model: RingsViewModel
	let data: RingData
	
	var hasTraining: Bool {
		if let _ = data.training {
			return true
		}
		return false
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: 40) {
				VStack(spacing: 0) {
					HStack {
						Text("Movimiento")
						Spacer()
						Text("\(data.dayRing.movement) kcal")
					}
					.foregroundStyle(.pink)
					.padding(.horizontal)
					.padding(.vertical, 8)
					.overlay {
						RoundedRectangle(cornerRadius: 15)
							.stroke(.primary.opacity(0.2))
					}
					
					HStack {
						Text("Ejercicio")
						Spacer()
						Text("\(data.dayRing.exercise) minutos")
					}
					.foregroundStyle(.green)
					.padding(.horizontal)
					.padding(.vertical, 8)
					.overlay {
						RoundedRectangle(cornerRadius: 15)
							.stroke(.primary.opacity(0.2))
					}
					
					HStack {
						Text("De pie")
						Spacer()
						Text("\(data.dayRing.standUp) horas")
					}
					.foregroundStyle(.blue)
					.padding(.horizontal)
					.padding(.vertical, 8)
					.overlay {
						RoundedRectangle(cornerRadius: 15)
							.stroke(.primary.opacity(0.2))
					}
					
					HStack {
						Text("Entrenamiento")
						Spacer()
						Image(systemName: "figure.walk")
							.font(.title)
							.foregroundStyle(hasTraining ? .green : .gray.opacity(0.4))
					}
					.foregroundStyle(hasTraining ? .primary : Color.secondary.opacity(0.4))
					.padding(.horizontal)
					.padding(.vertical, 5)
					.overlay {
						RoundedRectangle(cornerRadius: 15)
							.stroke(.primary.opacity(0.2))
					}
				}
				
				if let training = data.training {
					VStack(spacing: 0) {
						HStack {
							Text("Tipo")
							Spacer()
							Image(systemName: training.trainingType == .running ? "hare.fill" : "tortoise.fill")
								.foregroundColor(training.trainingType == .running ? .orange : .green)
						}
						.padding(.horizontal)
						.padding(.vertical, 8)
						.overlay {
							RoundedRectangle(cornerRadius: 15)
								.stroke(.primary.opacity(0.2))
						}
						HStack {
							Text("Duración")
							Spacer()
							Text("\(training.duration, format: .number.precision(.fractionLength(1))) minutos")
						}
						.padding(.horizontal)
						.padding(.vertical, 8)
						.overlay {
							RoundedRectangle(cornerRadius: 15)
								.stroke(.primary.opacity(0.2))
						}
						HStack {
							Text("Distancia")
							Spacer()
							Text("\(training.length, format: .number) km")
						}
						.padding(.horizontal)
						.padding(.vertical, 8)
						.overlay {
							RoundedRectangle(cornerRadius: 15)
								.stroke(.primary.opacity(0.2))
						}
						HStack {
							Text("Velocidad")
							Spacer()
							Text("\(training.velocity, format: .number.precision(.fractionLength(2))) km/h")
						}
						.padding(.horizontal)
						.padding(.vertical, 8)
						.overlay {
							RoundedRectangle(cornerRadius: 15)
								.stroke(.primary.opacity(0.2))
						}
						HStack {
							Text("Calorías")
							Spacer()
							Text("\(training.calories, format: .number) kcal")
						}
						.padding(.horizontal)
						.padding(.vertical, 8)
						.overlay {
							RoundedRectangle(cornerRadius: 15)
								.stroke(.primary.opacity(0.2))
						}
						HStack {
							Text("FC media")
							Spacer()
							Text("\(training.meanHR, format: .number) lpm")
						}
						.padding(.horizontal)
						.padding(.vertical, 8)
						.overlay {
							RoundedRectangle(cornerRadius: 15)
								.stroke(.primary.opacity(0.2))
						}
					}
				}
			}
			.padding(.horizontal, 40)
		}
    }
}

#Preview {
	ListView(data: RingData.dataTest)
		.environmentObject(RingsViewModel())
}
