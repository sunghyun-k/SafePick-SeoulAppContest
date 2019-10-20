//
//  CourierAnnotationView.swift
//  SafePick
//
//  Created by 김성현 on 04/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import MapKit

class CourierAnnotationView: MKMarkerAnnotationView {
    
    static let ReuseID = "courierAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "courier"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clusteringIdentifier = "courier"
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        markerTintColor = .orange
        glyphImage = #imageLiteral(resourceName: "box")
    }
}
