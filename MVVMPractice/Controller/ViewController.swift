//
//  ViewController.swift
//  MVVMPractice
//
//  Created by Katherine Li on 1/10/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // #1 - The UITableViewDataSource and UITableViewDelegate protocols are adopted in extensions.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let destinationViewController = segue.destination as? DetailViewController {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let index = indexPath.row
                // #2 - The ViewModel is the app's default data source.
                // The ViewModel data for the currently-selected table
                // view cell representing a Messier object is passed to a detail view controller via a segue.
                destinationViewController.messierViewModel = messierViewModel[index]
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    // All's I'm doing in didSelectRowAt is de-selecting a table view row so it doesn't get stuck as highlighted when it is selected. Users can be confident as to which rows they selected. Otherwise, once a row is tapped, it stays highlighted.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messierViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableviewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            
            // #1 - The ViewModel is the app's default data source.
            tableviewCell.imageView?.image = UIImage(named: messierViewModel[indexPath.row].thumbnail)
            tableviewCell.textLabel?.text = messierViewModel[indexPath.row].formalName
            tableviewCell.detailTextLabel?.text = messierViewModel[indexPath.row].commonName
            
            return tableviewCell
        } else {
            return UITableViewCell()
        }
    }
}

