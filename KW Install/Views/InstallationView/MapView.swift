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
    var address: String
    
    var tapCallback: (UITapGestureRecognizer, CLLocationCoordinate2D) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:))))
        
        var schoolCoordinate = CLLocationCoordinate2D()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let placemarks = placemarks {
                let placemark = placemarks.first?.location
                schoolCoordinate = placemark?.coordinate ?? CLLocation().coordinate
                context.coordinator.schoolCoordinate = schoolCoordinate
            }
            self.centerToLocation(mapView: mapView, CLLocation(latitude: schoolCoordinate.latitude, longitude: schoolCoordinate.longitude))
        }
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {

    }
    
//    func getCoordinate() -> CLLocationCoordinate2D {
//        if let coord = self.coordinate {
//            return coord
//        } else {
//            return CLLocationCoordinate2D()
//        }
//    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, tapCallback: self.tapCallback)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var schoolCoordinate = CLLocationCoordinate2D()
        var tapCallback: (UITapGestureRecognizer, CLLocationCoordinate2D) -> Void

        init(_ parent: MapView, tapCallback: @escaping (UITapGestureRecognizer, CLLocationCoordinate2D) -> Void) {
            self.tapCallback = tapCallback
            self.parent = parent
        }
        
        @objc func handleTap(sender: UITapGestureRecognizer)
        {
            self.tapCallback(sender, self.schoolCoordinate)
        }
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            parent.centerco = mapView.centerCoordinate
//        }
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
        MapView(address: "600 s michigan ave", tapCallback: {(gesture, location) in })
    }
}
