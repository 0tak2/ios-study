//
//  ReminderViewController.swift
//  Today
//
//  Created by 임영택 on 12/18/24.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder {
        didSet {
            onChange(reminder)
        }
    }
    var workingReminder: Reminder
    var isAddingNewReminder = false
    var onChange: (Reminder) -> Void
    private var dataSource: DataSource!
    
    init(reminder: Reminder, onChange: @escaping (Reminder) -> Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange // init이 종료되고도 클로져가 실행될 수 있도록 인자 정의에 @escaping을 붙여준다.
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection // TODO: Review UICollectionView to learn about other ways to display headers in collection views
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    /**
     인터페이스 빌더는 뷰 컨트롤러를 아카이브 바이너리로 저장하며, 이로부터 뷰를 초기화하려면
     다음과 같은 `init(coder:)` 이니셜라이저를 호출하게 되어 required로 되어있음
     
     다만 이 뷰 컨트롤러는 직접 다른 뷰 컨트롤러에서 초기화할 것이기 때문에 이 이니셜라이저로
     초기화되지 않도록 구현
     */
    required init?(coder: NSCoder) {
        fatalError("이 뷰 컨트롤러는 init(reminder:)만을 이용해서 초기화되어야 함")
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case(_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case(.title, .editableText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case(.date, .editableDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case(.notes, .editableText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
        default:
            fatalError("이 조합 (섹션, 로우)은 예상되지 않았습니다")
        }
        
        cell.tintColor = .todayPrimaryTint
    }
    
    @objc func didCancelEdit() {
        workingReminder = reminder // 작업 내용 초기화
        setEditing(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            // deque?
            // 리스트의 수는 아주 많을 수 있지만, 실제 UI 오브젝트는 화면에 표시되어야 하는 정도만 메모리에 있으면 된다.
            // 시스템은 큐를 두어 필요한 모든 셀을 생성하지 않고, 필요에 따라 셀을 만들고 재사용한다.
        })
        
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        navigationItem.title = NSLocalizedString("Reminder", comment: "ReminderViewController의 타이틀")
        navigationItem.rightBarButtonItem = editButtonItem // editButtonItem은 UIViewController에 정의된 프로퍼티. isEditing, setEditing 등도 이미 정의되어 있다.
        
        updateSnaphostForViewing()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            prepareForEditing()
        } else {
            if isAddingNewReminder {
                onChange(workingReminder)
            } else {
                prepareForViewing()
            }
        }
    }
    
    private func updateSnaphostForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .notes])
        snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editableDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editableText(reminder.notes)], toSection: .notes)
        dataSource.apply(snapshot)
    }
    
    private func updateSnaphostForViewing() {
        var snaphost = Snapshot()
        snaphost.appendSections([.view])
        snaphost.appendItems([Row.header(""), Row.title, Row.date, Row.time, Row.notes], toSection: .view)
        dataSource.apply(snaphost)
    }
    
    private func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        updateSnaphostForEditing()
    }
    
    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        
        if reminder != workingReminder { // could be compared because of comforming Equatable
            reminder = workingReminder
        }
        
        updateSnaphostForViewing()
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("섹션을 찾을 수 없었습니다")
        }
        return section
    }
}
