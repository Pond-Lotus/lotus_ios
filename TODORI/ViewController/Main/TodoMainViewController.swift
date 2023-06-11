//
//  TodoMainViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/29.
//

import UIKit
import SnapKit
import FSCalendar

class TodoMainViewController : UIViewController {

    private var overlayViewController: MyPageViewController?
    var dimmingView: UIView = UIView()
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
    var grayFooterView: UIView = UIView() //키보드레이아웃에 맞춘 테이블 뷰 밑에 빈 공간을 채우기 위한 뷰
    var whiteBackgroundView: UIView = UIView() //캘린더뷰를 내렸을 때 비는 공간을 채우기 위한 뷰
    var blackViewOfDatePicker: UIView = UIView()
    var deleteButtonInDatePicker: UIButton = UIButton()
    var bottomSheetHeightConstraint: ConstraintMakerEditable?
    var datePickerBackgroundViewHeightConstraint: ConstraintMakerEditable?
    var descriptionTextViewHeightConstraint: ConstraintMakerEditable?
    var bottomSheetHeight: CGFloat = 0
    var clearViewOfFloatingButton: UIView = UIView()
    var clearViewForWritingTodo: UIView = UIView()
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
    var nowHour: String = "99"
    var nowMin: String = "99"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
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
        
        titleTextFieldInBottomSheet.delegate = self
        
        //데이트 포멧터 설정
        dateFormatter.locale = Locale(identifier: "ko")
        
        //컬렉션 뷰 셀 등록
        collectionView.register(ColorCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "collectionViewCell")
        
