//  Copyright (c) 2017 GEOSwift. All rights reserved.

import GEOSwift
import GEOSwiftMapboxGL
import Mapbox
import XCTest

final class MapboxGLTests: XCTestCase {

    // CLLocationCoordinate2D

    func testCreateCLLocationCoordinate2DFromPoint() {
        let point = Point(x: 45, y: 9)

        let coordinate = CLLocationCoordinate2D(point)

        XCTAssertEqual(coordinate, CLLocationCoordinate2D(latitude: 9, longitude: 45))
    }

    // Point

    func testCreatePointWithLatAndLong() {
        let point = Point(longitude: 1, latitude: 2)

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
    }

    func testCreatePointWithCLLocationCoordinate2D() {
        let coord = CLLocationCoordinate2D(latitude: 2, longitude: 1)

        XCTAssertEqual(Point(coord), Point(x: 1, y: 2))
    }

    // Polygon

    func testWorldPolygon() {
        // just make sure it doesn't crash
        _ = GEOSwift.Polygon.world
    }

    // MGLPointAnnotation

    func verifyMGLPointCreation<T>(with factory: (Point) -> MGLShape,
                                   expectedType: T.Type,
                                   line: UInt = #line) where T: MGLPointAnnotation {
        let point = Point(x: 45, y: 9)

        let shape = factory(point)

        XCTAssertTrue(shape.isMember(of: T.self), line: line)
        XCTAssertEqual(shape.coordinate, CLLocationCoordinate2D(latitude: 9, longitude: 45), line: line)
    }

    func testCreateMGLPointAnnotationFromPoint() {
        verifyMGLPointCreation(with: MGLPointAnnotation.init(point:), expectedType: MGLPointAnnotation.self)
    }

    func testCreateMGLPointAnnotationFromPointViaMGLShapeMake() {
        verifyMGLPointCreation(with: MGLShape.make(with:), expectedType: MGLPointAnnotation.self)
    }

    func testCreateMGLPointFeatureFromPoint() {
        verifyMGLPointCreation(with: MGLPointFeature.init(point:), expectedType: MGLPointFeature.self)
    }

    func testCreateMGLPointFeatureFromPointViaMGLShapeMakeFeature() {
        verifyMGLPointCreation(with: MGLShape.makeFeature(with:), expectedType: MGLPointFeature.self)
    }

    // MGLPolyline

    func verifyMGLPolylineCreation<T>(with factory: (LineString) -> MGLShape,
                                      expectedType: T.Type,
                                      line: UInt = #line) where T: MGLPolyline {
        let lineString = try! LineString(wkt: "LINESTRING(3 4,10 50,20 25)")

        let shape = factory(lineString)

        XCTAssertTrue(shape.isMember(of: T.self), line: line)
        guard let polyline = shape as? T else {
            return
        }
        XCTAssertEqual(polyline.pointCount, 3, line: line)
    }

    func testCreateMGLPolylineFromLineString() {
        verifyMGLPolylineCreation(with: MGLPolyline.init(lineString:), expectedType: MGLPolyline.self)
    }

    func testCreateMGLPolylineFromLineStringViaMGLShapeMake() {
        verifyMGLPolylineCreation(with: MGLShape.make(with:), expectedType: MGLPolyline.self)
    }

    func testCreateMGLPolylineFeatureFromLineString() {
        verifyMGLPolylineCreation(with: MGLPolylineFeature.init(lineString:), expectedType: MGLPolylineFeature.self)
    }

    func testCreateMGLPolylineFeatureFromLineStringViaMGLShapeMakeFeature() {
        verifyMGLPolylineCreation(with: MGLShape.makeFeature(with:), expectedType: MGLPolylineFeature.self)
    }

    // MGLPolygon

    func testCreateMGLPolygonFromLinearRing() {
        let linearRing = try! Polygon.LinearRing(
            points: [
                Point(x: 35, y: 10),
                Point(x: 45, y: 45),
                Point(x: 15, y: 40),
                Point(x: 10, y: 20),
                Point(x: 35, y: 10)])

        let mglPolygon = MGLPolygon(linearRing: linearRing)

        XCTAssertEqual(mglPolygon.pointCount, 5)
        XCTAssertNil(mglPolygon.interiorPolygons)
    }

