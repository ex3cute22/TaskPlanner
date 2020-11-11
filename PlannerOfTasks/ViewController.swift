//
//  ViewController.swift
//  PlannerOfTasks
//
//  Created by Илья Викторов on 21.10.2020.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var bar: UITabBarItem!
    
    let search = UISearchController(searchResultsController: nil) //поиск по названию
    
    let idCell = "idCell" //id кастомной ячейки
    
//Массив задач
    var models: [Task]{
        get{ //Загрузка массива задач из локального хранилища
            if let data = UserDefaults.standard.value(forKey: "TaskDataKey") as? Data{
                return try! PropertyListDecoder().decode([Task].self, from: data)
            }else{
                return [Task]()
            }
        }
        set{ //Сохранение массива задач в локальное хранилище
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.set(data, forKey: "TaskDataKey")
            }
        }
    }
    var change = [Task]()
    private var filteredModels = [Task]() //Массив отфильтрованный по поиску
//    private var categoryModels = [Task]() //Массив по выбранным категориям
    private var categoryNames: [String] = []
    private var CategoryUnical: [String] = []
    private var searchBarIsEmpty: Bool{
        guard let text = search.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return search.isActive && !searchBarIsEmpty
    }
    var refreshControl = UIRefreshControl() //Обновление таблицы
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserDefaults.standard.removeObject(forKey: "TaskDataKey")
//        UserDefaults.standard.synchronize()
        table.delegate = self
        table.dataSource = self
        models.forEach {
            if $0.date < Date(){
                $0.status = "Просрочено"
            }
            change.append($0)
            print($0.status)
        }
        models = change
        change.removeAll()
        print(change)
        models.forEach {
            categoryNames.append($0.category)
        }
         CategoryUnical = Array(Set(categoryNames))
        print(CategoryUnical)
        models.sort(by: {$0.date < $1.date}) //сортировка по дате
        models.sort(by: {$0.status == "В процессе" && $1.status != "В процессе"}) //сортировка по статусу
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Поиск"
        self.navigationItem.searchController = search
        definesPresentationContext = true
        refreshControl.tintColor = .systemBlue
        refreshControl.addTarget(self, action: #selector(updateTable), for: .allEvents)
        table.refreshControl = refreshControl
    }

//Обновление таблицы
    @objc func updateTable(){
        models.forEach {
            if $0.date < Date(){
                $0.status = "Просрочено"
            }
            change.append($0)
            print($0.status)
        }
        models = change
        change.removeAll()
        categoryNames.removeAll()
        models.forEach {
            categoryNames.append($0.category)
        }
         CategoryUnical = Array(Set(categoryNames))
        models.sort(by: {$0.date < $1.date}) //сортировка по дате
        models.sort(by: {$0.status == "В процессе" && $1.status != "В процессе"}) //сортировка по статусу
        table.reloadData()
        refreshControl.endRefreshing()
    }
    
//Добавление новой задачи
    @IBAction func tapAdd(){

        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else{
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { name, category, target, tools, author, date, status in
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                    let newTask = Task(name: name, category: category, target: target, tools: tools, author: author, date: date, status: status, identifier: "ID_\(name)\(date))")
                    self.models.insert(newTask, at: 0)
                    self.table.reloadData()
                    let content = UNMutableNotificationContent()
                    content.title = name
                    content.sound = .default
                    content.body = target

                    let targetDate = date
                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                    let request = UNNotificationRequest(identifier: "ID_\(name)\(date))", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                        if error != nil{

                        }
                    })
                }
            }
        navigationController?.pushViewController(vc, animated: true)
    }
//Категории
    @IBAction func tapCategory(){
        guard let vc = storyboard?.instantiateViewController(identifier: "category") as? CategoryViewController else{
            return
        }
        vc.title = "Категории"
        vc.arrCategory = CategoryUnical
        vc.arrTask = models
        navigationController?.pushViewController(vc, animated: true)
    }
//Проверка уведомления
    @IBAction func tapCheck(){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                self.schedule()
            }
            else if error != nil{
                
            }
        })

}

    func schedule(){
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.sound = .default
        content.body = "HELLOOOOOOOOOOOOOOOOO"
        
        let targetDate = Date().addingTimeInterval(5)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "ID_", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil{
                
            }
        })
    }
    
}

extension ViewController: UITableViewDelegate{

//Нажатие на cell (Открытие режима отслеживания статуса задачи)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(identifier: "edit") as? EditViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {name, category, target, tools, author, date, status in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let EditTask = Task(name: name, category: category, target: target, tools: tools, author: author, date: date, status: status, identifier: "ID_\(name)\(date)")
                self.models[indexPath.row] = EditTask
                self.table.reloadData()
            }
        }
//        if models[indexPath.row].date < Date(){
//            models[indexPath.row].status = "Просрочено"
//        }
        vc.name = models[indexPath.row].name
        vc.category = models[indexPath.row].category
        vc.target = models[indexPath.row].target
        vc.tools = models[indexPath.row].tools
        vc.author = models[indexPath.row].author
        vc.date = models[indexPath.row].date
        vc.status = models[indexPath.row].status
        print(models[indexPath.row].status)
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//Кол-во ячеек в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredModels.count
        }
        return models.count
    }
        
