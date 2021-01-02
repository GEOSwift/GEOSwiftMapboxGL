import CoreLocation
import Foundation
import GEOSwift
import Mapbox

public extension CLLocationCoordinate2D {
    init(_ point: Point) {
        self.init(latitude: point.y, longitude: point.x)
    }
}

public extension MGLPointAnnotation {
    convenience init(_ point: Point) {
        self.init()
        self.coordinate = CLLocationCoordinate2D(point)
    }
}

public extension MGLPolyline {
    convenience init(_ lineString: LineString) {
        var points = lineString.points.map(CLLocationCoordinate2D.init)
        self.init(coordinates: &points, count: UInt(points.count))
    }
}

public extension MGLPolygon {
    convenience init(_ polygon: Polygon) {
        var exteriorCoordinates = polygon.exterior.points.map(CLLocationCoordinate2D.init)
        self.init(
            coordinates: &exteriorCoordinates,
            count: UInt(exteriorCoordinates.count),
            interiorPolygons: polygon.holes.map(MGLPolygon.init))
    }

    convenience init(_ linearRing: Polygon.LinearRing) {
        var exteriorCoordinates = linearRing.points.map(CLLocationCoordinate2D.init)
        self.init(
            coordinates: &exteriorCoordinates,
            count: UInt(exteriorCoordinates.count))
    }
}

public extension MGLPointCollection {
    convenience init(_ multiPoint: MultiPoint) {
        var coordinates = multiPoint.points.map(CLLocationCoordinate2D.init)
        self.init(coordinates: &coordinates, count: UInt(coordinates.count))
    }
}

public extension MGLMultiPolyline {
    convenience init(_ multiLineString: MultiLineString) {
        self.init(polylines: multiLineString.lineStrings.map(MGLPolyline.init))
    }
}

public extension MGLMultiPolygon {
    convenience init(_ multiPolygon: MultiPolygon) {
        self.init(polygons: multiPolygon.polygons.map(MGLPolygon.init))
    }
}

public extension MGLShapeCollection {
    convenience init(_ geometryCollection: GeometryCollection) {
        self.init(shapes: geometryCollection.geometries.map(MGLShape.make))
    }
}

public extension MGLShape {

    static func make(with geometry: GeometryConvertible) -> MGLShape {
        switch geometry.geometry {
        case let .point(point):
            return MGLPointAnnotation(point)
        case let .lineString(lineString):
            return MGLPolyline(lineString)
        case let .polygon(polygon):
            return MGLPolygon(polygon)
        case let .multiPoint(multiPoint):
            return MGLPointCollection(multiPoint)
        case let .multiLineString(multiLineString):
            return MGLMultiPolyline(multiLineString)
        case let .multiPolygon(multiPolygon):
            return MGLMultiPolygon(multiPolygon)
        case let .geometryCollection(geometryCollection):
            return MGLShapeCollection(geometryCollection)
        }
    }

    static func makeFeature(with geometry: GeometryConvertible) -> MGLShape & MGLFeature {
        switch geometry.geometry {
        case let .point(point):
            return MGLPointFeature(point)
        case let .lineString(lineString):
            return MGLPolylineFeature(lineString)
        case let .polygon(polygon):
            return MGLPolygonFeature(polygon)
        case let .multiPoint(multiPoint):
            return MGLPointCollectionFeature(multiPoint)
        case let .multiLineString(multiLineString):
            return MGLMultiPolylineFeature(multiLineString)
        case let .multiPolygon(multiPolygon):
            return MGLMultiPolygonFeature(multiPolygon)
        case let .geometryCollection(geometryCollection):
            return MGLShapeCollectionFeature(geometryCollection)
        }
    }
}