    func verifyMGLPolygonCreation<T>(with factory: (Polygon) -> MGLShape,
                                     expectedType: T.Type,
                                     line: UInt = #line) where T: MGLPolygon {
        let polygon = try! Polygon(
            wkt: "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")

        let shape = factory(polygon)

        XCTAssertTrue(shape.isMember(of: T.self), line: line)
        guard let mglPolygon = shape as? T else {
            return
        }
        XCTAssertEqual(mglPolygon.pointCount, 5, line: line)
        XCTAssertEqual(mglPolygon.interiorPolygons?.count, 1, line: line)
        XCTAssertEqual(mglPolygon.interiorPolygons?.first?.pointCount, 4, line: line)
    }

    func testCreateMGLPolygonFromPolygon() {
        verifyMGLPolygonCreation(with: MGLPolygon.init(polygon:), expectedType: MGLPolygon.self)
    }

    func testCreateMGLPolygonFromPolygonViaMGLShapeMake() {
        verifyMGLPolygonCreation(with: MGLShape.make(with:), expectedType: MGLPolygon.self)
    }

    func testCreateMGLPolygonFeatureFromPolygon() {
        verifyMGLPolygonCreation(with: MGLPolygonFeature.init(polygon:), expectedType: MGLPolygonFeature.self)
    }

    func testCreateMGLPolygonFeatureFromPolygonViaMGLShapeMakeFeature() {
        verifyMGLPolygonCreation(with: MGLShape.makeFeature(with:), expectedType: MGLPolygonFeature.self)
    }

    // MGLPointCollection

    func verifyMGLPointCollectionCreation<T>(with factory: (MultiPoint) -> MGLShape,
                                             expectedType: T.Type,
                                             line: UInt = #line) where T: MGLPointCollection {
        let multiPoint = MultiPoint(points: [Point(x: 0, y: 1), Point(x: 2, y: 3)])

        let shape = factory(multiPoint)

        XCTAssertTrue(shape.isMember(of: T.self), line: line)
        guard let mglPointCollection = shape as? T else {
            return
        }
        XCTAssertEqual(mglPointCollection.pointCount, 2, line: line)
        var coordinate0 = CLLocationCoordinate2D(latitude: .nan, longitude: .nan)
        mglPointCollection.getCoordinates(&coordinate0, range: NSRange(location: 0, length: 1))
        var coordinate1 = CLLocationCoordinate2D(latitude: .nan, longitude: .nan)
        mglPointCollection.getCoordinates(&coordinate1, range: NSRange(location: 1, length: 1))
        XCTAssertEqual(coordinate0, CLLocationCoordinate2D(latitude: 1, longitude: 0), line: line)
        XCTAssertEqual(coordinate1, CLLocationCoordinate2D(latitude: 3, longitude: 2), line: line)
    }

    func testCreateMGLPointCollectionFromMultiPoint() {
        verifyMGLPointCollectionCreation(with: MGLPointCollection.init(multiPoint:), expectedType: MGLPointCollection.self)
    }

    func testCreateMGLPointCollectionFromMultiPointViaMGLShapeMake() {
        verifyMGLPointCollectionCreation(with: MGLShape.make(with:), expectedType: MGLPointCollection.self)
    }

    func testCreateMGLPointCollectionFeatureFromMultiPoint() {
        verifyMGLPointCollectionCreation(with: MGLPointCollectionFeature.init(multiPoint:), expectedType: MGLPointCollectionFeature.self)
    }

    func testCreateMGLPointCollectionFeatureFromMultiPointViaMGLShapeMakeFeature() {
        verifyMGLPointCollectionCreation(with: MGLShape.makeFeature(with:), expectedType: MGLPointCollectionFeature.self)
    }

    // MGLMultiPolyline

