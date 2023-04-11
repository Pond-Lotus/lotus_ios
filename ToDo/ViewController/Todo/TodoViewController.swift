//
//  TodoViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/29.
//

import UIKit
import FSCalendar

class TodoViewController:UIViewController{
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarOuterView: UIView!
    
    @IBOutlet weak var calendarHeaderLabel: UILabel!
    var exampleDate:[Date] = []
    var isShowingButtonSheet = false
    var count = 0
    
    var categoryDictionary:[Character:String] = ["1":"","2":"","3":"","4":"","5":"","6":""]
    var titleOfSection:[String] = ["Red","Yellow","Green", "Blue","Pink","Purple"]
    var priorityArray:[Character] = ["1","2","3","4","5","6"]
    var existPriorityArray:[Character] = []
    var redArray:[TodoList] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var yellowArray:[TodoList] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var greenArray:[TodoList] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var blueArray:[TodoList] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var pinkArray:[TodoList] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var purpleArray:[TodoList] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    
    var yOfFloatingButton:CGFloat = 0
    var xOfFloatingButton:CGFloat = 0
    var keyboardHeight:CGFloat?
    var window = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var showColorPicker = false
    
    var bottomSheetController : BottomSheetViewController?
    var drawerController : DrawerViewController?
    var selectColorController:SelectColorViewController?
    
