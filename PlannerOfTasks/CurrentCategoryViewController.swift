//
//  CurrentCategoryViewController.swift
//  TaskPlanner
//
//  Created by Илья Викторов on 06.11.2020.
//

import UIKit

class CurrentCategoryViewController: UIViewController {

    @IBOutlet var table: UITableView!
    
    var arrayTask = [Task]()
    var arrayTaskCategory = [Task]()
    var indexArr: [Int] = []
    var category = ""
    public var сompletion: (([Task]) -> Void)?
    weak var delegate: TaskDelegate?

    override func viewDidLoad() {
//        navigationItem.backBarButtonItem?.title = "Категории"
//        self.navigationController!.navigationBar.topItem!.title = "Категории"
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        indexArr.removeAll()
        arrayTaskCategory.removeAll()
        if !arrayTask.isEmpty{
            for i in 0...arrayTask.count-1{
            if arrayTask[i].category == category{
                arrayTaskCategory.append(arrayTask[i])
                indexArr.append(i)
            }
            }}
        print(indexArr)
//        arrayTask.forEach {
//            if $0.category == category{
//                arrayTaskCategory.append($0)
//                print($0.name)
//            }
//        }
        
    }
    

}
extension CurrentCategoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(identifier: "edit") as? EditViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {name, category, target, tools, author, date, status in
            DispatchQueue.main.async {
//                self.navigationController?.popViewController(animated: true)
                let EditTask = Task(name: name, category: category, target: target, tools: tools, author: author, date: date, status: status, identifier: "ID_\(name)\(date)")
                print(EditTask.name)
                self.arrayTask[self.indexArr[indexPath.section]] = EditTask
                self.arrayTaskCategory[indexPath.section] = EditTask
//                self.delegate?.updateTask(array: self.arrayTask)
                print(self.arrayTask[indexPath.section].name)
                self.table.reloadData()
                self.сompletion?(self.arrayTask)
            }
        }
        vc.name = arrayTaskCategory[indexPath.section].name
        vc.category = arrayTaskCategory[indexPath.section].category
        vc.target = arrayTaskCategory[indexPath.section].target
        vc.tools = arrayTaskCategory[indexPath.section].tools
        vc.author = arrayTaskCategory[indexPath.section].author
        vc.date = arrayTaskCategory[indexPath.section].date
        vc.status = arrayTaskCategory[indexPath.section].status
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension CurrentCategoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayTaskCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        
        let cellTask = arrayTaskCategory[indexPath.section]
        
        let date = cellTask.date
        if date < Date(){
            cellTask.status = "Просрочено"
        }
        cell.targetLabel?.text = cellTask.target
        let status = cellTask.status
        if  status == "Просрочено"{
            cell.statusView?.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        else if status == "Выполнено"{
            cell.statusView?.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else if status == "В процессе"{
            cell.statusView?.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        cell.titleLabel?.text =  cellTask.name
        let format = DateFormatter()
        format.locale = Locale(identifier: "ru_RU")
        format.dateFormat = "dd MMMM YYYY"
        cell.subTitleLabel?.text = format.string(from: date)
        return cell
    }
//Размер ячейки
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75.0
            
        }
}
