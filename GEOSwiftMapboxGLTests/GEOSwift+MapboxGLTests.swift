//  Copyright (c) 2017 GEOSwift. All rights reserved.

import GEOSwift
import GEOSwiftMapboxGL
import Mapbox
import XCTest

final class MapboxGLTests: XCTestCase {

    func testCreateCLLocationCoordinate2DFromPoint() {
        let point = Point(x: 45, y: 9)

        let coordinate = CLLocationCoordinate2D(point)

        XCTAssertEqual(coordinate, CLLocationCoordinate2D(latitude: 9, longitude: 45))
    }

    func testCreatePointWithLatAndLong() {
        let point = Point(longitude: 1, latitude: 2)

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
    }

    func testCreatePointWithCLLocationCoordinate2D() {
        let coord = CLLocationCoordinate2D(latitude: 2, longitude: 1)

        XCTAssertEqual(Point(coord), Point(x: 1, y: 2))
    }

    func testWorldPolygon() {
        // just make sure it doesn't crash
        _ = GEOSwift.Polygon.world
    }

    func testCreateMGLPointAnnotationFromPoint() {
        let point = Point(x: 45, y: 9)

        let annotation = MGLPointAnnotation(point: point)

        XCTAssertEqual(annotation.coordinate, CLLocationCoordinate2D(latitude: 9, longitude: 45))
    }

    func testCreateMGLPolylineFromLineString() {
        let lineString = try! LineString(wkt: "LINESTRING(3 4,10 50,20 25)")

        let polyline = MGLPolyline(lineString: lineString)

        XCTAssertEqual(polyline.pointCount, 3)
    }

    func testCreateMGLPolygonFromLinearRing() {
        let linearRing = try! Polygon.LinearRing(
            points: [
                Point(x: 35, y: 10),
                Point(x: 45, y: 45),
                Point(x: 15, y: 40),
                Point(x: 10, y: 20),
                Point(x: 35, y: 10)])

        let mkPolygon = MGLPolygon(linearRing: linearRing)

        XCTAssertEqual(mkPolygon.pointCount, 5)
        if #available(iOS 13.0, tvOS 13.0, macOS 10.15, *) {
            XCTAssertNil(mkPolygon.interiorPolygons)
        } else {
            XCTAssertEqual(mkPolygon.interiorPolygons?.count, 0)
        }
    }

    func testCreateMGLPolygonFromPolygon() {
        let polygon = try! Polygon(
            wkt: "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")

        let mkPolygon = MGLPolygon(polygon: polygon)

        XCTAssertEqual(mkPolygon.pointCount, 5)
        XCTAssertEqual(mkPolygon.interiorPolygons?.count, 1)
        XCTAssertEqual(mkPolygon.interiorPolygons?.first?.pointCount, 4)
    }

    func testCreateMGLMultiPolylineFromMultiLineString() {
        guard #available(iOS 13.0, tvOS 13.0, macOS 10.15, *) else {
            return
        }

        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(points: [Point(x: 0, y: 0), Point(x: 0, y: 1)]),
            LineString(points: [Point(x: 0, y: 0), Point(x: 1, y: 0)])])

        let mkMultiPolyline = MGLMultiPolyline(multiLineString: multiLineString)

        XCTAssertEqual(mkMultiPolyline.polylines.count, multiLineString.lineStrings.count)
    }

    func testCreateMGLMultiPolygonFromMultiPolygon() {
        guard #available(iOS 13.0, tvOS 13.0, macOS 10.15, *) else {
            return
        }

        let multiPolygon = try! MultiPolygon(polygons: [
            Polygon(wkt: "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"),
            Polygon(wkt: "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10))")])

        let mkMultiPolygon = MGLMultiPolygon(multiPolygon: multiPolygon)

        XCTAssertEqual(mkMultiPolygon.polygons.count, multiPolygon.polygons.count)
    }
}