    var blackView : UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        print("create black view")
        return view
    }()
    
    let floatingButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        return button
    }()
    
    
    @IBOutlet weak var viewCalendarContainted: UIView!
    
    var todo:[TodoList] = []{
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarSetting()
        calendarOuterViewSetting()
        
        calendarView.select(calendarView.today)
        
        xOfFloatingButton = view.frame.width * 0.73
        yOfFloatingButton = view.frame.height * 0.7
        
        floatingButtonSetting() //위에 x,y구한 뒤에 실행되어야함
        
        calendarView.dataSource = self
        calendarView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFinishEditing(_:)), name: NSNotification.Name("finishEditing"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectColor(_:)), name: NSNotification.Name("selectColor"), object: nil)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "dd E요일"
        
        guard let today = calendarView.today else {return}
        var dateArray = dateFormatter.string(from: today).components(separatedBy: " ")
        
        dayLabel.text = dateArray[0]
        weekdayLabel.text = dateArray[1]
        
        dateFormatter.dateFormat = "YYYY M dd"
        dateArray = dateFormatter.string(from: today).components(separatedBy: " ")
        searchDayTodo(year: dateArray[0], month: dateArray[1], day: dateArray[2])
        
        dateFormatter.dateFormat = "yyyy.MM"
        calendarHeaderLabel.text = dateFormatter.string(from: calendarView.currentPage)
        
        //color dot test
        print("today: \(calendarView.today)")
        var day = 1
        var dateString = "\(dateArray[0])-0\(dateArray[1])-0\(String(day))"
        print("string date: \(dateString)")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let realDate = dateFormatter.date(from: dateString)
        exampleDate.append(realDate!)
        print("real date: \(realDate)")
        
        
        
        self.tableView.addSubview(floatingButton)
        
        //제스처 추가 - 두개라서 일단 하나 지우기
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        calendarView.appearance.eventDefaultColor = Color.red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPriority()
        sectionSetting()
    }
    
    private func calendarOuterViewSetting(){
        calendarOuterView.clipsToBounds = true
        calendarOuterView.layer.cornerRadius = 30
        calendarOuterView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        calendarOuterView.layer.masksToBounds = false
        calendarOuterView.layer.shadowColor = UIColor.lightGray.cgColor
        calendarOuterView.layer.shadowOpacity = 0.2
        calendarOuterView.layer.shadowRadius = 5
        calendarOuterView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private func getCategoryName(){
        TodoService.shared.getCategoryName { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? CategoryResponseData{
                    if data.resultCode == 200{
                        for i in self.priorityArray{
                            switch(i){
                            case "1":
                                let name = data.data._1
                                self.categoryDictionary["1"] = name
                            case "2":
                                let name = data.data._2
                                self.categoryDictionary["2"] = name
                            case "3":
                                let name = data.data._3
                                self.categoryDictionary["3"] = name
                            case "4":
                                let name = data.data._4
                                self.categoryDictionary["4"] = name
                            case "5":
                                let name = data.data._5
                                self.categoryDictionary["5"] = name
                            case "6":
                                let name = data.data._6
                                self.categoryDictionary["6"] = name
                            default: break
                            }
                        }
                    }
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            case .decodeErr:
                print("decodeErr")
            }
        }
    }
    
    private func sectionSetting(){
        self.titleOfSection.removeAll()
        self.existPriorityArray.removeAll()
        
        for i in priorityArray{
            switch (i){
            case "1" :
                if self.redArray.count != 0 {
                    self.titleOfSection.append(categoryDictionary[i]!)
                    self.existPriorityArray.append(i)
                }
            case "2" :
                if self.yellowArray.count != 0 {
                    self.titleOfSection.append(categoryDictionary[i]!)
                    self.existPriorityArray.append(i)
                }
            case "3" :
                if self.greenArray.count != 0 {
                    self.titleOfSection.append(categoryDictionary[i]!)
                    self.existPriorityArray.append(i)
                }
            case "4" :
                if self.blueArray.count != 0 {
                    self.titleOfSection.append(categoryDictionary[i]!)
                    self.existPriorityArray.append(i)
                }
            case "5" :
                if self.pinkArray.count != 0 {
                    self.titleOfSection.append(categoryDictionary[i]!)
                    self.existPriorityArray.append(i)
                }
            case "6" :
                if self.purpleArray.count != 0 {
                    self.titleOfSection.append(categoryDictionary[i]!)
                    self.existPriorityArray.append(i)
                }
            default:
                break
            }
        }
        self.tableView.reloadData()
    }
    
    private func getColorArray(year:String,month:String){
        
        TodoService.shared.getColorNumArray(year: year, month: month) { (response) in
            switch (response){
            case .success(let resultData): break
                //                guard let data = resultData else {return}
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            case .decodeErr:
                print("decodeErr")
                
            }
        }
        
    }
    
    private func getPriority(){
        TodoService.shared.getPriority { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? PriorityResponseData{
                    if data.resultCode == 200{
                        self.priorityArray = Array(String(data.data))
                    }
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            case .decodeErr:
                print("decodeErr")
            }
        }
    }
    
    //월간, 주간 스위치 segmented Control
    @IBAction func switchSegmentedControl(_ sender: Any) {
        if self.segmentedControl.selectedSegmentIndex == 0{
            self.calendarView.setScope(.month, animated: true)
        }else{
            self.calendarView.setScope(.week, animated: true)
        }
    }
    
    //컬러 선택 팔레트에서 색깔 선택
    @objc func selectColor(_ notification:Notification){
        if let color = notification.object as? Int{
            tapFloatingButton()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier:"ko_KR")
            dateFormatter.dateFormat = "yyyy MM dd"
            let todayDateArray = dateFormatter.string(from: calendarView.selectedDate!).components(separatedBy: " ")
            let year = todayDateArray[0]
            let month = todayDateArray[1]
            let day = todayDateArray[2]
            switch(color){
            case 1:
                redArray.append(TodoList(title: "", done: false, isNew: true, writer: "", color: 1, id: 0, description: "", year: year, month: month, day: day))
                break
            case 2:
                yellowArray.append(TodoList(title: "", done: false, isNew: true, writer: "", color: 2, id: 0, description: "", year: year, month: month, day: day))
                break
            case 3:
                greenArray.append(TodoList(title: "", done: false, isNew: true, writer: "", color: 3, id: 0, description: "", year: year, month: month, day: day))
                break
            case 4:
                blueArray.append(TodoList(title: "", done: false, isNew: true, writer: "", color: 4, id: 0, description: "", year: year, month: month, day: day))
                break
            case 5:
                pinkArray.append(TodoList(title: "", done: false, isNew: true, writer: "", color: 5, id: 0, description: "", year: year, month: month, day: day))
                break
            case 6:
                purpleArray.append(TodoList(title: "", done: false, isNew: true, writer: "", color: 6, id: 0, description: "", year: year, month: month, day: day))
                break
            default:
                break
            }
            sectionSetting()
        }
        
    }
    
    //bottom sheet 내에서 저장 버튼 눌렀을 때 실행 (notification center)
    @objc func handleFinishEditing(_ notification:Notification){
        self.blackView.removeFromSuperview()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "YYYY M dd"
        guard let selectedDate = calendarView.selectedDate else {return}
        let seletedDay = dateFormatter.string(from: selectedDate).components(separatedBy: " ")
        self.searchDayTodo(year: seletedDay[0], month: seletedDay[1], day: seletedDay[2])
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.bottomSheetController?.view.frame.origin.y = self.window.height
            self.bottomSheetController?.view.fs_height = 0
            
        }, completion: { finished in
            self.bottomSheetController?.view.removeFromSuperview()
        })
        
        
        view.endEditing(true)
    }
    
    //table view tap 할 때 실행되는 것
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            tableView.endEditing(true)
        }
        sender.cancelsTouchesInView = false //이거 뭔지 다시 확인해보기
    }
    
    
    //키보드 나타날 때 실행(notification center)
    @objc func keyboardWillShow(_ notification:NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if self.keyboardHeight == nil {
                self.keyboardHeight = keyboardHeight
                self.bottomSheetController?.view.frame.origin.y = (self.bottomSheetController?.view.frame.origin.y)! - keyboardHeight
            }
        }
    }
    
    //키보드 없어질 때 실행(notification center)
    @objc func keyboardWillHide(_ notification:NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
//            self.keyboardHeight = 0
        }
    }
    
    //drawer 햄버거바 클릭했을 때 실행
    @IBAction func tapDrawerButton(_ sender: Any) {
        drawerController = self.storyboard?.instantiateViewController(withIdentifier: "DrawerViewController") as? DrawerViewController
        
        guard let drawerView = drawerController?.view else {return}
        
        self.blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(self.blackView) //어두운 뷰 먼저 추가
        view.addSubview(drawerView)
        self.addChild(drawerController!) //추가 뷰컨 추가. 추가 안 하면 기능 동작 안 함
        
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return} // 윈도우가 뭔지 모르겟음. 근데 해당 코드는 deprecated된 걸 사용해서 수정해야함
        self.window = window.frame
        self.blackView.frame = window.frame
        
        drawerView.layer.fs_width = 0
        drawerView.layer.fs_height = window.fs_height
        drawerView.frame.origin.x = window.fs_width //오른쪽에 붙이기 위해서 x 수정
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
            drawerView.layer.fs_width = window.fs_width * 0.8
            drawerView.frame.origin.x = window.fs_width - (window.fs_width * 0.8)
        }
        
    }
    
    //bottom sheet, drawer 없어질 때 실행(black view 클릭 했을때), 사라지는 애니메이션
    @objc func handleDismiss(){
        print("delete black view")
        self.blackView.removeFromSuperview()
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.bottomSheetController?.view.frame.origin.y = self.window.height
            self.bottomSheetController?.view.fs_height = 0
            
            self.drawerController?.view.frame.origin.x = self.window.width
            self.drawerController?.view.fs_width = 0
            
        }, completion: { finished in
            self.bottomSheetController?.view.removeFromSuperview()
            self.drawerController?.view.removeFromSuperview()
        })
        
        
        view.endEditing(true)
        
    }
    
    //floating button 외형 셋팅
    private func floatingButtonSetting(){
        floatingButton.frame = CGRect(x: xOfFloatingButton, y: yOfFloatingButton, width: 76, height: 76)
        floatingButton.setImage(UIImage(named: "floatingButton"), for: .normal)
        floatingButton.layer.shadowColor = UIColor.lightGray.cgColor
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowRadius = 5.0
        floatingButton.layer.shadowOffset = CGSize(width: 1, height: 3)
        floatingButton.addTarget(self, action: #selector(tapFloatingButton), for: .touchUpInside)
    }
    
    //floating button 클릭하면 실행
    @objc func tapFloatingButton(){
        if !showColorPicker{
            selectColorController = self.storyboard?.instantiateViewController(withIdentifier: "SelectColorViewController") as! SelectColorViewController
            
            showColorPicker = !showColorPicker
            
            //뷰 크기, 그림자, 알파값 설정
            selectColorController?.view.layer.shadowColor = UIColor.lightGray.cgColor
            selectColorController?.view.layer.shadowOpacity = 0.4
            selectColorController?.view.layer.shadowRadius = 5.0
            selectColorController?.view.layer.shadowOffset = CGSize(width: -1, height: 3)
            selectColorController?.view.alpha = 0
//            selectColorController?.view.fs_width = 150
//            selectColorController?.view.fs_height = 100
            selectColorController?.view.layer.cornerRadius = 15
//            selectColorController?.view.frame.origin.x = floatingButton.frame.origin.x - floatingButton.fs_width + 150
//            selectColorController?.view.frame.origin.y = floatingButton.frame.origin.y

            
            self.view.addSubview((selectColorController?.view!)!)
            self.addChild(selectColorController!)
            
            self.selectColorController?.view.translatesAutoresizingMaskIntoConstraints = false
            self.selectColorController?.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.selectColorController?.view.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
            self.selectColorController?.view.bottomAnchor.constraint(equalTo: self.floatingButton.topAnchor, constant: 20).isActive = true
            self.selectColorController?.view.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor).isActive = true
            

            

            
            
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.selectColorController?.view.alpha = 1
                //                self.selectColorController?.view.frame = CGRect(x: self.floatingButton.frame.origin.x + self.floatingButton.fs_width - 150, y: self.floatingButton.frame.origin.y, width: 150, height: 100)
                self.selectColorController?.view.bottomAnchor.constraint(equalTo: self.floatingButton.topAnchor, constant: 0).isActive = true
                self.floatingButton.transform = CGAffineTransform(rotationAngle: .pi*0.25)
//                self.view.layoutIfNeeded()

            })
        }else{
            showColorPicker = !showColorPicker
            UIView.animate(withDuration: 0.5, delay: 0, animations:{
                self.selectColorController?.view.alpha = 0
                //                self.selectColorController?.view.frame.origin.y = self.floatingButton.frame.origin.y + (self.floatingButton.fs_height/4)
                self.selectColorController?.view.bottomAnchor.constraint(equalTo: self.floatingButton.topAnchor, constant: 20).isActive = true
                self.floatingButton.transform = CGAffineTransform(rotationAngle: .pi*0)
//                self.view.layoutIfNeeded()

            }, completion: { finished in
                self.selectColorController?.view.removeFromSuperview()
            })
            
        }
        
    }
    
    //tableview 클릭했을 때 실행(이게 왜 두개나?? 이것 때문에 문제되는건가) - 일단 지워봄
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        self.tableView?.endEditing(true)
//    }
    
    //캘린더 기본 정보 초기 셋팅
    private func calendarSetting(){
        self.calendarView.appearance.headerTitleAlignment = .left
        self.calendarView.appearance.headerDateFormat = "YYYY.MM"
        self.calendarView.firstWeekday = 1
        self.calendarView.locale = Locale(identifier: "ko_KR")
    }
    
    //segmented control 외형 셋팅
    private func segmentedControlSetting(){
        segmentedControl.layer.cornerRadius = 15
        segmentedControl.layer.masksToBounds = true
        segmentedControl.clipsToBounds = true
    }
    
    //투두 조회 기능
    private func searchDayTodo(year:String, month:String, day:String){
        TodoService.shared.searchTodo(year: year, month: month, day: day) { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? TodoSearchResponseData{
                    print("in search func")
                    var todoData = data.data
                    self.redArray.removeAll()
                    self.yellowArray.removeAll()
                    self.greenArray.removeAll()
                    self.blueArray.removeAll()
                    self.pinkArray.removeAll()
                    self.purpleArray.removeAll()
                   
                    
                    for i in todoData{
                        print(i)
                        switch (i.color){
                        case 1:
                            self.redArray.append(TodoList(title: i.title, done: i.done, isNew: false, writer: i.writer, color: i.color, id: i.id, description: i.description, year: String(i.year), month: String(i.month), day: String(i.day)))
                        case 2:
                            self.yellowArray.append(TodoList(title: i.title, done: i.done, isNew: false, writer: i.writer, color: i.color, id: i.id, description: i.description, year: String(i.year), month: String(i.month), day: String(i.day)))
                        case 3:
                            self.greenArray.append(TodoList(title: i.title, done: i.done, isNew: false, writer: i.writer, color: i.color, id: i.id, description: i.description, year: String(i.year), month: String(i.month), day: String(i.day)))
                        case 4:
                            self.blueArray.append(TodoList(title: i.title, done: i.done, isNew: false, writer: i.writer, color: i.color, id: i.id, description: i.description, year: String(i.year), month: String(i.month), day: String(i.day)))
                        case 5:
                            self.pinkArray.append(TodoList(title: i.title, done: i.done, isNew: false, writer: i.writer, color: i.color, id: i.id, description: i.description, year: String(i.year), month: String(i.month), day: String(i.day)))
                        case 6:
                            self.purpleArray.append(TodoList(title: i.title, done: i.done, isNew: false, writer: i.writer, color: i.color, id: i.id, description: i.description, year: String(i.year), month: String(i.month), day: String(i.day)))
                        default:
                            break
                        }
                    }
                    self.getCategoryName()
                    self.sectionSetting()
                    
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            case .decodeErr:
                print("decodeErr")
            }
        }
    }
    
    
}