        addComponent() //컴포넌트 및 뷰 추가
        addFunctionToComponent()
        setComponentAppearence() //컴포넌트 외형 설정
        setAutoLayout() //오토 레이아웃 설정
        searchTodo(date: calendarView.selectedDate!) //투두 조회
    }
    
    
    private func addFunctionToComponent(){
        let tapTableViewGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapTableViewGesture.delegate = self // delegate 설정
        tableView.addGestureRecognizer(tapTableViewGesture)
        segmentedControl.addTarget(self, action: #selector(tapSegmentedControl), for: .valueChanged)
        floatingButton.isUserInteractionEnabled = true
        floatingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFloatingButton)))
        blackViewOfBottomSheet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBottomSheetBlackViewDismiss)))
        clearViewForWritingTodo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleWritingTodoClearViewDissmiss)))
        clearViewOfFloatingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFloatingButtonClearViewDismiss)))
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
        dimmingView.isUserInteractionEnabled = true
        hambuergerButton.addTarget(self, action: #selector(tapHamburgerButton), for: .touchDown)
        redCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        yellowCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        greenCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        blueCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        pinkCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        purpleCircleButton.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)
        timeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTimeLabel)))
        cancelButtonInDatePicker.addTarget(self, action: #selector(tapCancelButtonInDatePicker), for: .touchDown)
        finishButtonInDatePicker.addTarget(self, action: #selector(tapFinishButtonInDatePicker), for: .touchDown)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        deleteButtonInDatePicker.addTarget(self, action: #selector(tapDeleteButton), for: .touchDown)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveEndEditGroupName), name: NSNotification.Name("endEditGroupName"), object: nil)
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
        tableView.tableFooterView = grayFooterView
        
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
        
        nothingExistingView.addSubview(nothingExistingLabel)
        tableView.addSubview(nothingExistingView)
        
        datePickerBackgroundView.addSubview(datePicker)
        datePickerBackgroundView.addSubview(cancelButtonInDatePicker)
        datePickerBackgroundView.addSubview(finishButtonInDatePicker)
        datePickerBackgroundView.addSubview(deleteButtonInDatePicker)
        
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
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.fs_width = self.view.fs_width * 0.9
        calendarView.frame = CGRect(x: (self.view.fs_width - calendarView.fs_width)/2, y: dateLabel.frame.origin.y + 55, width: self.view.fs_width*0.9, height: calendarView.fs_width*0.8)

        
        //캘린더 백그라운드 뷰 외형 설정
        calendarBackgroundView.backgroundColor = .white
        
        //테이블 뷰 외형 설정
        tableView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        
        //테이블 뷰 헤더 뷰 설정
        calendarBackgroundView.frame = CGRect(x: 0, y: 0, width: view.fs_width, height: calendarView.fs_height + 70)
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: calendarBackgroundView.fs_height + 50)

        
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
        floatingButton_y = self.view.fs_height*0.7
        floatingButton.frame = CGRect(x: self.view.fs_width*0.75, y:  floatingButton_y, width:self.view.fs_width * 0.16 , height: self.view.fs_width * 0.16)
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
        
        //bottom sheet 내부 description text view 설정
        descriptionTextView.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        descriptionTextView.font = UIFont.systemFont(ofSize: 14, weight: .light)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        descriptionTextView.textContainer.lineBreakMode = .byCharWrapping
//        descriptionTextView.isScrollEnabled = false
        
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
        
        // 투두 없을 때 나오는 뷰 설정
        nothingExistingView.backgroundColor = .white
        nothingExistingView.clipsToBounds = true
        nothingExistingView.layer.cornerRadius = 10
        
        //투두 없을 때 나오는 뷰 내부 라벨
        nothingExistingLabel.text = "등록된 토도리스트가 없습니다."
        nothingExistingLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nothingExistingLabel.textColor = UIColor(red: 0.575, green: 0.561, blue: 0.561, alpha: 1)
        
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
        
        deleteButtonInDatePicker.setTitle("삭제", for: .normal)
        deleteButtonInDatePicker.setTitleColor(.red, for: .normal)
        deleteButtonInDatePicker.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        datePickerBackgroundView.layer.cornerRadius = 20
        datePickerBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        datePickerBackgroundView.clipsToBounds = true
        
        grayFooterView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        grayFooterView.fs_width = self.view.fs_width
        grayFooterView.fs_height = self.view.fs_height*0.3
        
        clearViewOfFloatingButton.backgroundColor = .clear
        
        clearViewForWritingTodo.backgroundColor = .clear
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
            make.height.equalTo(400)
            make.top.equalTo(tableView.snp.bottom)
        }
                
        calendarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(21)
            make.top.equalTo(calendarBackgroundView.snp.top).offset(16)
            make.left.equalTo(calendarBackgroundView.snp.left).offset(calendarView.frame.origin.x+14)
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
        
        nothingExistingView.snp.makeConstraints { make in
            make.height.equalTo(43)
            make.width.equalTo(self.view.fs_width-42)
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.tableHeaderView!.snp.bottom).offset(15)
        }
        
        nothingExistingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18)
        }
        
    }
    
    private func setBottomSheetAutoLayout(){
        
        bottomSheetView.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            bottomSheetHeightConstraint = make.height.equalTo(0)
        }
        
        dateLabelInBottomSheet.snp.makeConstraints { make in
            make.top.equalTo(colorBarViewInBottomsheet.snp.top)
            make.left.equalTo(colorBarViewInBottomsheet.snp.right).offset(8)
        }
        
        titleTextFieldInBottomSheet.snp.makeConstraints { make in
            make.left.equalTo(dateLabelInBottomSheet)
            make.top.equalTo(dateLabelInBottomSheet.snp.bottom).offset(3)
            make.right.equalToSuperview().offset(-25)
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
//            guard let lineHeight = descriptionTextView.font?.lineHeight else {
//                descriptionTextViewHeightConstraint = make.height.equalTo(74)
//                return
//            }
//            descriptionTextViewHeightConstraint = make.height.equalTo((lineHeight*1)+24)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.left.equalTo(descriptionTextView)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(22)
        }
        
        timeLiterallyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clockImageView)
            make.left.equalTo(clockImageView.snp.right).offset(4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clockImageView)
            make.left.equalTo(timeLiterallyLabel.snp.right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        grayLineInBottomSheet.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.left.equalToSuperview().offset(25)
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
            make.top.equalTo(grayLineInBottomSheet).offset(20)
        }
    }
    
    private func setDatePickerViewAutoLayout(){
        datePickerBackgroundView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            datePickerBackgroundViewHeightConstraint = make.height.equalTo(0)
        }
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.datePickerBackgroundViewHeightConstraint?.constraint.update(offset: 380)
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
        })
        
        finishButtonInDatePicker.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(25)
        }
        
        cancelButtonInDatePicker.snp.makeConstraints { make in
            make.right.equalTo(finishButtonInDatePicker.snp.left).offset(-32)
            make.centerY.equalTo(finishButtonInDatePicker)
        }
        
        datePicker.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.left.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }
        
        deleteButtonInDatePicker.snp.makeConstraints { make in
            make.centerY.equalTo(finishButtonInDatePicker)
            make.left.equalToSuperview().offset(25)
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
    
    @objc private func handleWritingTodoClearViewDissmiss(){
        tableView.endEditing(true)
        clearViewForWritingTodo.removeFromSuperview()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if self.bottomSheetView.superview == self.view{
                let size = CGSize(width: descriptionTextView.bounds.width, height: .infinity)
                let newSize = descriptionTextView.sizeThatFits(size)
                guard let lineHeight = descriptionTextView.font?.lineHeight else {return}
                if newSize.height/lineHeight < 6 {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.bottomSheetHeightConstraint?.constraint.update(offset: 270 + keyboardHeight + newSize.height - (lineHeight+24))
                        self.bottomSheetHeight = 270 + keyboardHeight
                        self.view.layoutIfNeeded()
                    })
                    self.view.updateConstraints()
                }else{
                    UIView.animate(withDuration: 0.25, animations: {
                        self.bottomSheetHeightConstraint?.constraint.update(offset: 270 + keyboardHeight + (24 + lineHeight * 4) - (lineHeight+24))
                        self.bottomSheetHeight = 270 + keyboardHeight
                        self.view.layoutIfNeeded()
                    })
                    self.view.updateConstraints()
                }

            }
        }
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
                        self.descriptionTextView.snp.removeConstraints()
                        self.bottomSheetView.snp.removeConstraints()
                    }
                }
            case .failure(let meassage):
                print("failure", meassage)
                
            }
        }
        
        self.blackViewOfBottomSheet.removeFromSuperview()
        self.bottomSheetView.removeFromSuperview()
        
    }
    
    @objc private func handleFloatingButtonClearViewDismiss(){
        self.floatingButton.image = UIImage(named: "floating-button")
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.frame.origin.y = self.floatingButton.frame.origin.y - 10 - self.collectionView.fs_height + 20
            self.collectionView.alpha = 0
        }, completion: { finished in
            self.collectionView.removeFromSuperview()
            self.clearViewOfFloatingButton.removeFromSuperview()
        })
        isCollectionViewShowing = !isCollectionViewShowing
    }
    
    @objc private func tapCancelButtonInDatePicker(){
        blackViewOfDatePicker.removeFromSuperview()
        datePickerBackgroundView.removeFromSuperview()
        titleTextFieldInBottomSheet.becomeFirstResponder()
    }
    
    @objc private func tapFinishButtonInDatePicker(){
        nowHour = DateFormat.shared.getHour(date: datePicker.date)
        nowMin = DateFormat.shared.getMinute(date: datePicker.date)
        timeLabel.text =  "\(nowHour):\(nowMin)"
        timeLabel.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        
        blackViewOfDatePicker.removeFromSuperview()
        datePickerBackgroundView.removeFromSuperview()
        titleTextFieldInBottomSheet.becomeFirstResponder()
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
            self.floatingButton.image = UIImage(named: "floating-button")
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionView.frame.origin.y = self.floatingButton.frame.origin.y - 10 - self.collectionView.fs_height + 20
                self.collectionView.alpha = 0
            }, completion: { finished in
                self.collectionView.removeFromSuperview()
                self.clearViewOfFloatingButton.removeFromSuperview()
            })
        }else {
            //컬렉션 뷰 추가
            self.tableView.addSubview(clearViewOfFloatingButton)
            self.tableView.addSubview(collectionView)
            self.tableView.bringSubviewToFront(floatingButton)
            //컬렉션 뷰 위치 지정
            collectionView.frame.origin.x = floatingButton.frame.origin.x - (collectionView.fs_width-floatingButton.fs_width)
            collectionView.frame.origin.y = floatingButton.frame.origin.y - 10 - collectionView.fs_height + 15
            
            clearViewOfFloatingButton.snp.makeConstraints { make in
                make.left.right.top.bottom.equalTo(self.view)
            }

            collectionView.alpha = 0
            self.floatingButton.image = UIImage(named: "floating-button-touched")

            
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionView.frame.origin.y = self.floatingButton.frame.origin.y - 10 - self.collectionView.fs_height
                self.collectionView.alpha = 1
            }, completion: { finished in
            })
            
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
        dimmingView = UIView(frame: UIScreen.main.bounds)
        dimmingView.backgroundColor = UIColor.black
        dimmingView.alpha = 0
        view.addSubview(dimmingView)
    
        overlayViewController = MyPageViewController()
        overlayViewController?.view.frame = CGRect(x: view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        if let overlayViewController = overlayViewController {
            addChild(overlayViewController)
        }
        if let x = overlayViewController?.view {
            view.addSubview(x)
        }
        overlayViewController?.dimmingView = dimmingView
        
        UIView.animate(withDuration: 0.3) {
            self.overlayViewController?.view.frame = CGRect(x: 70, y: 0, width: self.view.frame.size.width - 70, height: self.view.frame.size.height)
            self.dimmingView.alpha = 0.5
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        if isCollectionViewShowing{
            tapFloatingButton()
        }
        tableView.endEditing(true)
    }
    
    @objc private func tapTimeLabel(){
        self.view.endEditing(true)
        self.view.addSubview(blackViewOfDatePicker)
        self.view.addSubview(datePickerBackgroundView)
        setDatePickerViewAutoLayout()
        if nowHour == "99" && nowMin == "99"{
            deleteButtonInDatePicker.isHidden = true
        }else{
            deleteButtonInDatePicker.isHidden = false
        }
        

    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        print("drawer black view의 handleTapGesture")
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayViewController?.view.frame = CGRect(x: self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.dimmingView.alpha = 0
        }) { (_) in
            self.overlayViewController?.removeFromParent()
            self.overlayViewController?.view.removeFromSuperview()
            self.dimmingView.removeFromSuperview()
        }
    }
    
    private func setBottomSheetAnimation(){
        
 
    }
    
    
    private func setExistArray(){
        existingColorArray.removeAll()
        for i in 0 ..< 6 {
            if todoArrayList[i].count > 0 {
                existingColorArray.append(i)
            }
        }
        
        if existingColorArray.isEmpty{
            nothingExistingView.isHidden = false
        }else{
            nothingExistingView.isHidden = true
        }
    }
    
    @objc private func tapBottomSheet(){
        bottomSheetView.endEditing(false)
    }
    
    private func setCircleButtonImage(){
        redCircleButton.setImage(UIImage(named: "red-circle"), for: .normal)
        yellowCircleButton.setImage(UIImage(named: "yellow-circle"), for: .normal)
        greenCircleButton.setImage(UIImage(named: "green-circle"), for: .normal)
        blueCircleButton.setImage(UIImage(named: "blue-circle"), for: .normal)
        pinkCircleButton.setImage(UIImage(named: "pink-circle"), for: .normal)
        purpleCircleButton.setImage(UIImage(named: "purple-circle"), for: .normal)
        
    }
    
    @objc private func tapDeleteButton(){
        nowHour = "99"
        nowMin = "99"
        timeLabel.text =  "미지정"
        timeLabel.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        blackViewOfDatePicker.removeFromSuperview()
        datePickerBackgroundView.removeFromSuperview()
        titleTextFieldInBottomSheet.becomeFirstResponder()
    }
    
    @objc private func didRecieveEndEditGroupName(){
        
        getPriorityName()
        tableView.reloadData()
    }
    
    private func searchTodo(date:Date) {
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
                            self.todoSortByDone(section: i)
                        }
                        self.setExistArray()
                        self.tableView.reloadData()
                    }
                }
            case .failure(let meassage):
                print("failure", meassage)
                
            }
        }
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
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
        floatingButton.frame = CGRect(x: floatingButton.frame.origin.x, y: floatingButton_y + offset, width: self.view.fs_width * 0.16, height: self.view.fs_width * 0.16)
        collectionView.frame = CGRect(x: collectionView.frame.origin.x, y: floatingButton_y + offset - 10 - self.collectionView.fs_height , width: collectionView.fs_width, height: collectionView.fs_height)
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
        cell.checkbox.image = todo.done ? Color.shared.getCheckBoxImage(colorNum: todo.color):UIImage(named: "checkbox")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.addSubview(blackViewOfBottomSheet)
        self.view.addSubview(bottomSheetView)
        setBottomSheetAutoLayout()
        
        let todo:Todo = todoArrayList[existingColorArray[indexPath.section]][indexPath.row]
        
        //bottom sheet 내부 컬러바 색상 설정
        colorBarViewInBottomsheet.backgroundColor = Color.shared.UIColorArray[todo.color-1]
        //날짜 라벨 텍스트 색상 설정
        dateLabelInBottomSheet.textColor = Color.shared.UIColorArray[todo.color-1]
        //title text field에 해당 title로 설정
        titleTextFieldInBottomSheet.text = todo.title
        
        //desctiption이 있을때, 없을 때 설정
        if todo.description.count > 0{
            descriptionTextView.text = todo.description
            descriptionTextView.textColor = .black
            
            let size = CGSize(width: descriptionTextView.bounds.width, height: .infinity)
            let newSize = descriptionTextView.sizeThatFits(size)
            print(newSize)
            guard let lineHeight = descriptionTextView.font?.lineHeight else {return}
            print("size: \(newSize.height/lineHeight)")
            if newSize.height/lineHeight < 6 {
                descriptionTextView.snp.makeConstraints({ make in
                    descriptionTextViewHeightConstraint = make.height.equalTo(newSize.height)
                })
//                self.bottomSheetHeightConstraint?.constraint.update(offset: self.bottomSheetHeight + newSize.height - (lineHeight+24))
                print("in did select")
                descriptionTextView.invalidateIntrinsicContentSize()
                view.updateConstraints()
                view.layoutIfNeeded()
            }else{
                descriptionTextView.snp.makeConstraints { make in
                    descriptionTextViewHeightConstraint = make.height.equalTo(24 + lineHeight * 4)
                }
//                self.descriptionTextViewHeightConstraint?.constraint.update(offset: 24 + lineHeight * 4)
//                self.bottomSheetHeightConstraint?.constraint.update(offset: self.bottomSheetHeight + (24 + lineHeight * 4) - (lineHeight+24))
                descriptionTextView.invalidateIntrinsicContentSize()
                view.layoutIfNeeded()
            }
            
        }else{
            descriptionTextView.text = textviewPlaceholder
            descriptionTextView.textColor = .gray
            
            descriptionTextView.snp.makeConstraints { make in
                guard let lineHeight = descriptionTextView.font?.lineHeight else {
                    descriptionTextViewHeightConstraint = make.height.equalTo(41)
                    return
                }
                descriptionTextViewHeightConstraint = make.height.equalTo((lineHeight)+24)
            }
        }
        
        //설정된 시간이 있을 때, 없을 때 설정
        let time = todo.time
        nowHour = String(time.prefix(2))
        nowMin = String(time.suffix(2))
        if time == "9999"{
            timeLabel.text = "미지정"
            timeLabel.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        }else{
            if let time = Int(time){
                if time >= 1200 {
                    timeLabel.text = "오후 \(nowHour):\(nowMin)"
                }else {
                    timeLabel.text = "오전 \(nowHour):\(nowMin)"
                }
            }
            timeLabel.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
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
//        setBottomSheetAnimation()
    }
    
}

