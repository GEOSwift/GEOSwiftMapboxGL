![GEOSwiftMapboxGL](/README-images/GEOSwiftMapboxGL-header.png)  

[![Build Status](https://travis-ci.org/GEOSwift/GEOSwiftMapboxGL.svg?branch=develop)](https://travis-ci.org/GEOSwift/GEOSwiftMapboxGL.svg?branch=develop)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/GEOSwiftMapboxGL.svg)](https://img.shields.io/cocoapods/v/GEOSwiftMapboxGL.svg)

GEOSwiftMapboxGL makes it easy generate annotations to display on [MapboxGL](https://github.com/mapbox/mapbox-gl-native/).
On each Geometry instance you can call one of the related convenience func `mapboxShape()`, that will return an annotation object ready to be added as annotations to a `MGLMapView`:

## Features

* A pure-Swift, type-safe, optional-aware programming interface
* Automatically-typed geometry deserialization from WKT and WKB representations
* *MapboxGL* integration
* *Quicklook* integration
* A lightweight *GEOJSON* parser
* Extensively tested

## Requirements

* iOS 8.0+ / Mac OS X 10.10+
* Xcode 8
* Swift 3
* CocoaPods 1.2.1+

## Usage

### Geometry creation

```swift

import GEOSwift
import Mapbox
import GEOSwiftMapboxGL

...

let point = Waypoint(WKT: "POINT(10 45)")!
let polygon = Geometry.create("POLYGON((35 10, 45 45.5, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")!

let annotations = [
    point.mapboxShape(),
    polygon.mapboxShape()
]
self.mapView.showAnnotations(annotations, animated: true)

...

```

### GEOSwift and MapboxGL integration

Example:

```swift
let point = Waypoint(WKT: "POINT(10 45)")
let shape1 = point.mapboxShape() // will return a MGLPointAnnotation

let polygon = Geometry.create("POLYGON((35 10, 45 45.5, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")
let shape2 = polygon.mapboxShape() // Will return a MGLPolygon
```

In this table you can find which annotation class you should expect when calling `mapboxShape()` on a geometry:

| WKT Feature | GEOSwift class | MapboxGL |
|:------------------:|:-------------:|:-----------------:|:-----------------:|
| `POINT` | `WayPoint` | `MGLPointAnnotation` |
| `LINESTRING` | `LineString` | `MGLPolyline` |
| `POLYGON` | `Polygon` | `MGLPolygon` |
| `MULTIPOINT` | `MultiPoint` | `not supported` |
| `MULTILINESTRING` | `MultiLineString` | `not supported` |
| `MULTIPOLYGON` | `MultiPolygon` | `not supported` |
| `GEOMETRYCOLLECTION` | `GeometryCollection` | `MGLShapesCollection` |



### Playground

**TODO**

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks.**
> GEOS is a configure/install project licensed under LGPL 2.1: it is difficult to build for iOS and its compatibility with static linking is at least controversial. Use of GEOSwiftMapboxGL without CocoaPods and with a project targeting iOS 7, even if possible, is advised against.

### CocoaPods

CocoaPods is a dependency manager for Cocoa projects. To install GEOSwiftMapboxGL with CocoaPods:

* Make sure CocoaPods is installed (GEOSwiftMapboxGL requires version 1.2.1 or greater).

* Update your `Podfile` to include the following:

```
use_frameworks!
pod 'GEOSwiftMapboxGL'
```

* Run `pod install`.

NOTE: running `pod install` may cause some errors if your machine does not have autoconf, automake and glibtool, if you encounter those errors you can run `brew install autoconf automake libtool` to install those packages and run again `pod install`.

## Creator

Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi))

## License

* GEOSwiftMapboxGL was released by Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi)) under a MIT license. See LICENSE for more information.
* GEOSwift was released by Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi)) under a MIT license. See LICENSE for more information.
* [GEOS](http://trac.osgeo.org/geos/) stands for Geometry Engine - Open Source, and is a C++ library, ported from the [Java Topology Suite](http://sourceforge.net/projects/jts-topo-suite/). GEOS implements the OpenGIS [Simple Features for SQL](http://www.opengeospatial.org/standards/sfs) spatial predicate functions and spatial operators. GEOS, now an OSGeo project, was initially developed and maintained by [Refractions Research](http://www.refractions.net/) of Victoria, Canada.
