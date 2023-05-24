//
//  TodoMainViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/04/19.
//

import Foundation
import SnapKit
import FSCalendar

class TodoMainViewController : UIViewController{
    
    var calendarView: FSCalendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 330, height: 270))
    var segmentedControl: UISegmentedControl = UISegmentedControl()
    var tableView: UITableView = UITableView()
    var topBarView: UIView = UIView()
    var hambuergerButton: UIButton = UIButton()
    var calendarImageView: UIImageView = UIImageView(image: UIImage(named: "calendar"))
    var dateLabel: UILabel = UILabel()
    var stackViewOfDateLabel:UIStackView = UIStackView()
    var dateFormatter = DateFormatter()
    var calendarBackgroundView: UIView = UIView()
    var headerView: UIView = UIView()
    var weekdayLabel: UILabel = UILabel()
    var dayLabel: UILabel = UILabel()
    var floatingButton: UIImageView = UIImageView()
    var collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 151, height: 107), collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    var bottomSheetView: UIView = UIView()
    var colorBarViewInBottomsheet: UIView = UIView()
    var titleTextFieldInBottomSheet: UITextField = UITextField()
    var dateLabelInBottomSheet: UILabel = UILabel()
    var descriptionBackgroundView: UIView = UIView()
    var descriptionTextView: UITextView = UITextView()
    var blackViewOfBottomSheet: UIView = UIView()
    var blackViewOfDrawer: UIView = UIView()
    var clockImageView: UIImageView = UIImageView(image: UIImage(named: "clock"))
    var timeLiterallyLabel: UILabel = UILabel()
    var timeLabel: UILabel = UILabel()
    var datePickerBackgroundView: UIView = UIView()
    var datePicker: UIDatePicker = UIDatePicker()
    var cancelButtonInDatePicker: UIButton = UIButton()
    var finishButtonInDatePicker: UIButton = UIButton()
    var grayLineNextDateLabel: UIView = UIView()
    var grayBackgroundView: UIView = UIView() //키보드레이아웃에 맞춘 테이블 뷰 밑에 빈 공간을 채우기 위한 뷰
    var whiteBackgroundView: UIView = UIView() //캘린더뷰를 내렸을 때 비는 공간을 채우기 위한 뷰
    var blackViewOfDatePicker: UIView = UIView()
    var redCircleButton: UIButton = {
        var button: UIButton = UIButton()
        button.tag = 1
        button.setImage(UIImage(named: "red-circle"), for: .normal)
        return button
    }()
    var yellowCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 2
        button.setImage(UIImage(named: "yellow-circle"), for: .normal)
        return button
    }()
    var greenCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 3
        button.setImage(UIImage(named: "green-circle"), for: .normal)
        return button
    }()
    var blueCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 4
        button.setImage(UIImage(named: "blue-circle"), for: .normal)
        return button
    }()
    var pinkCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 5
        button.setImage(UIImage(named: "pink-circle"), for: .normal)
        return button
    }()
    var purpleCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 6
        button.setImage(UIImage(named: "purple-circle"), for: .normal)
        return button
    }()
    var colorCircleButtonStackView:UIStackView = UIStackView()
    var grayLineInBottomSheet:UIView = UIView()
    var nothingExistingView: UIView = UIView()
    var nothingExistingLabel: UILabel = UILabel()
    
    var drawerViewController:DrawerViewController?
    
    let textviewPlaceholder:String = "+ 메모하고 싶은 내용이 있나요?"
    
    var redArray:[Todo] = []
    var yellowArray:[Todo] = []
    var greenArray:[Todo] = []
    var blueArray:[Todo] = []
    var pinkArray:[Todo] = []
    var purpleArray:[Todo] = []
    var todoArrayList:[[Todo]] = []
    var titleOfSectionArray:[String] = ["","","","","",""]
    var existingColorArray:[Int] = []
    var isCollectionViewShowing = false
    var floatingButton_y:CGFloat = 0
    var collectionView_y:CGFloat = 0
    var nowId:Int = 0
    var nowSection:Int = 0
    var nowRow:Int = 0
    var nowColor:Int = 0
    var nowHour: String = "00"
    var nowMin: String = "00"
    override func viewDidLoad() {
        super.viewDidLoad()
        //test code
        let userDefaults = UserDefaults.standard
        userDefaults.set("05add65f6ffd1e79ac17e4dc58f15c6f61aff9f8", forKey: "token")
        
        todoArrayList = [redArray, yellowArray, greenArray, blueArray, pinkArray, purpleArray]
        getPriorityName()
        
        //투두 테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        
        //색깔 선택 컬렉션 뷰 설정
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //캘린더 설정
        calendarView.delegate = self
        calendarView.dataSource = self
        
        //기본 뷰 색상 설정
        view.backgroundColor = .white
        
        //description text view delegate 설정
        descriptionTextView.delegate = self
        
        //데이트 포멧터 설정
        dateFormatter.locale = Locale(identifier: "ko")
        
        //컬렉션 뷰 셀 등록
        collectionView.register(ColorCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "collectionViewCell")
        
        
        addComponent() //컴포넌트 및 뷰 추가
        addFunctionToComponent()
        setAutoLayout() //오토 레이아웃 설정
        setComponentAppearence() //컴포넌트 외형 설정
        searchTodo(date: calendarView.selectedDate!) //투두 조회
    }
    
    private func addFunctionToComponent(){
        segmentedControl.addTarget(self, action: #selector(tapSegmentedControl), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFloatingButton))
        floatingButton.isUserInteractionEnabled = true
        floatingButton.addGestureRecognizer(tapGesture)
        blackViewOfBottomSheet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBottomSheetBlackViewDismiss)))
        hambuergerButton.addTarget(self, action: #selector(tapHamburgerButton), for: .touchDown)
        blackViewOfDrawer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDrawerBlackViewDismiss)))
        redCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        yellowCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        greenCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        blueCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        pinkCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        purpleCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        timeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTimeLabel)))
        cancelButtonInDatePicker.addTarget(self, action: #selector(tapCancelButtonInDatePicker), for: .touchDown)
        finishButtonInDatePicker.addTarget(self, action: #selector(tapFinishButtonInDatePicker), for: .touchDown)
    }
    
    private func addComponent(){
        //기본 뷰에 세그먼티트 컨트롤, 햄버거바를 담을 뷰 추가
        self.view.addSubview(topBarView)
        
        //상위 뷰에 새그먼티트 컨트롤, 햄버거바 추가
        topBarView.addSubview(segmentedControl)
        topBarView.addSubview(hambuergerButton)
        
        //기본 뷰에 테이블뷰 추가
        self.view.addSubview(tableView)
        self.view.addSubview(grayBackgroundView)
        tableView.separatorStyle = .none
        
        //calendar background view에 컴포넌트 추가
        calendarBackgroundView.addSubview(calendarImageView)
        calendarBackgroundView.addSubview(dateLabel)
        calendarBackgroundView.addSubview(calendarView)
        
        //헤더뷰에 추가
        headerView.addSubview(calendarBackgroundView)
        headerView.addSubview(weekdayLabel)
        headerView.addSubview(dayLabel)
        headerView.addSubview(grayLineNextDateLabel)
        
        //tableview header view 지정
        tableView.tableHeaderView = headerView
        
        //floating button 추가
        tableView.addSubview(floatingButton)
        
        //bottom sheet view 내부 component추가
        bottomSheetView.addSubview(colorBarViewInBottomsheet)
        bottomSheetView.addSubview(titleTextFieldInBottomSheet)
        bottomSheetView.addSubview(dateLabelInBottomSheet)
        bottomSheetView.addSubview(descriptionTextView)
        bottomSheetView.addSubview(clockImageView)
        bottomSheetView.addSubview(timeLiterallyLabel)
        bottomSheetView.addSubview(timeLabel)
        bottomSheetView.addSubview(grayLineInBottomSheet)
        
        colorCircleButtonStackView.addArrangedSubview(redCircleButton)
        colorCircleButtonStackView.addArrangedSubview(yellowCircleButton)
        colorCircleButtonStackView.addArrangedSubview(greenCircleButton)
        colorCircleButtonStackView.addArrangedSubview(blueCircleButton)
        colorCircleButtonStackView.addArrangedSubview(pinkCircleButton)
        colorCircleButtonStackView.addArrangedSubview(purpleCircleButton)
        
        bottomSheetView.addSubview(colorCircleButtonStackView)
        
//        nothingExistingView.addSubview(nothingExistingLabel)
//        tableView.addSubview(nothingExistingView)
        
        datePickerBackgroundView.addSubview(datePicker)
        datePickerBackgroundView.addSubview(cancelButtonInDatePicker)
        datePickerBackgroundView.addSubview(finishButtonInDatePicker)
        
    }
    
    private func setComponentAppearence(){
        //segmented control segment 추가 및 초기 셋팅
        segmentedControl.insertSegment(withTitle: "월간", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "주간", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        
        //햄버거 바 버튼 이미지 지정
        hambuergerButton.setImage(UIImage(named: "hamburger-button"), for: .normal)
        
        //캘린더 상단 날짜 라벨
        dateLabel.textColor = UIColor.black
        dateLabel.font.withSize(15)
        dateLabel.text = DateFormat.shared.getdateLabelString(date: calendarView.currentPage)
        dateLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        //캘린더뷰 외형 설정
        calendarView.headerHeight = 0
        calendarView.select(calendarView.today)
        calendarView.firstWeekday = 2
        calendarView.appearance.titleWeekendColor = UIColor(red: 1, green: 0.654, blue: 0.654, alpha: 1)
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        calendarView.appearance.selectionColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
        calendarView.appearance.todayColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        calendarView.appearance.titleTodayColor = UIColor(red: 0.246, green: 0.246, blue: 0.246, alpha: 1)
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.weekdayTextColor = .black
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .red
        
        //캘린더 백그라운드 뷰 외형 설정
        calendarBackgroundView.backgroundColor = .white
        
        //테이블 뷰 외형 설정
        tableView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        
        //테이블 뷰 헤더 뷰 설정
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 400)
        calendarBackgroundView.frame = CGRect(x: 0, y: 0, width: view.fs_width, height: 350)
        
        //calendar background view 하단 라운드 및 그림자 설정
        calendarBackgroundView.clipsToBounds = true
        calendarBackgroundView.layer.cornerRadius = 30
        calendarBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        calendarBackgroundView.layer.masksToBounds = false
        calendarBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        calendarBackgroundView.layer.shadowOpacity = 0.2
        calendarBackgroundView.layer.shadowRadius = 5
        calendarBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        //날짜 라벨
        dayLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        weekdayLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        weekdayLabel.text = DateFormat.shared.getWeekdayInKorean(date: calendarView.selectedDate!)
        dayLabel.text = DateFormat.shared.getDay(date: calendarView.selectedDate!)
        weekdayLabel.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        
        //Floating Button 외형 설정
        floatingButton_y = self.view.fs_height*(7/10)
        floatingButton.frame = CGRect(x: self.view.fs_width*(7/10), y:  floatingButton_y,width:76 , height: 76)
        floatingButton.image = UIImage(named: "floating-button")
        floatingButton.layer.shadowColor = UIColor.lightGray.cgColor
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowRadius = 5.0
        floatingButton.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        //색깔 선택 view 외형 설정
        collectionView.clipsToBounds = true
        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowOpacity = 0.4
        collectionView.layer.shadowRadius = 5.0
        collectionView.layer.shadowOffset = CGSize(width: -1, height: 3)
        collectionView.layer.cornerRadius = 15
        
        //bottom sheet
        bottomSheetView.backgroundColor = .white
        bottomSheetView.layer.cornerRadius = 20
        bottomSheetView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        //black view 설정
        blackViewOfBottomSheet.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackViewOfBottomSheet.frame = self.view.frame
        
        colorBarViewInBottomsheet.clipsToBounds = true
        colorBarViewInBottomsheet.layer.cornerRadius = 4.5
        colorBarViewInBottomsheet.backgroundColor = .systemPink
        
        
        //bottom sheet 내부에 있는 날짜 label 외형 설정
        dateLabelInBottomSheet.text = DateFormat.shared.getYearMonthDayAndWeekday(date: calendarView.selectedDate!)
        dateLabelInBottomSheet.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        dateLabelInBottomSheet.textColor = .black
        
        //bottom sheet 내부 title label 외형 설정
        titleTextFieldInBottomSheet.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleTextFieldInBottomSheet.textColor = .black
        titleTextFieldInBottomSheet.placeholder = "토도리스트 입력"
        
        //bottom sheet 내부 description text view 외부 background 외형 설정
        descriptionTextView.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.textContainer.maximumNumberOfLines = 3
        
        //bottom sheet 내부 desctription text view 외형 설정
        descriptionTextView.font = UIFont.systemFont(ofSize: 14, weight: .light)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textContainer.maximumNumberOfLines = 3
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18)
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        
        //bottom sheet 내부 '시간' 라벨
        timeLiterallyLabel.text = "시간"
        timeLiterallyLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        timeLiterallyLabel.textColor = .black
        
        //bottom sheet 내부 시간 선택하는 부분
        timeLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        timeLabel.textColor = .black
        timeLabel.isUserInteractionEnabled = true
        
        datePickerBackgroundView.backgroundColor = .white
        
        colorCircleButtonStackView.axis = .horizontal
        colorCircleButtonStackView.distribution = .equalSpacing
        
        grayLineInBottomSheet.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        
        nothingExistingView.backgroundColor = UIColor.clear

        // 테두리 설정
        nothingExistingView.layer.borderWidth = 1.0
        nothingExistingView.layer.borderColor = UIColor.gray.cgColor

        // 점선 스타일 설정
        let dashPattern: [NSNumber] = [10, 10]
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.gray.cgColor
        borderLayer.lineDashPattern = dashPattern
        borderLayer.lineCap = .round // 점선의 끝 부분을 둥글게 처리
        borderLayer.frame = nothingExistingView.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: nothingExistingView.bounds).cgPath
        nothingExistingView.layer.masksToBounds = true
        nothingExistingView.layer.addSublayer(borderLayer)

        
        nothingExistingLabel.text = "등록된 토도리스트가 없습니다."
        
        grayLineNextDateLabel.backgroundColor = UIColor(red: 0.846, green: 0.846, blue: 0.846, alpha: 1)
        
        grayBackgroundView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        
        whiteBackgroundView.backgroundColor = .white
        
        blackViewOfDatePicker.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackViewOfDatePicker.frame = self.view.frame
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.minuteInterval = 5
        
        cancelButtonInDatePicker.setTitle("취소", for: .normal)
        cancelButtonInDatePicker.setTitleColor(.black, for: .normal)
        cancelButtonInDatePicker.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        finishButtonInDatePicker.setTitle("확인", for: .normal)
        finishButtonInDatePicker.setTitleColor(.black, for: .normal)
        finishButtonInDatePicker.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        datePickerBackgroundView.layer.cornerRadius = 20
        datePickerBackgroundView.clipsToBounds = true

    }
    
    private func setAutoLayout(){
        topBarView.snp.makeConstraints { make in
            make.right.left.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(138)
            make.right.equalTo(-138)
        }
        
        hambuergerButton.snp.makeConstraints { make in
            make.width.height.equalTo(29)
            make.rightMargin.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.right.left.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            make.top.equalTo(topBarView.snp.bottom)
        }
        
        grayBackgroundView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(200)
            make.top.equalTo(tableView.snp.bottom)
        }
        
        //캘린더 뷰 설정
        calendarView.frame = CGRect(x: (self.view.fs_width - calendarView.fs_width)/2, y: dateLabel.frame.origin.y + 60, width: 330, height: 270)
        
        calendarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(21)
            make.top.equalTo(calendarBackgroundView.snp.top).offset(16)
            make.left.equalTo(calendarBackgroundView.snp.left).offset(calendarView.frame.origin.x)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(calendarImageView.snp.right).offset(5)
            make.centerY.equalTo(calendarImageView)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.bottom.equalTo(headerView)
            make.left.equalTo(headerView).offset(20)
        }
        
        weekdayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel)
            make.left.equalTo(dayLabel.snp.right).offset(6)
        }
        
        grayLineNextDateLabel.snp.makeConstraints { make in
            make.left.equalTo(weekdayLabel.snp.right).offset(6)
            make.right.equalToSuperview().offset(-21)
            make.height.equalTo(1)
            make.centerY.equalTo(dayLabel)
        }
        
