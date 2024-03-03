//
//  ChartView.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 8/12/23.
//

import ActivityRingsSharedDTO
import Charts
import SwiftUI

struct ChartView: View {
	@EnvironmentObject var model: RingsViewModel
	@State private var pickerSelection = 0
	let pickerText = ["S", "M", "A", "Total"]
	
	var rings: [DayRingResponse] {
		model.getDataForChart(pickerSelection)
	}
	
	var calendarComponent: Calendar.Component {
		switch pickerSelection {
			case 1: .day
			case 2: .month
			case 3: .year
			default: .weekday
		}
	}
	
    var body: some View {
		NavigationStack {
			if model.ringDatas.isEmpty {
				VStack {
					Text("Añade algunos datos para")
					Text("comenzar a usar la app...")
				}
				.font(.title)
			} else {
				VStack {
					Picker("Intervalo de tiempo", selection: $pickerSelection.animation()) {
						ForEach(pickerText.indices, id: \.self) { index in
							Text(pickerText[index])
						}
					}
					.pickerStyle(.segmented)
					
					VStack {
						Chart(rings) { ring in
							BarMark(
								x: .value("Fecha", ring.date, unit: calendarComponent),
								y: .value("kcal", ring.movement)
							)
							.foregroundStyle(.pink)
						}
						Chart(rings) { ring in
							BarMark(
								x: .value("Fecha", ring.date, unit: calendarComponent),
								y: .value("minutos", ring.exercise)
							)
							.foregroundStyle(.green)
						}
						Chart(rings) { ring in
							BarMark(
								x: .value("Fecha", ring.date, unit: calendarComponent),
								y: .value("horas", ring.standUp)
							)
							.foregroundStyle(.blue)
						}
					}
					.chartXAxis {
						switch pickerSelection {
							case 1:
								AxisMarks(values: .stride(by: .day)) {
									AxisGridLine()
									AxisValueLabel(format: .dateTime.day(), centered: true)
								}
							case 2:
								AxisMarks(values: .stride(by: .month)) {
									AxisGridLine()
									AxisValueLabel(format: .dateTime.month(), centered: true)
								}
							case 3:
								AxisMarks(values: .stride(by: .year)) {
									AxisGridLine()
									AxisValueLabel(format: .dateTime.year(), centered: true)
								}
							default:
								AxisMarks(values: .stride(by: .day)) {
									AxisGridLine()
									AxisValueLabel(format: .dateTime.weekday(), centered: true)
								}
						}
					}
				}
				.padding()
				.navigationTitle("Histórico")
				.navigationBarTitleDisplayMode(.inline)
			}
		}
    }
}

#Preview {
    ChartView()
		.environmentObject(RingsViewModel())
}
