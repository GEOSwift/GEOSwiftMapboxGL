Pod::Spec.new do |s|
  s.name = 'GEOSwiftMapboxGL'
  s.version = '2.0.0'
  s.swift_version = '5.1'
  s.cocoapods_version = '>= 1.4.0'
  s.summary = 'MapKit support for GEOSwift'
  s.description  = <<~DESC
    Easily handle a geometric object model (points, linestrings, polygons etc.) and related
    topological operations (intersections, overlapping etc.). A type-safe, MIT-licensed Swift
    interface to the OSGeo's GEOS library routines, nicely integrated with MapboxGL.
  DESC
  s.homepage = 'https://github.com/GEOSwift/GEOSwiftMapboxGL'
  s.license = {
    type: 'MIT',
    file: 'LICENSE'
  }
  s.author = { 'GEOSwift team' => 'https://github.com/orgs/GEOSwift/people' }
  s.platforms = { ios: '9.0' }
  s.source = {
    git: 'https://github.com/GEOSwift/GEOSwiftMapboxGL.git',
    tag: s.version
  }
  s.source_files = 'GEOSwiftMapboxGL/*.{swift,h}'
  s.dependency 'GEOSwift', '~> 8.0'
  s.dependency 'Mapbox-iOS-SDK', '>= 4.0'
end
