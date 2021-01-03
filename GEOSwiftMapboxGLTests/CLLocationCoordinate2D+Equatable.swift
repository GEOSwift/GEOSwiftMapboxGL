//
//  CLLocationCoordinate2D+Equatable.swift
//  GEOSwiftMapboxGLTests
//
//  Created by Andrew Hershberger on 1/2/21.
//  Copyright © 2021 GEOSwift. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}
