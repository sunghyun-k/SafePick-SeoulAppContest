//
//  CourierTableViewController.swift
//  SafePick
//
//  Created by 박준희 on 28/08/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import UIKit

/// 즐겨찾기 화면에 대한 테이블 뷰컨트롤러입니다.
class FavoritesTableViewController: UITableViewController {
    
    let cellIdentifier = "CourierTableViewCell"
    
    let courierManager = CourierManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courierManager.favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CourierTableViewCell else {
            fatalError("큐에서 제거된 셀이 CourierTableViewCell의 인스턴스가 아닙니다")
        }
        guard let courier = courierManager.favorites[indexPath.row] else {
            cell.updateContentForNil()
            return cell
        }
        cell.updateContent(courier: courier)
        
        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            courierManager.removeFromFavorites(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        courierManager.moveFavoriteItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    //MARK: 테이블 뷰 델리게이트
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let courier = courierManager.favorites[indexPath.row] else {
            return
        }
        courier.copyAddress(viewController: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let courierDetailViewController = segue.destination as? CourierViewController else {
            fatalError("예상치 못한 목적지: \(segue.destination)")
        }
        
        guard let selectedCourierCell = sender as? CourierTableViewCell else {
            fatalError("예상치 못한 sender: \(sender)")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCourierCell) else {
            fatalError("선택된 셀은 테이블에 의해 표시되고 있지 않습니다.")
        }
        
        let courier = courierManager.favorites[indexPath.row]
        
        courierDetailViewController.courier = courier
    }
    
}

//MARK: 데이터 업데이트

extension CourierManager {
    func updateDataWithAlert(source viewController: UIViewController?, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "사용을 위한 데이터 구성 중...", message: "이 작업은 1분 정도 걸릴 수 있습니다.", preferredStyle: .alert)
        
        viewController?.present(alert, animated: true, completion: nil)
        
        updateData { (success) in
            DispatchQueue.main.sync {
                alert.dismiss(animated: true, completion: nil)
            }
            completion?()
        }
    }
}