//calendar delegate, datasource
extension TodoMainViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, numberOfRowsInMonth month: Int) -> Int {
            // 원하는 줄 수를 반환합니다. 예를 들어 5 줄로 표시하려면 5를 반환합니다.
        
            return 5
        }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let nowDate = calendarView.currentPage
        dateLabel.text = DateFormat.shared.getdateLabelString(date: nowDate)
        calendarView.select(nowDate)
        searchTodo(date: nowDate)
        dayLabel.text = DateFormat.shared.getDay(date: nowDate)
        weekdayLabel.text = DateFormat.shared.getWeekdayInKorean(date: nowDate)
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
        let diff = calendarView.fs_height - bounds.height

        calendarBackgroundView.fs_height = calendarBackgroundView.fs_height - diff
        tableView.tableHeaderView?.fs_height = tableView.tableHeaderView!.fs_height - diff
        calendarView.fs_height = bounds.height
        self.view.layoutIfNeeded()
        
        if diff > 0 {
            Timer.scheduledTimer(withTimeInterval: 0.07 , repeats: false) { timer in
                self.tableView.reloadData()
            }
        }else {
            Timer.scheduledTimer(withTimeInterval: 0.03 , repeats: false) { timer in
                self.tableView.reloadData()
            }
        }




    }
    
    
    
}
extension TodoMainViewController:FSCalendarDataSource{
}

