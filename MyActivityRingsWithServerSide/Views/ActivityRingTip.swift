//
//  ActivityRingTip.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 7/12/23.
//

import Foundation
import SwiftUI

struct ActivityRingTip: Shape {
	var progress: Double
	var ringRadius: Double
	
	private var position: CGPoint {
		let progressAngle = Angle(degrees: (360.0 * progress) - 90.0)
		return CGPoint(x: ringRadius * cos(progressAngle.radians),
					   y: ringRadius * sin(progressAngle.radians))
	}
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		if progress > 0.0 {
			path.addEllipse(in: CGRect(x: position.x, y: position.y, width: rect.size.width, height: rect.size.height))
		}
		return path
	}
}
