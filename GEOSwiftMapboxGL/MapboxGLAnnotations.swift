//  Copyright (c) 2017 GEOSwiftMapboxGL. All rights reserved.

import Foundation
import CoreLocation
import GEOSwift
import Mapbox

// MARK: - MGLShape creation convenience function

public extension CLLocationCoordinate2D {
    init(_ point: Point) {
        self.init(latitude: point.y, longitude: point.x)
    }
}


public protocol GEOSwiftMapboxGL {
    /**
    A convenience method to create a `MGLShape` ready to be added to a `MGLMapView`.
    Mapbox has limited support to GEOS geometry types: be aware that when dealing with polygons, interior rings are not handled by MapBoxGL, we must drop this information while building a polygon shape.

    :returns: A MGLShape representing this geometry.
    */
    func mapboxShape() -> MGLShape
}

extension MGLPointAnnotation {
  convenience init(_ coord: CLLocationCoordinate2D) {
    self.init()
    self.coordinate = coord
  }
  
  convenience init(point: Point) {
    self.init(CLLocationCoordinate2D(point))
  }
}

extension MGLPolyline {
  convenience init(lineString: LineString) {
    var points = lineString.points.map(CLLocationCoordinate2D.init)
    self.init(coordinates: &points, count: UInt(points.count))
  }
}

extension MGLPolygon {
  convenience init(linearRing: Polygon.LinearRing) {
    var coordinates = linearRing.points.map(CLLocationCoordinate2D.init)
    self.init(coordinates: &coordinates, count: UInt(coordinates.count))
  }
  
  convenience init(polygon: Polygon) {
    var exteriorCoordinates = polygon.exterior.points.map(CLLocationCoordinate2D.init)
    self.init(
      coordinates: &exteriorCoordinates,
      count: UInt(exteriorCoordinates.count),
      interiorPolygons: polygon.holes.map(MGLPolygon.init)
    )
  }
}



extension Geometry : GEOSwiftMapboxGL {
    public func mapboxShape() -> MGLShape {
        switch self {
            
        case let .point(self):
            return MGLPointAnnotation(point: self)
            
        case let .lineString(self):
            return MGLPolyline(lineString: self)

        case let .polygon(self):
            return MGLPolygon(polygon: self)

        case let .multiPolygon(self):
            return MGLMultiPolygon(polygons: self.polygons.map(MGLPolygon.init))
        case let .geometryCollection(self):
            return MGLShapeCollection(shapes: self.geometries.map { $0.mapboxShape() })
        case let .multiPoint(self):
            return MGLShapeCollection(shapes: self.points.map(MGLPointAnnotation.init))
        case let .multiLineString(self):
            return MGLMultiPolyline(polylines: self.lineStrings.map(MGLPolyline.init))
      }
  }
  
  public func mapboxFeature() -> MGLShape & MGLFeature {
      switch self {
        case let .point(self):
            let pointAnno = MGLPointFeature()
            pointAnno.coordinate = CLLocationCoordinate2D(self)
            return pointAnno
        case let .lineString(self):
            var points = self.points.map({ CLLocationCoordinate2D($0)})
            return MGLPolylineFeature(coordinates: &points, count: UInt(points.count))
        case let .polygon(self):
            var exteriorRingCoordinates = self.exterior.points.map({ CLLocationCoordinate2D($0) })
            let interiorRings = self.holes.map { (linearRing: Polygon.LinearRing) -> MGLPolygon in
              var points = linearRing.points.map { CLLocationCoordinate2D($0) }
              return MGLPolygon(coordinates: &points, count: UInt(linearRing.points.count))
            }
            return MGLPolygonFeature(
              coordinates: &exteriorRingCoordinates,
              count: UInt(exteriorRingCoordinates.count),
              interiorPolygons: interiorRings)
        case let .multiPolygon(self):
            return  MGLMultiPolygonFeature(polygons: self.polygons.map(MGLPolygon.init))
        case let .geometryCollection(self):
            return MGLShapeCollectionFeature(shapes: self.geometries.map { $0.mapboxShape() })
        case let .multiPoint(self):
            return MGLShapeCollectionFeature(shapes: self.points.map(MGLPointAnnotation.init))
        case let .multiLineString(self):
            return MGLMultiPolylineFeature(polylines: self.lineStrings.map(MGLPolyline.init))
      }
  }
}
