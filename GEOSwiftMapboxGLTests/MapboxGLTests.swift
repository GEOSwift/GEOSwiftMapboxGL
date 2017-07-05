//  Copyright (c) 2017 GEOSwift. All rights reserved.

import Foundation
import XCTest

import GEOSwift
import Mapbox
@testable import GEOSwiftMapboxGL

final class MapboxGLTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreateMKPointAnnotationFromPoint() {
        var result = false
        if let point = Geometry.create("POINT(45 9)") as? Waypoint,
            let _ = point.mapboxShape() as? MGLPointAnnotation {
                result = true
        }
        XCTAssert(result, "MGLPointAnnotation test failed")
    }

    func testCreateMKPolylineFromLineString() {
        var result = false
        let WKT = "LINESTRING(3 4,10 50,20 25)"
        if let linestring = Geometry.create(WKT) as? LineString,
            let _ = linestring.mapboxShape() as? MGLPolyline {
                result = true
        }
        XCTAssert(result, "MGLPolyline test failed")
    }

    func testCreateMKPolygonFromPolygon() {
        var result = false
        let WKT = "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"
        if let polygon = Geometry.create(WKT) as? Polygon,
            let _ = polygon.mapboxShape() as? MGLPolygon {
                result = true
        }
        XCTAssert(result, "MGLPolygon test failed")
    }

    func testCreateMKShapesCollectionFromGeometryCollection() {
        var result = false
        let WKT = "GEOMETRYCOLLECTION(POINT(4 6),LINESTRING(4 6,7 10))"
        if let geometryCollection = Geometry.create(WKT) as? GeometryCollection,
            let _ = geometryCollection.mapboxShape() as? MGLShapesCollection {
                result = true
        }
        XCTAssert(result, "MGLShapesCollection test failed")
    }
}