    func verifyMGLMultiPolylineCreation<T>(with factory: (MultiLineString) -> MGLShape,
                                           expectedType: T.Type,
                                           line: UInt = #line) where T: MGLMultiPolyline {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(points: [Point(x: 0, y: 0), Point(x: 0, y: 1)]),
            LineString(points: [Point(x: 0, y: 0), Point(x: 1, y: 0)])])

        let shape = factory(multiLineString)

        XCTAssertTrue(shape.isMember(of: T.self), line: line)
        guard let mglMultiPolyline = shape as? T else {
            return
        }
        XCTAssertEqual(mglMultiPolyline.polylines.count, multiLineString.lineStrings.count, line: line)
    }

    func testCreateMGLMultiPolylineFromMultiLineString() {
        verifyMGLMultiPolylineCreation(with: MGLMultiPolyline.init(multiLineString:), expectedType: MGLMultiPolyline.self)
    }

    func testCreateMGLMultiPolylineFromMultiLineStringViaMGLShapeMake() {
        verifyMGLMultiPolylineCreation(with: MGLShape.make(with:), expectedType: MGLMultiPolyline.self)
    }

    func testCreateMGLMultiPolylineFeatureFromMultiLineString() {
        verifyMGLMultiPolylineCreation(with: MGLMultiPolylineFeature.init(multiLineString:), expectedType: MGLMultiPolylineFeature.self)
    }

    func testCreateMGLMultiPolylineFeatureFromMultiLineStringViaMGLShapeMakeFeature() {
        verifyMGLMultiPolylineCreation(with: MGLShape.makeFeature(with:), expectedType: MGLMultiPolylineFeature.self)
    }

    // MGLMultiPolygon

    func verifyMGLMultiPolygonCreation<T>(with factory: (MultiPolygon) -> MGLShape,
                                          expectedType: T.Type,
                                          line: UInt = #line) where T: MGLMultiPolygon {
        let multiPolygon = try! MultiPolygon(polygons: [
            Polygon(wkt: "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"),
            Polygon(wkt: "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10))")])

        let shape = factory(multiPolygon)

        XCTAssertTrue(shape.isMember(of: T.self), line: line)
        guard let mglMultiPolygon = shape as? T else {
            return
        }
        XCTAssertEqual(mglMultiPolygon.polygons.count, multiPolygon.polygons.count, line: line)
    }

    func testCreateMGLMultiPolygonFromMultiPolygon() {
        verifyMGLMultiPolygonCreation(with: MGLMultiPolygon.init(multiPolygon:), expectedType: MGLMultiPolygon.self)
    }

    func testCreateMGLMultiPolygonFromMultiPolygonViaMGLShapeMake() {
        verifyMGLMultiPolygonCreation(with: MGLShape.make(with:), expectedType: MGLMultiPolygon.self)
    }

    func testCreateMGLMultiPolygonFeatureFromMultiPolygon() {
        verifyMGLMultiPolygonCreation(with: MGLMultiPolygonFeature.init(multiPolygon:), expectedType: MGLMultiPolygonFeature.self)
    }

    func testCreateMGLMultiPolygonFeatureFromMultiPolygonViaMGLShapeMakeFeature() {
        verifyMGLMultiPolygonCreation(with: MGLShape.makeFeature(with:), expectedType: MGLMultiPolygonFeature.self)
    }

    // MGLShapeCollection

    func verifyMGLShapeCollectionCreation<T>(with factory: (GeometryCollection) -> MGLShape,
                                             expectedType: T.Type,
                                             line: UInt = #line) where T: MGLShapeCollection {
        let geometryCollection = GeometryCollection(geometries: [Point(x: 0, y: 1)])

        let shape = factory(geometryCollection)

        XCTAssertTrue(shape.isMember(of: T.self))
        guard let shapeCollection = shape as? T else {
            return
        }
        XCTAssertEqual(shapeCollection.shapes.count, 1, line: line)
        XCTAssertTrue(shapeCollection.shapes.first is MGLPointAnnotation, line: line)
        XCTAssertEqual(shapeCollection.shapes.first?.coordinate, CLLocationCoordinate2D(latitude: 1, longitude: 0), line: line)
    }

    func testCreateMGLShapeCollectionFromGeometryCollection() {
        verifyMGLShapeCollectionCreation(with: MGLShapeCollection.init(geometryCollection:), expectedType: MGLShapeCollection.self)
    }

    func testCreateMGLShapeCollectionFromGeometryCollectionViaMGLShapeMake() {
        verifyMGLShapeCollectionCreation(with: MGLShape.make(with:), expectedType: MGLShapeCollection.self)
    }

    func testCreateMGLShapeCollectionFeatureFromGeometryCollection() {
        verifyMGLShapeCollectionCreation(with: MGLShapeCollectionFeature.init(geometryCollection:), expectedType: MGLShapeCollectionFeature.self)
    }

    func testCreateMGLShapeCollectionFeatureFromGeometryCollectionViaMGLShapeMakeFeature() {
        verifyMGLShapeCollectionCreation(with: MGLShape.makeFeature(with:), expectedType: MGLShapeCollectionFeature.self)
    }
}
