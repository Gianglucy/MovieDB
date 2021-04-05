//
//  TestVC.swift
//  MovieDB
//
//  Created by Apple on 9/8/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class TestVC: UIViewController {
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
//        var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var marker = GMSMarker()
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    let mapView: GMSMapView = {
        let mapView = GMSMapView()
        var camera = GMSCameraPosition.camera(withLatitude: 10.7722785, longitude: 106.6948569, zoom: 1000)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        mapView.delegate = self
        let rightBarButton = UIBarButtonItem(title: "Get Place", style: .done, target: self, action: #selector(getPlaceNear))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        view.addSubview(mapView)
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: 10.7722785, longitude: 106.6948569)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    @objc func getPlaceNear() {
        let placeVC = PlaceVC(nibName: "PlaceVC", bundle: nil)
        navigationController?.pushViewController(placeVC, animated: true)
    }
}

extension TestVC: GMSMapViewDelegate {
//    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//        print(mapView.isMyLocationEnabled)
//        return true
//    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        self.marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
