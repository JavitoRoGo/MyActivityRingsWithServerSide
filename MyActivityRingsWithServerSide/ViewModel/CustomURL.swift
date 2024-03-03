//
//  CustomURL.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 6/12/23.
//

import ActivityRingsSharedDTO
import Foundation

struct CustomURL {
	private static let baseURL = "http://127.0.0.1:8080/api"
	
	// DAY RINGS
	
	// /rings/all
	static let getAllRings = URL(string: "\(baseURL)/rings/all")!
	
	// /rings/new
	static let saveNewRing = URL(string: "\(baseURL)/rings/new")!
	
	// /rings/delete/:ring_id
	static func deleteRing(_ ring: DayRingResponse) -> URL {
		URL(string: "\(baseURL)/rings/delete/\(ring.id)")!
	}
	
	// /rings/delete/all
	static let deleteAllRings = URL(string: "\(baseURL)/rings/delete/all")!
	
	
	// TRAININGS
	
	// /trainings/all
	static let getAllTrainings = URL(string: "\(baseURL)/trainings/all")!
	
	// /trainings/:ring_id
	static func getTrainingFor(_ ring: DayRingResponse) -> URL {
		URL(string: "\(baseURL)/trainings/\(ring.id)")!
	}
	
	// /trainings/:ring_id/new
	static func saveNewTrainingIn(_ ring: DayRingResponse) -> URL {
		URL(string: "\(baseURL)/trainings/\(ring.id)/new")!
	}
}
