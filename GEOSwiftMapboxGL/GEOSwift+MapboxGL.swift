import CoreLocation
import Foundation
import GEOSwift
import Mapbox

public extension CLLocationCoordinate2D {
    init(_ point: Point) {
        self.init(latitude: point.y, longitude: point.x)
    }
}

public extension Point {
    init(longitude: Double, latitude: Double) {
        self.init(x: longitude, y: latitude)
    }

    init(_ coordinate: CLLocationCoordinate2D) {
        self.init(x: coordinate.longitude, y: coordinate.latitude)
    }
}

public extension GEOSwift.Polygon {
    // swiftlint:disable:next force_try
    static let world = try! GEOSwift.Polygon(
        exterior: Polygon.LinearRing(
            points: [
                Point(x: -180, y: 90),
                Point(x: -180, y: -90),
                Point(x: 180, y: -90),
                Point(x: 180, y: 90),
                Point(x: -180, y: 90)]))
}

public extension MGLPointAnnotation {
    convenience init(point: Point) {
        self.init()
        self.coordinate = CLLocationCoordinate2D(point)
    }
}

public extension MGLPolyline {
    convenience init(lineString: LineString) {
        var points = lineString.points.map(CLLocationCoordinate2D.init)
        self.init(coordinates: &points, count: UInt(points.count))
    }
}

public extension MGLPolygon {
    convenience init(polygon: GEOSwift.Polygon) {
        var exteriorCoordinates = polygon.exterior.points.map(CLLocationCoordinate2D.init)
        self.init(
            coordinates: &exteriorCoordinates,
            count: UInt(exteriorCoordinates.count),
            interiorPolygons: polygon.holes.map(MGLPolygon.init))
    }

    convenience init(linearRing: GEOSwift.Polygon.LinearRing) {
        var coordinates = linearRing.points.map(CLLocationCoordinate2D.init)
        self.init(coordinates: &coordinates, count: UInt(coordinates.count))
    }
}

public extension MGLPointCollection {
    convenience init(multiPoint: MultiPoint) {
        var coordinates = multiPoint.points.map(CLLocationCoordinate2D.init)
        self.init(coordinates: &coordinates, count: UInt(coordinates.count))
    }
}

public extension MGLMultiPolyline {
    convenience init(multiLineString: MultiLineString) {
        self.init(polylines: multiLineString.lineStrings.map(MGLPolyline.init))
    }
}

public extension MGLMultiPolygon {
    convenience init(multiPolygon: MultiPolygon) {
        self.init(polygons: multiPolygon.polygons.map(MGLPolygon.init))
    }
}

public extension MGLShapeCollection {
    convenience init(geometryCollection: GeometryCollection) {
        self.init(shapes: geometryCollection.geometries.map(MGLShape.make))
    }
}

public extension MGLShape {
    static func make(with geometry: GeometryConvertible) -> MGLShape {
        switch geometry.geometry {
        case let .point(point):
            return MGLPointAnnotation(point: point)
        case let .lineString(lineString):
            return MGLPolyline(lineString: lineString)
        case let .polygon(polygon):
            return MGLPolygon(polygon: polygon)
        case let .multiPoint(multiPoint):
            return MGLPointCollection(multiPoint: multiPoint)
        case let .multiLineString(multiLineString):
            return MGLMultiPolyline(multiLineString: multiLineString)
        case let .multiPolygon(multiPolygon):
            return MGLMultiPolygon(multiPolygon: multiPolygon)
        case let .geometryCollection(geometryCollection):
            return MGLShapeCollection(geometryCollection: geometryCollection)
        }
    }

    static func makeFeature(with geometry: GeometryConvertible) -> MGLShape & MGLFeature {
        switch geometry.geometry {
        case let .point(point):
            return MGLPointFeature(point: point)
        case let .lineString(lineString):
            return MGLPolylineFeature(lineString: lineString)
        case let .polygon(polygon):
            return MGLPolygonFeature(polygon: polygon)
        case let .multiPoint(multiPoint):
            return MGLPointCollectionFeature(multiPoint: multiPoint)
        case let .multiLineString(multiLineString):
            return MGLMultiPolylineFeature(multiLineString: multiLineString)
        case let .multiPolygon(multiPolygon):
            return MGLMultiPolygonFeature(multiPolygon: multiPolygon)
        case let .geometryCollection(geometryCollection):
            return MGLShapeCollectionFeature(geometryCollection: geometryCollection)
        }
    }
}
