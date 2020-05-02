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
      let pointer = linearRing.points.map { CLLocationCoordinate2D($0) }
      return MGLPolygon(coordinates: pointer, count: UInt(linearRing.points.count))
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
            var points = self.points.map({ CLLocationCoordinate2D($0)})
            let polyline = MGLPolyline(coordinates: &points, count: UInt(points.count))
            return polyline

        case let .polygon(self):
            var exteriorRingCoordinates = self.exterior.points.map({ CLLocationCoordinate2D($0) })
            
            let interiorRings = self.holes.map { (linearRing: Polygon.LinearRing) -> MGLPolygon in
              let pointer = linearRing.points.map { CLLocationCoordinate2D($0) }
              return MGLPolygon(coordinates: pointer, count: UInt(linearRing.points.count))
            }
            
            let polygon = MGLPolygon(
              coordinates: &exteriorRingCoordinates,
              count: UInt(exteriorRingCoordinates.count),
              interiorPolygons: interiorRings)
            return polygon
                                     
        case let .multiPolygon(self):
            let mglPolygons = self.polygons.map { MGLPolygon(polygon: $0)}
            return MGLMultiPolygon(polygons: mglPolygons)
                                     
        case let .geometryCollection(self):
           let geometryCollectionOverlay = MGLShapesCollection(geometryCollection: self)
           return geometryCollectionOverlay
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
}

/**
MGLShape subclass for GeometryCollections.
The property `shapes` contains MGLShape subclasses instances. When drawing shapes on a map be careful to the fact that that these shapes could be overlays OR annotations.
*/
public class MGLShapesCollection : MGLShape, MGLOverlay {
    let shapes: Array<MGLShape>
    public let centroid: CLLocationCoordinate2D
    public let overlayBounds: MGLCoordinateBounds
    
    // inserting the where clause in the following generic create some confusion in the precompiler that raise the following error:
    // Cannot invoke initializer for type ... with an argument list of type (geometryCollection: GeometryCollection<T>)
    // 1. Expected an argument list of type (geometryCollection: GeometryCollection<T>)
    required public init(geometryCollection: GeometryCollection) {
        self.shapes = geometryCollection.geometries.map { (geometry: Geometry) -> MGLShape in
            return geometry.mapboxShape()
        }
        let centerPoint = (try? geometryCollection.centroid()) ?? Point(x: 0, y: 0)
        let envelope = (try? geometryCollection.envelope()) ?? Envelope(minX: 0, maxX: 0, minY: 0, maxY: 0)

        self.centroid = CLLocationCoordinate2D(centerPoint)
        let sw = CLLocationCoordinate2D(envelope.minXMinY)
        let ne = CLLocationCoordinate2D(envelope.maxXMaxY)
        self.overlayBounds = MGLCoordinateBounds(sw:sw, ne:ne)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var coordinate: CLLocationCoordinate2D { get {
        return centroid
        }}
    
    // TODO: implement using "intersect" method (actually it seems that mapboxgl never calls it...)
    public func intersects(_ overlayBounds: MGLCoordinateBounds) -> Bool {
        return true
    }
}