//Заполнение таблицы cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
       
        if !change.isEmpty{
            models = change
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! TaskTableViewCell
        var cellTask: Task
        
//        if isFiltering{
//            cellTask = filteredModels[indexPath.row]
//        }
//        else{
//            cellTask = models[indexPath.row]
//        }
        cellTask = models[indexPath.row]
        let date = models[indexPath.row].date
        if date < Date(){
            models[indexPath.row].status = "Просрочено"
        }
        cell.targetLabel?.text = cellTask.target
//        let status = models[indexPath.row].status
//        print(status)
        if models[indexPath.row].status == "Просрочено"{
            cell.statusView?.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        else if models[indexPath.row].status == "Выполнено"{
            cell.statusView?.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else if models[indexPath.row].status == "В процессе"{
            cell.statusView?.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        cell.titleLabel?.text =  cellTask.name
        let format = DateFormatter()
        format.locale = Locale(identifier: "ru_RU")
        format.dateFormat = "dd MMMM YYYY"
        cell.subTitleLabel?.text = format.string(from: date)
        
        return cell
    }
    
//Свайп слева (Выполнить задачу)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var status = self.models[indexPath.row].status
        if status != "Просрочено"{
                let swipeDone = UIContextualAction(style: .normal, title: "Выполнить"){(action, view, success) in
                
                var alert = UIAlertController()
                
                print(status)
                if status == "В процессе"{
                    status = "Выполнено"
                    alert = UIAlertController(title: "Внимание", message: "Вы уверены, что хотите выполнить задачу?", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Выполнить", style: .default) { (action) in
                        print(status)
                        self.change = self.models
                        self.change[indexPath.row].status = status
                        print(self.change[indexPath.row].status)
                        self.table.reloadData()
                    })
                }else if status == "Выполнено"{
                    status = "В процессе"
                    alert = UIAlertController(title: "Внимание", message: "Вы уверены, что хотите продолжить выполнение задачи?", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Продолжить", style: .default) { (action) in
                        print(status)
                        self.change = self.models
                        self.change[indexPath.row].status = status
                        print(self.change[indexPath.row].status)
                        self.table.reloadData()
                    })
                }
                alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
        //swipeDone.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                
                if self.models[indexPath.row].status == "В процессе"{
                    swipeDone.backgroundColor = .systemGreen
                }
                swipeDone.image = #imageLiteral(resourceName: "logo")
                
            return UISwipeActionsConfiguration(actions: [swipeDone])}
        else {
            return nil
        }
        }

//Свайп справа (Удалить задачу)
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let swipeDelete = UIContextualAction(style: .destructive, title: "Удалить"){(action, view, success) in
                let alert = UIAlertController(title: "Внимание", message: "Вы уверены, что хотите удалить данную задачу?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { (action) in
                    self.models.remove(at: indexPath.row)
                    self.table.reloadData()
                })
                alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
            return UISwipeActionsConfiguration(actions: [swipeDelete])
        }
    
//Размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
 
//    override func viewDidAppear(_ animated: Bool) {
//            let navigationBar = self.navigationController?.navigationBar
//            navigationBar?.barTintColor = UIColor.systemBlue
//            navigationBar?.tintColor = UIColor.white
//    }

}

//Класс Task
class Task: Codable{ //NSObject, NSCoding,
    
    var name: String //название задачи
    var category: String //категория
    var target: String //цель
    var tools: String //инструменты(компоненты)
    var author: String //автор
    var date: Date //дата выполнения
    var status: String //статус выполнения
    var identifier: String //идентификатор задачи
     
    init(name: String, category: String, target: String, tools: String, author: String, date: Date, status: String, identifier: String){
        self.name = name
        self.category = category
        self.target = target
        self.tools = tools
        self.author = author
        self.date = date
        self.status = status
        self.identifier = identifier
    }

}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterForSearchText(_searchText: searchController.searchBar.text!)
    }
    
    func filterForSearchText(_searchText: String){
        filteredModels = models.filter({ (model: Task) -> Bool in
            return model.name.lowercased().contains(_searchText.lowercased())
        })
        table.reloadData()
    }
}








//    init(){
//        name = ""
//        category = ""
//        target = ""
//        tools = ""
//        author = ""
//        date = Date()
//        status = false
//        identifier = "ID_"
//    }

//    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "NameKey")
//        coder.encode(category, forKey: "CategoryKey")
//        coder.encode(target, forKey: "TargetKey")
//        coder.encode(tools, forKey: "ToolsKey")
//        coder.encode(author, forKey: "AuthorKey")
//        coder.encode(date, forKey: "DateKey")
//        coder.encode(status, forKey: "StatusKey" )
//        coder.encode(identifier, forKey: "IdentifierKey")
//    }
//
//    required init?(coder: NSCoder) {
//        name = coder.decodeObject(forKey: "NameKey") as? String ?? ""
//        category = coder.decodeObject(forKey: "CategoryKey") as? String ?? ""
//        target = coder.decodeObject(forKey: "TargetKey") as? String ?? ""
//        tools = coder.decodeObject(forKey: "ToolsKey") as? String ?? ""
//        author = coder.decodeObject(forKey: "AuthorKey") as? String ?? ""
//        date = coder.decodeObject(forKey: "DateKey") as? Date ?? Date()
//        status = coder.decodeObject(forKey: "StatusKey") as? Bool ?? false
//        identifier = coder.decodeObject(forKey: "IdentifierKey") as? String ?? ""
//    }
