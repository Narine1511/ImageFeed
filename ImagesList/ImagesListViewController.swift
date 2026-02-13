//
//  ViewController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 01.02.2026.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
 
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
        return UITableViewCell()
        }
        
        configCell(for: imageListCell)
        
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell) {}
}
extension ImagesListViewController: UITableViewDelegate {
    // метод отвечает за действия, которые будут выполены при тапе по ячейке таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt
                   indexPath: IndexPath) {}
}
