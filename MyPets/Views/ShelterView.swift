//
//  ShelterView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/28/25.
//

import SwiftUI
import MapKit

struct ShelterView: View {
    
    let shelters = [
        Shelter(name: "Atlantic County Animal Shelter",
                address: "240 Old Turnpike, Pleasantville, NJ 08232",
                coordinate: CLLocationCoordinate2D(latitude: 39.48660020115637, longitude: -74.52335849532422)),
        Shelter(name: "Angels Helping Animals",
                address: "326 New Albany Rd, Moorestown, NJ 08057",
                coordinate: CLLocationCoordinate2D(latitude: 40.04709930411648, longitude: -75.00322535095648)),
        Shelter(name: "Burlington County Animal Shelter",
                address: "35 Academy Dr, Westampton Township, NJ 08060",
                coordinate: CLLocationCoordinate2D(latitude: 40.08138355324201, longitude: -74.80148236531794)),
        Shelter(name: "All Fur One Pet Rescue & Adoptions",
                address: "1747 Hooper Ave Ste 11, Toms River, NJ 08753",
                coordinate: CLLocationCoordinate2D(latitude: 40.014613410908325, longitude: -74.1492221785487)),
        Shelter(name: "Jersey Shore Animal Center",
                address: "185 Brick Blvd, Brick Township, NJ 08723",
                coordinate: CLLocationCoordinate2D(latitude: 40.055564057935676, longitude: -74.12590830456152)),
        Shelter(name: "Ocean County Animal Facility",
                address: "615 Freemont Ave, Jackson Township, NJ 08527",
                coordinate: CLLocationCoordinate2D(latitude: 40.07130775825704, longitude: -74.27950559201622)),
        Shelter(name: "EASEL Animal Rescue League, Shelter, & Pet Adoption",
                address: "4 Jake Garzio Dr, Ewing Township, NJ 08628",
                coordinate: CLLocationCoordinate2D(latitude: 40.318729270612586, longitude: -74.80813510407962)),

        Shelter(name: "New Beginnings Animal Rescue",
                address: "742 NJ-18, East Brunswick, NJ 08816",
                coordinate: CLLocationCoordinate2D(latitude: 40.45432208428355, longitude: -74.38440762558348)),

        Shelter(name: "Franklin Township Animal Shelter",
                address: "475 Demott Ln, Somerset, NJ 08873",
                coordinate: CLLocationCoordinate2D(latitude: 40.53059215840679, longitude: -74.52230710083371)),

        Shelter(name: "Castle Of Dreams Animal Rescue",
                address: "434 Cliffwood Ave W, Cliffwood, NJ 07721",
                coordinate: CLLocationCoordinate2D(latitude: 40.48293352088389, longitude: -74.21642099209684)),

        Shelter(name: "Sammys Hope Animal Welfare & Adoption Center",
                address: "989 Main St, Sayreville, NJ 08872",
                coordinate: CLLocationCoordinate2D(latitude: 40.51343895030471, longitude: -74.30417520361972)),

        Shelter(name: "Edison Municipal Animal Shelter",
                address: "125 Municipal Blvd, Edison, NJ 08817",
                coordinate: CLLocationCoordinate2D(latitude: 40.570599239250306, longitude: -74.39945120470169)),

        Shelter(name: "Secaucus Animal Shelter",
                address: "525 Meadowlands Pkwy, Secaucus, NJ 07094",
                coordinate: CLLocationCoordinate2D(latitude: 40.80411035340008, longitude: -74.0747749914726)),

        Shelter(name: "Bergen County Animal Shelter & Adoption Center",
                address: "100 United Ln, Teterboro, NJ 07608",
                coordinate: CLLocationCoordinate2D(latitude: 40.90385878889874, longitude: -74.08466571365771)),

        Shelter(name: "Pawsitively Furever Dog Rescue",
                address: "40 Burlews Ct Building 4, Hackensack, NJ 07601",
                coordinate: CLLocationCoordinate2D(latitude: 40.96612528258975, longitude: -74.02532138054691)),

        Shelter(name: "Bloomfield Animal Shelter",
                address: "61 Bukowski Pl, Bloomfield, NJ 07003",
                coordinate: CLLocationCoordinate2D(latitude: 40.83654506749166, longitude: -74.18357293550905)),

        Shelter(name: "Montclair Township Animal Shelter",
                address: "77 N Willow St, Montclair, NJ 07042",
                coordinate: CLLocationCoordinate2D(latitude: 40.861484054357, longitude: -74.22643273164462)),

        Shelter(name: "Mt Pleasant Animal Shelter",
                address: "194 NJ-10, East Hanover, NJ 07936",
                coordinate: CLLocationCoordinate2D(latitude: 40.83654506749166, longitude: -74.38138737921172)),

        Shelter(name: "The North Jersey Community Animal Shelter",
                address: "23 Brandt Ln, Bloomingdale, NJ 07403",
                coordinate: CLLocationCoordinate2D(latitude: 41.06065792922799, longitude: -74.3121523239158)),

        Shelter(name: "NorthStar Pet Rescue",
                address: "187 Plane St, Boonton, NJ 07005",
                coordinate: CLLocationCoordinate2D(latitude: 40.943716105889074, longitude: -74.42754408274233))
    ]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.48660020115637, longitude: -74.523358495324224), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    @State private var selectedShelter: Shelter? = nil
    
    var body: some View {
        ZStack {
            // Map with fixed-position annotations
            Map(coordinateRegion: $region, annotationItems: shelters) { shelter in
                MapAnnotation(coordinate: shelter.coordinate) {
                    // Just the marker - no info window here
                    Image(systemName: "pawprint.circle.fill")
                        .font(.title)
                        .foregroundColor(selectedShelter?.id == shelter.id ? .blue : .red)
                        .background(Circle().fill(.white))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedShelter = (selectedShelter?.id == shelter.id) ? nil : shelter
                            }
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                adjustMapToShowAllShelters()
            }
            
            // Info windows rendered separately
            ForEach(shelters) { shelter in
                if selectedShelter?.id == shelter.id {
                    ShelterInfoWindow(
                        shelter: shelter,
                        position: convertCoordinateToPoint(shelter.coordinate)
                    ) {
                        withAnimation {
                            selectedShelter = nil
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }

    private func convertCoordinateToPoint(_ coordinate: CLLocationCoordinate2D) -> CGPoint {
        // This is a simplified version - you might need MapProxy for precise conversion
        // For now, we'll approximate based on region
        let x = CGFloat((coordinate.longitude - region.center.longitude) / region.span.longitudeDelta * 200 + 200)
        let y = CGFloat((region.center.latitude - coordinate.latitude) / region.span.latitudeDelta * 200 + 200)
        return CGPoint(x: x, y: y)
    }
    
    private func adjustMapToShowAllShelters() {
            guard !shelters.isEmpty else { return }
            
            var minLat = shelters[0].coordinate.latitude
            var maxLat = shelters[0].coordinate.latitude
            var minLon = shelters[0].coordinate.longitude
            var maxLon = shelters[0].coordinate.longitude
            
            for shelter in shelters {
                minLat = min(minLat, shelter.coordinate.latitude)
                maxLat = max(maxLat, shelter.coordinate.latitude)
                minLon = min(minLon, shelter.coordinate.longitude)
                maxLon = max(maxLon, shelter.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLon + maxLon) / 2
            )
            
            // Add some padding around the edges
            let span = MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.5,
                longitudeDelta: (maxLon - minLon) * 1.5
            )
            
            withAnimation {
                region = MKCoordinateRegion(center: center, span: span)
            }
        }
}
struct ShelterInfoWindow: View {
    let shelter: Shelter
    let position: CGPoint
    let onClose: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(shelter.name)
                        .font(.headline.bold())
                    
                    Spacer()
                    
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                
                Text(shelter.address)
                    .font(.subheadline)
                
                Button("Directions") {
                    let placemark = MKPlacemark(coordinate: shelter.coordinate)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = shelter.name
                    mapItem.openInMaps()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .frame(width: 250)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 5)
            .position(x: position.x, y: position.y+50) // Position above marker
        }
    }
}

struct ShelterView_Previews: PreviewProvider {
    static var previews: some View {
        ShelterView()
    }
}
