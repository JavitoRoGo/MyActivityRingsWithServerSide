//
//  RingsViewModel.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 6/12/23.
//

import ActivityRingsSharedDTO
import Foundation

@MainActor
final class RingsViewModel: ObservableObject {
	@Published var dayRings: [DayRingResponse] = []
	@Published var trainings: [TrainingResponse] = []
	@Published var ringDatas: [RingData] = []
	
	init() {
		Task {
			try await fetchDayRings()
			try await fetchTrainings()
			
			for ring in dayRings {
				var newRing = RingData(dayRing: ring, training: nil)
				if let training = try await getTrainingFor(ring) {
					newRing.training = training
				}
				ringDatas.append(newRing)
			}
		}
	}
	
	let client = HTTPClient()
	
	// DAY RING
	
	func fetchDayRings() async throws {
		let resource = Resource(url: CustomURL.getAllRings, modelType: [DayRingResponse].self)
		dayRings = try await client.load(resource)
	}
	
	func saveNewRingFrom(_ ringRequest: DayRingRequest) async throws -> DayRingResponse {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		let data = try encoder.encode(ringRequest)
		
		let resource = Resource(url: CustomURL.saveNewRing, method: .post(data), modelType: DayRingResponse.self)
		let newRing = try await client.load(resource)
		dayRings.insert(newRing, at: 0)
		
		ringDatas.insert(RingData(dayRing: newRing), at: 0)
		return newRing
	}
	
	// TRAININGS
	
	func fetchTrainings() async throws {
		let resource = Resource(url: CustomURL.getAllTrainings, modelType: [TrainingResponse].self)
		trainings = try await client.load(resource)
	}
	
	func getTrainingFor(_ ring: DayRingResponse) async throws -> TrainingResponse? {
		let resource = Resource(url: CustomURL.getTrainingFor(ring), modelType: TrainingResponse.self)
		guard let training = try? await client.load(resource) else { return nil }
		return training
	}
	
	func saveNewTraining(from request: TrainingRequest, in ring: DayRingResponse) async throws {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		let data = try encoder.encode(request)
		
		let resource = Resource(url: CustomURL.saveNewTrainingIn(ring), method: .post(data), modelType: TrainingResponse.self)
		let newTraining = try await client.load(resource)
		trainings.insert(newTraining, at: 0)
		
		if let index = ringDatas.firstIndex(where: { $0.dayRing.id == ring.id }) {
			ringDatas[index].training = newTraining
		}
	}
	
	func hasTraining(_ ring: DayRingResponse) async throws -> Bool {
		if let _ = try await getTrainingFor(ring) {
			return true
		}
		
		return false
	}
	
	
	// remove one item
	func removeOneItem(_ ring: RingData) async throws {
		ringDatas.removeAll(where: { $0 == ring })
		
		let resource = Resource(url: CustomURL.deleteRing(ring.dayRing), method: .delete, modelType: DayRingResponse.self)
		let _ = try await client.load(resource)
	}
	
	// remove all items
	func removeAllItems() async throws {
		let resource = Resource(url: CustomURL.deleteAllRings, method: .delete, modelType: [DayRingResponse].self)
		let _ = try await client.load(resource)
		
		ringDatas.removeAll()
	}
	
	// Get data for bar chart
	
	func getDataForChart(_ tag: Int) -> [DayRingResponse] {
		let sorted = dayRings.sorted(by: { $0.date > $1.date })
		let mostRecentDate = sorted.first!.date
		let response: [DayRingResponse]
		
		switch tag {
			case 1: response = sorted.filter { $0.date > mostRecentDate - 1.months }
			case 2: response = sorted.filter { $0.date > mostRecentDate - 1.years }
			case 3: response = sorted
			default: response = sorted.filter { $0.date > mostRecentDate - 1.weeks }
		}
		
		return response
	}
}