//collection view delegate, datasource
extension TodoMainViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = DateFormat.shared.getYearMonthDay(date: calendarView.selectedDate!)
        var index = 0
        if let x = todoArrayList[indexPath.row].firstIndex { todo in
            todo.done == true
        }{
            index = x
        }else {
            index = todoArrayList[indexPath.row].count
        }
        todoArrayList[indexPath.row].insert(Todo(year: date[0] , month: date[1], day: date[2], title: "", done: false, isNew: true, writer: "", color: indexPath.row + 1, id: 0, time: "0000", description: ""), at: index)
        setExistArray()
        tableView.reloadData()
        
        //todo 작성 시에 뒤에 깔리는 투명한 뷰. 작성 도중에 셀이 눌리지 않고 다른 투두 완료가 불가하도록 만듦
        tableView.addSubview(clearViewForWritingTodo)
        clearViewForWritingTodo.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.view)
        }
        
        tapFloatingButton()
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
        let size = CGSize(width: textView.bounds.width, height: .infinity)
        let newSize = textView.sizeThatFits(size)
        guard let lineHeight = textView.font?.lineHeight else {return}
        print(newSize)
        if newSize.height/lineHeight < 6 {
            self.descriptionTextViewHeightConstraint?.constraint.update(offset: newSize.height)
            self.bottomSheetHeightConstraint?.constraint.update(offset: self.bottomSheetHeight + newSize.height - (lineHeight+24))
            textView.invalidateIntrinsicContentSize()
            view.layoutIfNeeded()
        }
    }
    
    
}
extension TodoMainViewController:UITextFieldDelegate{
    
}

extension TodoMainViewController: TodoTableViewCellDelegate {
    
    func writeNothing(section: Int, row: Int) {
        todoArrayList[section].remove(at: row)
        setExistArray()
        tableView.reloadData()
    }
    
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
extension TodoMainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view == dimmingView{
            print("dimming")
        }
    
        return touch.view == tableView || touch.view == tableView.tableHeaderView || touch.view == calendarBackgroundView || touch.view == tableView.tableFooterView
    }
    
}