extension TodoViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        floatingButton.frame = CGRect(x: xOfFloatingButton, y: yOfFloatingButton + offset, width: 76, height: 76) // 컬러픽커를 띄운 상태에서 스크롤을 하면 floating button이 사라짐
        selectColorController?.view.frame = CGRect(x: floatingButton.frame.origin.x + floatingButton.fs_width - 150, y: yOfFloatingButton + offset, width: 150, height: 100)
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleOfSection[section]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bottomSheetController = self.storyboard?.instantiateViewController(withIdentifier: "bottomSheetViewController") as? BottomSheetViewController
        guard let bottomView = bottomSheetController?.view else {return}
        var todo:[TodoList] = []
        switch (existPriorityArray[indexPath.section]){
        case "1": todo = redArray
        case "2": todo = yellowArray
        case "3": todo = greenArray
        case "4": todo = blueArray
        case "5": todo = pinkArray
        case "6": todo = purpleArray
        default: break
        }
        
        bottomSheetController?.todoTextField.text = todo[indexPath.row].title
        bottomSheetController?.descriptionTextView.text = todo[indexPath.row].description
        bottomSheetController?.color = todo[indexPath.row].color
        bottomSheetController?.id = todo[indexPath.row].id
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "M월 dd일 E요일"
        guard let selectedDate = calendarView.selectedDate else {return}
        bottomSheetController?.dateLabel.text = dateFormatter.string(from: selectedDate)
        
        self.blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        view.addSubview(self.blackView)
        view.addSubview(bottomView)
        self.addChild(bottomSheetController!)
        isShowingButtonSheet = true
        
        
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return} // 윈도우가 뭔지 모르겟음. 근데 해당 코드는 deprecated된 걸 사용해서 수정해야함
        self.window = window.frame
        self.blackView.frame = window.frame
        
        
        bottomView.layer.cornerRadius = 20
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        bottomView.fs_width = window.fs_width
        bottomView.fs_height = 0
        bottomView.frame.origin.y = window.fs_height
        
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
            bottomView.fs_height = window.fs_height * 0.4
            bottomView.frame.origin.y = window.fs_height - (window.fs_height * 0.4) - self.keyboardHeight!

