//
//  AddNewView.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 7/12/23.
//

import ActivityRingsSharedDTO
import SwiftUI

struct AddNewView: View {
	@EnvironmentObject var model: RingsViewModel
	@Environment(\.dismiss) var dismiss
	
	@State private var newDate: Date = .now
	@State private var newMovement: Int = 0
	@State private var newExercise: Int = 0
	@State private var newStandUp: Int = 0
	@State private var newIsTraining: Bool = false
	
	var isDisabled: Bool {
		if newMovement != 0 && newExercise != 0 && newStandUp != 0 {
			if newIsTraining {
				if newDuration != 0 && newLength != 0 && newCals != 0 && newMeanHR != 0 {
					return false
				}
			}
			return false
		}
		return true
	}
	
	@State private var newTrainType: TrainingType = .running
	@State private var newDurationInHour: Int = 0
	@State private var newDurationInMinutes: Int = 0
	@State private var newDurationInSeconds: Int = 0
	@State private var newLength: Double = 0.0
	@State private var newCals: Int = 0
	@State private var newMeanHR: Int = 0
	var newDuration: Double {
		Double(newDurationInHour*60 + newDurationInMinutes) + (Double(newDurationInSeconds) / 60.0)
	}
	var velocity: Double {
		if newDuration == 0 {
			return 0.0
		}
		return newLength / newDuration * 60
	}
	
    var body: some View {
		Form {
			Section {
				HStack {
					Text("Fecha")
					Spacer()
					DatePicker("", selection: $newDate, in: ...Date(), displayedComponents: .date)
				}
				HStack {
					Text("Movimiento")
					Spacer()
					TextField("kcal", value: $newMovement, format: .number)
						.multilineTextAlignment(.trailing)
				}
				.foregroundColor(.pink)
				HStack {
					Text("Ejercicio")
					Spacer()
					TextField("minutos", value: $newExercise, format: .number)
						.multilineTextAlignment(.trailing)
				}
				.foregroundColor(.green)
				HStack {
					Text("De pie")
					Spacer()
					TextField("horas", value: $newStandUp, format: .number)
						.multilineTextAlignment(.trailing)
				}
				.foregroundColor(.blue)
				Toggle(isOn: $newIsTraining) {
					Text("Entrenamiento")
				}
			}
			
			Section {
				if newIsTraining {
					Picker("Tipo", selection: $newTrainType) {
						ForEach(TrainingType.allCases, id:\.self) {
							Text($0.rawValue)
						}
					}
					HStack {
						Text("Tiempo")
						Spacer()
						HStack {
							Picker("horas", selection: $newDurationInHour) {
								ForEach(0...2, id: \.self) {
									Text("\($0) h")
								}
							}
							.frame(width: 20)
							Picker("minutos", selection: $newDurationInMinutes) {
								ForEach(0...59, id: \.self) {
									Text("\($0) m")
								}
							}
							Picker("segundos", selection: $newDurationInSeconds) {
								ForEach(0...59, id: \.self) {
									Text("\($0) s")
								}
							}
						}
						.labelsHidden()
					}
					HStack {
						Text("Distancia (km)")
						Spacer()
						TextField("km", value: $newLength, format: .number)
							.multilineTextAlignment(.trailing)
					}
					HStack {
						Text("Velocidad (km/h)")
						Spacer()
						Text(velocity, format: .number.precision(.fractionLength(2)))
							.foregroundColor(.secondary)
					}
					HStack {
						Text("Calorías (kcal)")
						Spacer()
						TextField("kcal", value: $newCals, format: .number)
							.multilineTextAlignment(.trailing)
					}
					HStack {
						Text("FC media (lpm)")
						Spacer()
						TextField("lpm", value: $newMeanHR, format: .number)
							.multilineTextAlignment(.trailing)
					}
				}
			}
		}
		.navigationTitle("Nuevo registro")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				Button("Cancelar") {
					dismiss()
				}
			}
			ToolbarItem(placement: .topBarTrailing) {
				Button("Añadir") {
					Task { await saveNewData() }
				}
				.disabled(isDisabled)
			}
		}
    }
	
	func saveNewData() async {
		var newRing = DayRingResponse(id: UUID(), date: .now, movement: 0, exercise: 0, standUp: 0)
		let request = DayRingRequest(date: newDate, movement: newMovement, exercise: newExercise, standUp: newStandUp)
		do {
			newRing = try await model.saveNewRingFrom(request)
		} catch {
			print(error.localizedDescription)
		}
		
		if newIsTraining {
			let trainingRequest = TrainingRequest(date: newDate, duration: newDuration, length: newLength, calories: newCals, meanHR: newMeanHR, trainingType: newTrainType)
			do {
				try await model.saveNewTraining(from: trainingRequest, in: newRing)
			} catch {
				print(error.localizedDescription)
			}
		}
		dismiss()
	}
}

#Preview {
    AddNewView()
		.environmentObject(RingsViewModel())
}