//        nothingExistingView.snp.makeConstraints { make in
//            make.height.equalTo(43)
//            make.width.equalTo(self.view.fs_width-42)
//            make.centerX.equalToSuperview()
//            make.top.equalTo(tableView.tableHeaderView!.snp.bottom).offset(15)
//        }
//
//        nothingExistingLabel.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//        }

    }
    
    private func setBottomSheetAutoLayout(){
        bottomSheetView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(310)
        }
        
        dateLabelInBottomSheet.snp.makeConstraints { make in
            make.top.equalTo(colorBarViewInBottomsheet.snp.top)
            make.left.equalTo(colorBarViewInBottomsheet.snp.right).offset(8)
        }
        
        titleTextFieldInBottomSheet.snp.makeConstraints { make in
            make.left.equalTo(dateLabelInBottomSheet)
            make.top.equalTo(dateLabelInBottomSheet.snp.bottom).offset(3)
        }
        
        colorBarViewInBottomsheet.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(9)
            make.bottom.equalTo(titleTextFieldInBottomSheet)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextFieldInBottomSheet.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.rightMargin.leftMargin.equalTo(25)
            make.height.equalTo(70)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.left.equalTo(descriptionTextView)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(22)
        }
        
        timeLiterallyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clockImageView)
            make.left.equalTo(clockImageView.snp.right).offset(6)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clockImageView)
            make.left.equalTo(timeLiterallyLabel.snp.right).offset(6)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        grayLineInBottomSheet.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-42)
            make.left.equalToSuperview().offset(42)
            make.top.equalTo(timeLiterallyLabel.snp.bottom).offset(26)
            make.height.equalTo(1)
        }
        
        redCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        yellowCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        greenCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        blueCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        pinkCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        purpleCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        colorCircleButtonStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-42)
            make.left.equalToSuperview().offset(42)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setDatePickerViewAutoLayout(){
        datePickerBackgroundView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-28)
            make.left.equalToSuperview().offset(28)
            make.centerY.equalToSuperview()
            make.height.equalTo(260)
        }
        
        finishButtonInDatePicker.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(23)
        }
        
        cancelButtonInDatePicker.snp.makeConstraints { make in
            make.right.equalTo(finishButtonInDatePicker.snp.left).offset(-32)
            make.centerY.equalTo(finishButtonInDatePicker)
        }
        
        datePicker.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(finishButtonInDatePicker.snp.bottom)
            make.bottom.equalToSuperview().offset(-17)
        }
    }
    
   
    
    private func getPriorityName(){
        TodoAPIConstant.shared.getPriorityName { (response) in
            switch(response){
            case .success(let resultData):
                if let data = resultData as? PriorityResponseData{
                    if data.resultCode == 200 {
                        self.titleOfSectionArray[0] = data.data._1
                        self.titleOfSectionArray[1] = data.data._2
                        self.titleOfSectionArray[2] = data.data._3
                        self.titleOfSectionArray[3] = data.data._4
                        self.titleOfSectionArray[4] = data.data._5
                        self.titleOfSectionArray[5] = data.data._6
                    }
                }
            case .failure(let meassage):
                print("failure", meassage)
                
            }
        }
    }

    @objc private func tapColorCircleButton(_ sender: UIButton){
        redCircleButton.setImage(UIImage(named: "red-circle"), for: .normal)
        yellowCircleButton.setImage(UIImage(named: "yellow-circle"), for: .normal)
        greenCircleButton.setImage(UIImage(named: "green-circle"), for: .normal)
        blueCircleButton.setImage(UIImage(named: "blue-circle"), for: .normal)
        pinkCircleButton.setImage(UIImage(named: "pink-circle"), for: .normal)
        purpleCircleButton.setImage(UIImage(named: "purple-circle"), for: .normal)

        nowColor = sender.tag
        sender.setImage(Color.shared.getSeletedCircleImage(colorNum: nowColor), for: .normal)
        colorBarViewInBottomsheet.backgroundColor = Color.shared.getColor(colorNum: nowColor)
        dateLabelInBottomSheet.textColor = Color.shared.getColor(colorNum: nowColor)
    }
    
    
    @objc private func handleBottomSheetBlackViewDismiss(){
        let description = descriptionTextView.text.replacingOccurrences(of: textviewPlaceholder, with: "")
        TodoAPIConstant.shared.editTodo(title: titleTextFieldInBottomSheet.text ?? "", description:description, colorNum:nowColor, time: nowHour+nowMin,id: nowId) { (response) in
            switch(response){
            case .success(let resultData):
                if let data = resultData as? TodoEditResponseData{
                    if data.resultCode == 200 {
                        print(data.resultCode)
                        self.todoArrayList[self.nowSection][self.nowRow].title = data.data.title
                        self.todoArrayList[self.nowSection][self.nowRow].description = data.data.description
                        self.todoArrayList[self.nowSection][self.nowRow].color = data.data.color
                        self.todoArrayList[self.nowSection][self.nowRow].id = data.data.id
                        self.todoArrayList[self.nowSection][self.nowRow].time = data.data.time
                        self.todoArrayList[self.nowColor-1].append(self.todoArrayList[self.nowSection][self.nowRow])
                        self.todoArrayList[self.nowSection].remove(at: self.nowRow)
                        self.setExistArray()
                        self.todoSortById(section: self.nowColor-1)
                        self.todoSortByDone(section: self.nowColor-1)
                        self.tableView.reloadData()
                    }
                }
            case .failure(let meassage):
                print("failure", meassage)
                
            }
        }
        self.blackViewOfBottomSheet.removeFromSuperview()
        self.bottomSheetView.removeFromSuperview()

        view.endEditing(true)
        
    }
    
    @objc private func tapCancelButtonInDatePicker(){
        blackViewOfDatePicker.removeFromSuperview()
        datePickerBackgroundView.removeFromSuperview()
    }
    
    @objc private func tapFinishButtonInDatePicker(){
        nowHour = DateFormat.shared.getHour(date: datePicker.date)
        nowMin = DateFormat.shared.getMinute(date: datePicker.date)
        timeLabel.text =  "\(nowHour):\(nowMin)"
        timeLabel.textColor = .black
        blackViewOfDatePicker.removeFromSuperview()
        datePickerBackgroundView.removeFromSuperview()
    }

    
    @objc private func tapSegmentedControl(){
        if segmentedControl.selectedSegmentIndex == 0{
            self.calendarView.setScope(.month, animated: true)
        }else{
            self.calendarView.setScope(.week, animated: true)
        }
    }
    
    @objc private func tapFloatingButton(){
        if isCollectionViewShowing{
            collectionView.removeFromSuperview()
        }else {
            //컬렉션 뷰 추가
            tableView.addSubview(collectionView)
            
            //컬렉션 뷰 위치 지정
            collectionView.frame.origin.x = floatingButton.frame.origin.x - (collectionView.fs_width-floatingButton.fs_width)
            collectionView.frame.origin.y = floatingButton.frame.origin.y - 10 - collectionView.fs_height
            collectionView_y = collectionView.frame.origin.y
        }
        isCollectionViewShowing = !isCollectionViewShowing

    }
    
    private func todoSortByDone(section:Int){
        self.todoArrayList[section].sort { todo1, todo2 in
            return !todo1.done && todo2.done
        }
    }
    
    private func todoSortById(section:Int){
        self.todoArrayList[section].sort { todo1, todo2 in
            return todo1.id < todo2.id
        }
    }
    
    @objc private func tapHamburgerButton(){
        drawerViewController = DrawerViewController()
        guard let drawerView = drawerViewController?.view else {return}
        
        self.blackViewOfDrawer.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(self.blackViewOfDrawer)
        self.addChild(drawerViewController!)
        view.addSubview(drawerView)
        
        blackViewOfDrawer.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackViewOfDrawer.frame = self.view.frame
        
        drawerView.layer.fs_width = 0
        drawerView.layer.fs_height = self.view.fs_height
        drawerView.frame.origin.x = self.view.fs_width
        
        UIView.animate(withDuration: 0.3) {
            drawerView.layer.fs_width = self.view.fs_width * 0.8
            drawerView.frame.origin.x = self.view.fs_width - (self.view.fs_width * 0.8)
        }
    }
    
    @objc private func handleDrawerBlackViewDismiss(){
        blackViewOfDrawer.removeFromSuperview()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.drawerViewController?.view.frame.origin.x = self.view.fs_width
            self.drawerViewController?.view.fs_width = 0
            
        }, completion: { finished in
            self.drawerViewController?.view.removeFromSuperview()
        })
    }
    
    @objc private func tapTimeLabel(){
        self.view.addSubview(blackViewOfDatePicker)
        self.view.addSubview(datePickerBackgroundView)
        setDatePickerViewAutoLayout()
    }
    
    private func setExistArray(){
        existingColorArray.removeAll()
        for i in 0 ..< 6 {
            if todoArrayList[i].count > 0 {
                existingColorArray.append(i)
            }
        }
    }
    
    private func setCircleButtonImage(){
        redCircleButton.setImage(UIImage(named: "red-circle"), for: .normal)
        yellowCircleButton.setImage(UIImage(named: "yellow-circle"), for: .normal)
        greenCircleButton.setImage(UIImage(named: "green-circle"), for: .normal)
        blueCircleButton.setImage(UIImage(named: "blue-circle"), for: .normal)
        pinkCircleButton.setImage(UIImage(named: "pink-circle"), for: .normal)
        purpleCircleButton.setImage(UIImage(named: "purple-circle"), for: .normal)

    }
    
    private func searchTodo(date:Date){
        let dateArr = DateFormat.shared.getYearMonthDay(date: date)
        TodoAPIConstant.shared.searchTodo(year: dateArr[0], month: dateArr[1], day: dateArr[2]) {(response) in
            switch(response){
            case .success(let resultData):
                if let data = resultData as? TodoSearchResponseData{
                    if data.resultCode == 200 {
                        self.todoArrayList[0].removeAll()
                        self.todoArrayList[1].removeAll()
                        self.todoArrayList[2].removeAll()
                        self.todoArrayList[3].removeAll()
                        self.todoArrayList[4].removeAll()
                        self.todoArrayList[5].removeAll()
                        self.existingColorArray.removeAll()
                        
                        for i in data.data{
                            self.todoArrayList[i.color - 1].append(Todo(year: String(i.year), month: String(i.month), day: String(i.day), title: i.title, done: i.done, isNew: false, writer: i.writer, color: i.color, id: i.id, time: i.time, description: i.description))
                        }
                        
                        for i in 0 ..< 6{
                            self.todoArrayList[i].sort { todo1, todo2 in
                                return !todo1.done && todo2.done
                            }
                            if !self.todoArrayList[i].isEmpty{
                                self.existingColorArray.append(i)
                            }
                        }

                        self.tableView.reloadData()
                    }
                }
            case .failure(let meassage):
                print("failure", meassage)
                
            }
        }
    }
    
    //table view 터치하면 키보드 내려가기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.tableView.endEditing(true)
        self.view.endEditing(true)
    }
    
    
}

