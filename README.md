This project is no longer maintained. Please migrate to https://github.com/GEOSwift/GEOSwiftMapboxMaps

# GEOSwiftMapboxGL

[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/GEOSwiftMapboxGL)](https://cocoapods.org/pods/GEOSwiftMapboxGL)
[![Supported Platforms](https://img.shields.io/cocoapods/p/GEOSwiftMapboxGL)](https://github.com/GEOSwift/GEOSwiftMapboxGL)
[![Build Status](https://img.shields.io/travis/GEOSwift/GEOSwiftMapboxGL/main)](https://travis-ci.com/GEOSwift/GEOSwiftMapboxGL)

See [GEOSwift](https://github.com/GEOSwift/GEOSwift) for full details

## Requirements

* iOS 9.0+
* Swift 5.1+
* CocoaPods 1.4.0+
* MapboxGL 6

## Installation

### CocoaPods

1. Follow the Mapbox Maps SDK [installation
   instructions](https://docs.mapbox.com/ios/maps/guides/install/) to configure
   your `~/.netrc` file.
2. Update your `Podfile` to include:

        use_frameworks!
        pod 'GEOSwiftMapboxGL'

3. Run `$ pod install`

## Usage

```swift

import GEOSwift
import Mapbox
import GEOSwiftMapboxGL

...

let point = Point(longitude: 10, latitude: 45)
let polygon = try! Polygon(wkt: "POLYGON((35 10, 45 45.5, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")

let annotations = [
    MGLShape.make(with: point),
    MGLShape.make(with: polygon)
]
self.mapView.showAnnotations(annotations, animated: true)

...

```

In this table you can find which annotation class you should expect when using
`MGLShape.make(with:)`:

| GEOSwift | MapboxGL |
|:-------------:|:-----------------:|
| `Point` | `MGLPointAnnotation` |
| `LineString` | `MGLPolyline` |
| `Polygon` | `MGLPolygon` |
| `MultiPoint` | `MGLPointCollection` |
| `MultiLineString` | `MGLMultiPolyline` |
| `MultiPolygon` | `MGLMultiPolygon` |
| `GeometryCollection` | `MGLShapeCollection` |

You can also use `MGLShape.makeFeature(with:)`:

| GEOSwift | MapboxGL |
|:-------------:|:-----------------:|
| `Point` | `MGLPointFeature` |
| `LineString` | `MGLPolylineFeature` |
| `Polygon` | `MGLPolygonFeature` |
| `MultiPoint` | `MGLPointCollectionFeature` |
| `MultiLineString` | `MGLMultiPolylineFeature` |
| `MultiPolygon` | `MGLMultiPolygonFeature` |
| `GeometryCollection` | `MGLShapeCollectionFeature` |

Each of these MapboxGL types also receive convenience initializers that accept
the corresponding GEOSwift type.

## Contributing

To make a contribution:

* Fork the repo
* Start from the `main` branch and create a branch with a name that describes
  your contribution
* Follow the Mapbox Maps SDK [installation
  instructions](https://docs.mapbox.com/ios/maps/guides/install/) to configure
  your `~/.netrc` file.
* Run `$ pod install`
* Open GEOSwiftMapboxGL.xcworkspace and make your changes.
* Run `$ swiftlint` from the repo root and resolve any issues.
* Push your branch and create a pull request to `main`
* One of the maintainers will review your code and may request changes
* If your pull request is accepted, one of the maintainers should update the
  changelog before merging it.
* Due to the need for a secret Mapbox token to install the Mapbox SDK, CI will
  not run for PRs from forks. Maintainers should be sure to run the test suite
  locally before accepting any changes.

## Maintainer

* Andrew Hershberger ([@macdrevx](https://github.com/macdrevx))

## Past Maintainers

* Virgilio Favero Neto ([@vfn](https://github.com/vfn))
* Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi))
  (original author)

## License

* GEOSwiftMapboxGL was released by Andrea Cremaschi
  ([@andreacremaschi](https://twitter.com/andreacremaschi)) under a MIT license.
  See LICENSE for more information.
* GEOSwift was released by Andrea Cremaschi
  ([@andreacremaschi](https://twitter.com/andreacremaschi)) under a MIT license.
  See LICENSE for more information.
* [GEOS](http://trac.osgeo.org/geos/) stands for Geometry Engine - Open Source,
  and is a C++ library, ported from the
  [Java Topology Suite](http://sourceforge.net/projects/jts-topo-suite/). GEOS
  implements the OpenGIS
  [Simple Features for SQL](http://www.opengeospatial.org/standards/sfs) spatial
  predicate functions and spatial operators. GEOS, now an OSGeo project, was
  initially developed and maintained by
  [Refractions Research](http://www.refractions.net/) of Victoria, Canada.