//            if self.keyboardHeight != nil {
//                bottomView.frame.origin.y = window.fs_height - (window.fs_height * 0.4) - self.keyboardHeight!
//            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            var id = 0
            let index = self.existPriorityArray[indexPath.section]
            
            switch (index){
            case "1": id = redArray[indexPath.row].id
            case "2": id = yellowArray[indexPath.row].id
            case "3": id = greenArray[indexPath.row].id
            case "4": id = blueArray[indexPath.row].id
            case "5": id = pinkArray[indexPath.row].id
            case "6": id = purpleArray[indexPath.row].id
            default: break
            }
            TodoService.shared.deleteTodo(id: id) { (response) in
                switch (response){
                case .success(let resultData):
                    if let data = resultData as? ResponseData{
                        print(data.resultCode)
                        if data.resultCode == 200 {
                            switch (index){
                            case "1": self.redArray.remove(at: indexPath.row)
                            case "2": self.yellowArray.remove(at: indexPath.row)
                            case "3": self.greenArray.remove(at: indexPath.row)
                            case "4": self.blueArray.remove(at: indexPath.row)
                            case "5": self.pinkArray.remove(at: indexPath.row)
                            case "6": self.purpleArray.remove(at: indexPath.row)
                            default: break
                            }
                            self.sectionSetting()
                        }
                    }
                case .requestErr(let message):
                    print("requestErr", message)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                case .decodeErr:
                    print("decodeErr")
                }
            }
        }
    }
    
    
}
extension TodoViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = existPriorityArray[section]
        switch (index){
        case "1": return redArray.count
        case "2": return yellowArray.count
        case "3": return greenArray.count
        case "4": return blueArray.count
        case "5": return pinkArray.count
        case "6": return purpleArray.count
        default: return 0
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleOfSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        
        let index = existPriorityArray[indexPath.section]
        var colorArray:[TodoList] = []
        var checkboxImage:UIImage?
        
        switch(index){
        case "1":
            colorArray = redArray
            checkboxImage = UIImage(named: "checkbox_red")
        case "2":
            colorArray = yellowArray
            checkboxImage = UIImage(named: "checkbox_yellow")
        case "3":
            colorArray = greenArray
            checkboxImage = UIImage(named: "checkbox_green")
        case "4":
            colorArray = blueArray
            checkboxImage = UIImage(named: "checkbox_blue")
        case "5":
            colorArray = pinkArray
            checkboxImage = UIImage(named: "checkbox_pink")
        case "6":
            colorArray = purpleArray
            checkboxImage = UIImage(named: "checkbox_purple")
        default: break
        }
        
        let todo = colorArray[indexPath.row]
        cell.todo = todo
        cell.titleTextField.text = todo.title
        
        if todo.done{
            cell.checkbox.setImage(checkboxImage, for: .normal)
        }else{
            cell.checkbox.setImage(UIImage(named: "checkbox"), for: .normal)
        }
        
        let background = UIView()
        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
extension TodoViewController:FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy MM dd E요일"
        
        let dateArray = dateFormatter.string(from: date).components(separatedBy: " ")
        
        var year = dateArray[0]
        var month = dateArray[1]
        var day = dateArray[2]
        var weekday = dateArray[3]
        
        self.dayLabel.text = day
        self.weekdayLabel.text = weekday

        searchDayTodo(year: year, month: month, day: day)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy.MM"
        let dateString = dateFormatter.string(from: calendarView.currentPage)
        
        self.calendarHeaderLabel.text = dateString
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        viewCalendarContainted.fs_height = viewCalendarContainted.fs_height - ( calendarView.fs_height - bounds.height)
        calendarOuterView.fs_height = calendarOuterView.fs_height - (calendarView.fs_height - bounds.height)
        calendarView.fs_height = bounds.height
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.tableView.reloadData()
        }
    }
}
extension TodoViewController:FSCalendarDataSource{
    
}