//table view delegate, datasource
extension TodoMainViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view:UIView = UIView()
        var colorRoundView:UIView = UIView()
        var titleLabel:UILabel = UILabel()
        
        view.addSubview(colorRoundView)
        view.addSubview(titleLabel)
        
        colorRoundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(9)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorRoundView)
            make.left.equalTo(colorRoundView.snp.right).offset(5)
        }
        
        colorRoundView.clipsToBounds = true
        colorRoundView.layer.cornerRadius = 4.5
        colorRoundView.backgroundColor = Color.shared.UIColorArray[existingColorArray[section]]
        
        titleLabel.text = titleOfSectionArray[existingColorArray[section]]
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = .black
        
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return existingColorArray.count
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        floatingButton.frame = CGRect(x: floatingButton.frame.origin.x, y: floatingButton_y + offset, width: 76, height: 76)
        collectionView.frame = CGRect(x: collectionView.frame.origin.x, y: collectionView_y + offset, width: collectionView.fs_width, height: collectionView.fs_height)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print(indexPath.section)
            TodoAPIConstant.shared.deleteTodo(id: todoArrayList[existingColorArray[indexPath.section]][indexPath.row].id) { (resonse) in
                switch(resonse){
                case .success(let resultData):
                    if let data = resultData as? ResponseData{
                        if data.resultCode == 200 {
                            self.todoArrayList[self.existingColorArray[indexPath.section]].remove(at: indexPath.row)
                            self.setExistArray()
                            tableView.reloadData()
                        }
                    }
                case .failure(let message):
                    print("failure", message)
                }
            }
        }
    }
    
    
    
}
extension TodoMainViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArrayList[existingColorArray[section]].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TodoTableViewCell()
        let todo = todoArrayList[existingColorArray[indexPath.section]][indexPath.row]
        cell.todo = todo
        cell.titleTextField.text = todo.title
        cell.section = indexPath.section
        cell.row = indexPath.row
        cell.delegate = self
        cell.checkbox.setImage(todo.done ? Color.shared.getCheckBoxImage(colorNum: todo.color):UIImage(named: "checkbox"), for: .normal)
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        49
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.addSubview(blackViewOfBottomSheet)
        self.view.addSubview(bottomSheetView)
        
        let todo:Todo = todoArrayList[existingColorArray[indexPath.section]][indexPath.row]
        
        //bottom sheet 내부 컬러바 색상 설정
        colorBarViewInBottomsheet.backgroundColor = Color.shared.UIColorArray[todo.color-1]
        //날짜 라벨 텍스트 색상 설정
        dateLabelInBottomSheet.textColor = Color.shared.UIColorArray[todo.color-1]
        //title text field에 해당 title로 설정
        titleTextFieldInBottomSheet.text = todo.title
        
        //desctiption이 있을때, 없을 때 설정
        if todo.description.count != 0{
            descriptionTextView.text = todo.description
            descriptionTextView.textColor = .black
            descriptionTextView.sizeToFit()
        }else{
            descriptionTextView.text = textviewPlaceholder
            descriptionTextView.textColor = .gray
            descriptionTextView.sizeToFit()
        }
        
        //설정된 시간이 있을 때, 없을 때 설정
        if todo.time == "0000"{
            timeLabel.text = "미지정"
            timeLabel.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        }else{
            let time = todo.time
            let hour = time.prefix(2)
            let min = time.suffix(2)
            if let time = Int(time){
                if time >= 1200 {
                    timeLabel.text = "오후 \(hour):\(min)"
                }else {
                    timeLabel.text = "오전 \(hour):\(min)"
                }
            }
            timeLabel.textColor = .black
        }
        nowId = todo.id
        nowSection = existingColorArray[indexPath.section]
        nowRow = indexPath.row
        nowColor = todo.color
        
        setCircleButtonImage()
        switch(todo.color){
        case 1: redCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
        case 2: yellowCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
        case 3: greenCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
        case 4: blueCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
        case 5: pinkCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
        case 6: purpleCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
        default: break
        }
        
        titleTextFieldInBottomSheet.becomeFirstResponder()
        setBottomSheetAutoLayout()
    }
}

