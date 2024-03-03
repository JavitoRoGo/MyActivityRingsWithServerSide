//
//  Extensions.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 7/12/23.
//

import ActivityRingsSharedDTO
import Foundation

extension DayRingResponse: Identifiable {
	public static func ==(lhs: DayRingResponse, rhs: DayRingResponse) -> Bool {
		lhs.id == rhs.id
	}
}

extension TrainingResponse: Identifiable {
	public static func ==(lhs: TrainingResponse, rhs: TrainingResponse) -> Bool {
		lhs.id == rhs.id
	}
	
	var velocity: Double {
		if duration == 0 {
			return 0.0
		}
		return length / duration * 60
	}
}

extension RingData {
	public static func ==(lhs: RingData, rhs: RingData) -> Bool {
		lhs.id == rhs.id
	}
}
