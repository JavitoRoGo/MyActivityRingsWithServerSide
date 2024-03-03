//
//  RingView.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 7/12/23.
//

import ActivityRingsSharedDTO
import SwiftUI

struct RingView: View {
	let data: DayRingResponse
	
    var body: some View {
		ZStack {
			ActivityRing(progress: Double(data.movement) / 300, ringRadius: 160)
			ActivityRing(progress: Double(data.exercise) / 30, ringRadius: 120, startColor: Color(red: 146/255, green: 225/255, blue: 166/255), endColor: .green)
			ActivityRing(progress: Double(data.standUp) / 12, ringRadius: 80, startColor: Color(red: 118/255, green: 184/255, blue: 255/255), endColor: .blue)
			
		}
		.frame(height: 350)
    }
}

#Preview {
	RingView(data: DayRingResponse.dataTest)
}
