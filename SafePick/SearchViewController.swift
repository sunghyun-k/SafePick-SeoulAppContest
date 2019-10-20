//
//  SearchViewController.swift
//  SafePick
//
//  Created by 김성현 on 28/08/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import UIKit
import MapKit

/// 검색 화면의 뷰컨트롤러입니다.
class SearchViewController: UITableViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let cellIdentifier = "ResultTableViewCell"
    
    var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var userTrackingButton: UserTrackingButton!
    
    let courierManager = CourierManager.shared
    var searchResult = [Courier]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Setup
    
    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "시설명, 주소로 검색"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    
    func setupMapView() {
        self.mapView = MKMapView(frame: view.frame)
        setupMapViewApearance()
        setupMapRegion()
        mapView.delegate = self
        
        setupUserTrackingButton()
        setupAnnotations()
        
        mapView.register(CourierAnnotationView.self, forAnnotationViewWithReuseIdentifier: CourierAnnotationView.ReuseID)
        
        setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupAnnotations() {
        mapView.addAnnotations(courierManager.allCouriers)
    }
    
    /// 사용자 추적 버튼을 설정합니다. mapView가 생성된 뒤에 호출되어야 합니다.
    private func setupUserTrackingButton() {
        userTrackingButton = UserTrackingButton(type: .custom)
        
        // 오토레이아웃 제약 조건 추가
        mapView.addSubview(userTrackingButton)
        let safeArea = view.safeAreaLayoutGuide
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        userTrackingButton.heightAnchor.constraint(equalTo: userTrackingButton.widthAnchor).isActive = true
        userTrackingButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        userTrackingButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        userTrackingButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        
        userTrackingButton.addTarget(self, action: #selector(toggleUserTracking(sender:)), for: .touchUpInside)
    }
    
    private func setupMapViewApearance() {
        mapView.showsCompass = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        
        view.addSubview(mapView)
        
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupMapRegion() {
        
        let centerOfSeoul = CLLocationCoordinate2D(latitude: 37.5296594, longitude: 126.9838601)
        let scale: Double = 80000
        let region = MKCoordinateRegion(center: centerOfSeoul, latitudinalMeters: scale, longitudinalMeters: scale)
        mapView.setRegion(region, animated: false)
    }
    
    //MARK: 액션
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // 목록
            hideMap()
        case 1: // 지도
            showMap()
        default:
            break
        }
    }
    
    
    //MARK: 비공개 메소드
    
    private func showMap(animated: Bool = false) {
        tableView.isScrollEnabled = false
        if let mapView = mapView {
            if animated {
                UIView.animate(withDuration: 0.2) {
                    mapView.alpha = 1
                    self.tableView.contentInsetAdjustmentBehavior = .never
                }
            } else {
                mapView.alpha = 1
                self.tableView.contentInsetAdjustmentBehavior = .never
            }
        } else {
            setupMapView()
        }
        
    }
    
    private func hideMap(animated: Bool = false) {
        tableView.isScrollEnabled = true
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.mapView?.alpha = 0
                self.tableView.contentInsetAdjustmentBehavior = .automatic
            }
        } else {
            mapView?.alpha = 0
            self.tableView.contentInsetAdjustmentBehavior = .automatic
        }
        
    }
    
    private func reloadUserTrackingButton() {
        userTrackingButton.isSelected = mapView.userTrackingMode == .follow
    }
    
    //MARK: - 네비게이션
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let courierDetailViewController = segue.destination as? CourierViewController else {
            fatalError("예상치 못한 목적지: \(segue.destination)")
        }
        
        guard let selectedCourierCell = sender as? UITableViewCell else {
            fatalError("예상치 못한 sender: \(sender)")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCourierCell) else {
            fatalError("선택된 셀은 테이블에 의해 표시되고 있지 않습니다.")
        }
        
        // 검색 여부에 따라 전달할 courier를 바꿉니다.
        let courier: Courier
        if isSearching {
            courier = searchResult[indexPath.row]
        } else {
            courier = courierManager.recentItems[indexPath.row]
        }
        
        courierManager.addToRecentItems(courier)
        
        courierDetailViewController.courier = courier
    }
    
    //MARK: - 액션
    
    @objc func toggleUserTracking(sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            mapView.userTrackingMode = .none
        }
    }
}

//MARK: - 검색

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(for: searchController.searchBar.text!)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        hideMap(animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if segmentControl.selectedSegmentIndex == 1 {
            // 취소 버튼을 누르기 전 지도 화면인 경우
            showMap(animated: true)
        }
    }
}

extension SearchViewController {
    var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContent(for searchText: String) {
        searchResult = courierManager.filteredCouriers(for: searchText)
        tableView.reloadData()
    }
    
    var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
}

//MARK: - 테이블 뷰

//MARK: 테이블 뷰 데이터 소스

extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResult.count
        }
        return courierManager.recentItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let courier: Courier
        
        if isSearching {
            courier = searchResult[indexPath.row]
            
        } else {
            courier = courierManager.recentItems[indexPath.row]
        }
        
        cell.textLabel?.text = courier.name
        cell.detailTextLabel?.text = courier.address
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isSearching {
            return "최근 항목"
        }
        return nil
    }
}

//MARK: - Map View

extension SearchViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Courier else { return nil }
        return CourierAnnotationView(annotation: annotation, reuseIdentifier: CourierAnnotationView.ReuseID)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let courierVC = storyboard.instantiateViewController(withIdentifier: "CourierViewController") as! CourierViewController
        let courier = view.annotation as! Courier
        
        // 액세사리컨트롤로 접근한 경우 최근 항목으로 추가합니다.
        courierManager.addToRecentItems(courier)
        
        courierVC.courier = courier
        navigationController?.show(courierVC, sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view is CourierAnnotationView { return }
        
        mapView.deselectAnnotation(view.annotation!, animated: true)
        var zoomedRegion = mapView.region
        let zoomLevel: Double = 5
        zoomedRegion.span.latitudeDelta /= zoomLevel
        zoomedRegion.span.longitudeDelta /= zoomLevel
        zoomedRegion.center = view.annotation!.coordinate
        
        mapView.setRegion(zoomedRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        // 사용자가 지도를 움직여 추적이 해제된 경우 버튼의 상태를 업데이트합니다.
        if mode == .none {
            reloadUserTrackingButton()
        }
    }
}
