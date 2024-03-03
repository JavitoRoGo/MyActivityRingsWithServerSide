//
//  RingData.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 6/12/23.
//

import ActivityRingsSharedDTO
import Foundation

struct RingData: Codable, Identifiable {
	var dayRing: DayRingResponse
	var training: TrainingResponse?
	var id: UUID {
		dayRing.id
	}
}
