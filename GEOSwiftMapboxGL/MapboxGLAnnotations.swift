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
  convenience init(point: Point) {
    self.init()
    self.coordinate = CLLocationCoordinate2D(point)
  }
}

extension MGLPolyline {
  convenience init(lineString: LineString) {
    var points = lineString.points.map({ CLLocationCoordinate2D($0)})
    self.init(coordinates: &points, count: UInt(points.count))
  }
}

extension MGLPolygon {
  convenience init(polygon: Polygon) {
    var exteriorRingCoordinates = polygon.exterior.points.map({ CLLocationCoordinate2D($0) })
    
    let interiorRings = polygon.holes.map { (linearRing: Polygon.LinearRing) -> MGLPolygon in
      var points = linearRing.points.map { CLLocationCoordinate2D($0) }
      return MGLPolygon(coordinates: &points, count: UInt(linearRing.points.count))
    }
    
    self.init(
      coordinates: &exteriorRingCoordinates,
      count: UInt(exteriorRingCoordinates.count),
      interiorPolygons: interiorRings)
  }
}

extension Geometry : GEOSwiftMapboxGL {
    public func mapboxShape() -> MGLShape {
        switch self {
            
        case let .point(self):
            let pointAnno = MGLPointAnnotation()
            pointAnno.coordinate = CLLocationCoordinate2D(self)
            return pointAnno
            
        case let .lineString(self):
            return MGLPolyline(lineString: self)

        case let .polygon(self):
            return MGLPolygon(polygon: self)

        case let .multiPolygon(self):
            let mglPolygons = self.polygons.map { MGLPolygon(polygon: $0)}
            return MGLMultiPolygon(polygons: mglPolygons)
                                     
        case let .geometryCollection(self):
          let shapes = self.geometries.map { $0.mapboxShape() }
          return MGLShapeCollection(shapes: shapes)
        case let .multiPoint(self):
          var coords = self.points.map { CLLocationCoordinate2D($0) }
          let multiPoint = MGLMultiPoint()
          multiPoint.setCoordinates(&coords, count: UInt(coords.count))
          return multiPoint
        case let .multiLineString(self):
          let mglLines = self.lineStrings.map { MGLPolyline(lineString: $0) }
          return MGLMultiPolyline(polylines: mglLines)
      }
  }
  
    public func mapboxFeature() -> MGLFeature {
      switch self {
        case let .point(self):
            let pointAnno = MGLPointFeature()
            pointAnno.coordinate = CLLocationCoordinate2D(self)
            return pointAnno
            
        case let .lineString(self):
            var points = self.points.map({ CLLocationCoordinate2D($0)})
            let polyline = MGLPolylineFeature(coordinates: &points, count: UInt(points.count))
            return polyline

        case let .polygon(self):
            var exteriorRingCoordinates = self.exterior.points.map({ CLLocationCoordinate2D($0) })
            
            let interiorRings = self.holes.map { (linearRing: Polygon.LinearRing) -> MGLPolygon in
              var points = linearRing.points.map { CLLocationCoordinate2D($0) }
              return MGLPolygon(coordinates: &points, count: UInt(linearRing.points.count))
            }
            
            let polygon = MGLPolygonFeature(
              coordinates: &exteriorRingCoordinates,
              count: UInt(exteriorRingCoordinates.count),
              interiorPolygons: interiorRings)
            return polygon
                                     
        case let .multiPolygon(self):
            let mglPolygons = self.polygons.map { MGLPolygon(polygon: $0)}
            return MGLMultiPolygonFeature(polygons: mglPolygons)
                                     
        case let .geometryCollection(self):
          let shapes = self.geometries.map { $0.mapboxShape() }
          return MGLShapeCollectionFeature(shapes: shapes)
        case let .multiPoint(self):
          var coords = self.points.map { CLLocationCoordinate2D($0) }
          return MGLMultiPointFeature(coordinates: &coords, count: UInt(coords.count))
        case let .multiLineString(self):
          let mglLines = self.lineStrings.map { MGLPolyline(lineString: $0) }
          return MGLMultiPolylineFeature(polylines: mglLines)
      }
  }
}
