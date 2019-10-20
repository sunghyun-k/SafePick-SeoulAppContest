//
//  CourierViewController.swift
//  SafePick
//
//  Created by 김성현 on 28/08/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import UIKit
import MapKit


/// 무인택배함 상세 정보 화면에 대한 뷰컨트롤러입니다.
class CourierViewController: UIViewController {
    
    //MARK: - 프로퍼티
    
    let cellIdentifier = "CourierInfoTableViewCell"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var favoriteButton: RoundedButton!
    
    private var infos = [(String, String, UIImage?)]()
    
    var courierManager = CourierManager.shared
    var courier: Courier!
    
    //MARK: 표시 도우미
    private var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = courier.name
        navigationItem.largeTitleDisplayMode = .never
        
        setupMapView()
        showMap()
        setupTableViewData()
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        mapView.delegate = self
        
        setupTableViewHeight()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return courier != nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addAnnotation(courier)
    }
    
    //MARK: - Setup
    
    func setupTableViewData() {
        infos = [
            ("주소", courier.address, #imageLiteral(resourceName: "docOnDocFill")),
            ("우편번호", courier.postalCode, nil),
            ("연락처", courier.phone, #imageLiteral(resourceName: "phoneFill")),
            ("이용 방법", courier.userGuide, nil),
            ("자세한 위치", courier.detailLocation, nil),
        ]
    }
    
    private func setupTableViewHeight() {
        // 동적 크기의 셀을 계산하기 위해 필요합니다.
        infoTableView.layoutIfNeeded()
        let tempHeight = infoTableView.contentSize.height
        constraint = infoTableView.heightAnchor.constraint(equalToConstant: tempHeight)
        constraint.isActive = true
    }
    
    //MARK: 맵 뷰 설정
    
    private func showMap() {
        UIView.animate(withDuration: 0.1) {
            self.mapView.alpha = 1
        }
    }
    
    private func setupMapView() {
        moveMap(to: courier)
        setupMapCamera()
        setupOpenInMap()
    }
    
    private func setupMapCamera() {
        mapView.camera.altitude = 800
        mapView.camera.pitch = 30
    }
    
    private func setupOpenInMap() {
        let roundView = UIView()
        
        let layer = roundView.layer
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        let label = UILabel()
        label.text = "지도에서 열기"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemGray
        roundView.addSubview(label)
        
        mapView.addSubview(roundView)
        roundView.translatesAutoresizingMaskIntoConstraints = false
        roundView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 8).isActive = true
        roundView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        roundView.heightAnchor.constraint(equalTo: label.heightAnchor, constant: 10).isActive = true
        roundView.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 25).isActive = true
        roundView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        roundView.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true
        
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        
        roundView.insertSubview(blurView, at: 0)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.heightAnchor.constraint(equalTo: roundView.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: roundView.widthAnchor).isActive = true
        blurView.centerYAnchor.constraint(equalTo: roundView.centerYAnchor).isActive = true
        blurView.centerXAnchor.constraint(equalTo: roundView.centerXAnchor).isActive = true
        
    }
    
    //MARK: 맵 콘텐츠 업데이트
    
    private func addAnnotation(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }
    
    private func moveMap(to annotation: MKAnnotation) {
        mapView.centerCoordinate = annotation.coordinate
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - 액션
    
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "지도 앱 선택", message: "연결할 지도 앱을 선택하세요.", preferredStyle: .actionSheet)
        
        for service in MapService.allCases {
            
            if service.canOpen {
                let action = UIAlertAction(title: service.name, style: .default) { _ in
                    service.open(name: self.courier.name, coordinate: self.courier.coordinate)
                }
                alert.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: RoundedButton) {
        
        if courier.isFavorite {
            courierManager.removeFromFavorites(courier)
        } else {
            courierManager.addToFavorites(courier)
        }
        reloadFavoriteView()
        updateFavoriteState()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        // 공유할 텍스트입니다.
        let nameAndAddress = """
        [SafePick]
        \(courier.name)
        \(courier.address)
        """
        
        let activityViewController = UIActivityViewController(activityItems: [nameAndAddress], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    //MARK: - 비공개 메소드
    
    private func reloadFavoriteView() {
        let navigationController = tabBarController?.viewControllers?.first as? UINavigationController
        let favoritesViewController = navigationController?.viewControllers.first as? FavoritesTableViewController
        favoritesViewController?.tableView.reloadData()
    }
    
    private func updateFavoriteState() {
        if courier.isFavorite {
            favoriteButton.setTitle("즐겨찾기에서 제거", for: .normal)
            favoriteButton.setImage(UIImage(named: "starSlashFill"), for: .normal)
        } else {
            favoriteButton.setTitle("즐겨찾기에 추가", for: .normal)
            favoriteButton.setImage(UIImage(named: "starFill"), for: .normal)
        }
    }
    
}

extension CourierViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 주소가 눌렸을 때
            courier.copyAddress(viewController: self)
        case 2: // 전화번호가 눌렸을 때
            courier.promptCall()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - 테이블 뷰 데이터 소스

extension CourierViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 표시할 상세 정보의 개수입니다.
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 동적 높이의 셀로부터 Height를 가져올 수 없었기 때문에 마지막 셀의 Height로 Constraint를 설정합니다.
        if indexPath.row == infos.count - 1 {
            constraint.constant = cell.frame.maxY
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = infoTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CourierInfoTableViewCell else {
            fatalError("큐에서 제거된 셀이 CourierInfoTableViewCell의 인스턴스가 아닙니다.")
        }
        
        cell.updateContent(courier: infos[indexPath.row])
        
        // 주소와 전화번호만 선택 스타일이 있도록 합니다.
        switch indexPath.row {
        case 0, 2:
            cell.selectionStyle = .gray
        default:
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
}

extension CourierViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        view.animatesDrop = true
        return view
    }
}

//MARK: 주소 복사 / 전화 프롬프트

extension Courier {
    func copyAddress(viewController: UIViewController?) {
        UIPasteboard.general.string = address
        
        if let viewController = viewController {
            let alertController = UIAlertController(title: "\(name)의 주소가 복사됨", message: "주소 뒤에 '무인택배함'을 추가하세요.", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
            alertController.addAction(closeAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func promptCall() {
        let callURL = URL(string: "tel://\(phone)")!
        UIApplication.shared.open(callURL, options: [:], completionHandler: nil)
    }
}
