//
//  PreviewData.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 7/12/23.
//

import ActivityRingsSharedDTO
import Foundation

extension DayRingResponse {
	static let dataTest = DayRingResponse(id: UUID(uuidString: "5DE72331-5F77-4D37-8370-F4BE0670E716")!, date: Date(), movement: 555, exercise: 44, standUp: 19)
}

extension TrainingResponse {
	static let dataTest = TrainingResponse(id: UUID(uuidString: "78AABA32-1A18-4FFC-B038-5CC780499B12")!, date: Date(), duration: 60, length: 10, calories: 277, meanHR: 155, trainingType: .running)
}

extension RingData {
	static let dataTest = RingData(dayRing: DayRingResponse.dataTest, training: TrainingResponse.dataTest)
}
