//
//  MapView.swift
//  KW Install
//
//  Created by Luke Morse on 4/3/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var centerCoordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        centerToLocation(mapView: mapView, CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude))
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
    }
    
    func centerToLocation(
      mapView: MKMapView,
      _ location: CLLocation,
      regionRadius: CLLocationDistance = 1000
    ) {
      let coordinateRegion = MKCoordinateRegion(
        center: location.coordinate,
        latitudinalMeters: regionRadius,
        longitudinalMeters: regionRadius)
      
      mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "Chicago"
//        annotation.subtitle = ""
        annotation.coordinate = CLLocationCoordinate2D(latitude: 41.856411, longitude: -87.670885)
        return annotation
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: CLLocationCoordinate2D(latitude: 41.881832, longitude: -87.623177))
    }
}