//calendar delegate, datasource
extension TodoMainViewController:FSCalendarDelegate{
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        dateLabel.text = DateFormat.shared.getdateLabelString(date: calendarView.currentPage)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        searchTodo(date: date)
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 || weekday == 7{
            calendarView.appearance.titleSelectionColor = UIColor(red: 1, green: 0.338, blue: 0.338, alpha: 1)
        }else{
            calendarView.appearance.titleSelectionColor = .black
        }
        
        dayLabel.text = DateFormat.shared.getDay(date: date)
        weekdayLabel.text = DateFormat.shared.getWeekdayInKorean(date: date)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarBackgroundView.fs_height = calendarBackgroundView.fs_height - (calendarView.fs_height - bounds.height)
        tableView.tableHeaderView?.fs_height = tableView.tableHeaderView!.fs_height - (calendarView.fs_height - bounds.height)
        calendarView.fs_height = bounds.height
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.tableView.reloadData()
        }
    }
        
        
}
extension TodoMainViewController:FSCalendarDataSource{
}

//collection view delegate, datasource
extension TodoMainViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = DateFormat.shared.getYearMonthDay(date: calendarView.selectedDate!)
        todoArrayList[indexPath.row].insert(Todo(year: date[0] , month: date[1], day: date[2], title: "", done: false, isNew: true, writer: "", color: indexPath.row + 1, id: 0, time: "0000", description: ""), at: 0)
        setExistArray()
        tableView.reloadData()
        collectionView.removeFromSuperview()
        isCollectionViewShowing = false
    }
}
extension TodoMainViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! ColorCollectionViewCell
        
        view.backgroundColor = Color.shared.UIColorArray[indexPath.row]
        view.clipsToBounds = true
        view.layer.cornerRadius = view.fs_width/2
        return view
    }
}

//collection view layout delegate
extension TodoMainViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 25, height: 25)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22)
        return inset
    }
}

extension TodoMainViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textviewPlaceholder{
            textView.text = ""
            textView.textColor = .black
            textView.sizeToFit()
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.textColor = .gray
            textView.text = textviewPlaceholder
            textView.sizeToFit()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.sizeToFit()
    }
}
extension TodoMainViewController:TodoTableViewCellDelegate{
    func sendTodoData(section: Int, row: Int, todo: Todo) {
        todoArrayList[todo.color-1][row] = todo
        todoSortById(section: section)
        todoSortByDone(section: section)
        tableView.reloadData()
    }
    
    func editDone(section: Int, row: Int, todo: Todo) {
        todoArrayList[todo.color-1][row] = todo
        todoSortById(section: todo.color-1)
        todoSortByDone(section: todo.color-1)
        tableView.reloadData()
    }
}
