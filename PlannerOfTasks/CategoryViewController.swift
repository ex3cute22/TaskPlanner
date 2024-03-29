//
//  CategoryViewController.swift
//  TaskPlanner
//
//  Created by Илья Викторов on 05.11.2020.
//

import UIKit

protocol TaskDelegate: class{
    func updateTask(array: [Task])
}

class CategoryViewController: UIViewController{
    
    @IBOutlet var table: UITableView!
    var arrCategory: [String] = []
    var arrTask = [Task]()
    public var completion: (([Task]) -> Void)?
    weak var modelsDelegate: ModelsDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(arrCategory)
        arrCategory.sort(by: {$0 < $1})
        table.delegate = self
        table.dataSource = self
    }
}

extension CategoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(identifier: "currentCategory") as? CurrentCategoryViewController else{
            return
        }
        vc.сompletion = {arrayTask in
            DispatchQueue.main.async {
//                self.navigationController?.popViewController(animated: true)
                
                self.arrTask = arrayTask
                self.arrTask.forEach{
                    print($0)

                }
                print(self.arrTask)
//                vc.delegate = self
                
//                self.modelsDelegate?.update(array: self.arrTask)
                self.table.reloadData()
                self.completion?(self.arrTask)
            }
        }
        vc.delegate = self
        vc.title = arrCategory[indexPath.section]
        vc.navigationItem.backBarButtonItem?.title = "Категории"
        vc.category = arrCategory[indexPath.section]
        vc.arrayTask = arrTask
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory")!
        
        cell.textLabel?.text = arrCategory[indexPath.section]
        print(indexPath.section)
        print(arrCategory[indexPath.section])
        
        return cell
    }
    
}
extension CategoryViewController: TaskDelegate{
    func updateTask(array: [Task]) {
        arrTask = array
    }
}
