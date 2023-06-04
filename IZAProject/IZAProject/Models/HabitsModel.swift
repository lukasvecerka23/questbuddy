//
//  HabitsModel.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 29.05.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import Combine

struct Habit: Identifiable, Codable {
    var id: String
    var userId: String
    var title: String
    var timeOfDay: Int
    var frequency: Int
    var duration: Int
    var creationDate: Date
    var isChecked: Bool = false
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        self.userId = document.get("userId") as? String ?? ""
        self.title = document.get("title") as? String ?? ""
        self.creationDate = (document.get("creationDate") as? Timestamp)?.dateValue() ?? Date()
        self.timeOfDay = document.get("timeOfDay") as? Int ?? 0
        self.frequency = document.get("frequency") as? Int ?? 0
        self.duration = document.get("duration") as? Int ?? 0
    }
}

struct HabitLog: Identifiable, Codable {
    var id: String
    var userId: String
    var habitId: String
    var dateChecked: Date
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        self.userId = document.get("userId") as? String ?? ""
        self.habitId = document.get("habitId") as? String ?? ""
        self.dateChecked = (document.get("dateChecked") as? Timestamp)?.dateValue() ?? Date()
    }
    
    init(id: String, userId: String, habitId: String, dateChecked: Date){
        self.id = id
        self.userId = userId
        self.habitId = habitId
        self.dateChecked = dateChecked
    }
}

class HabitsModel: ObservableObject{
    @Published var habits: [Habit] = []
    @Published var habitLogs: [HabitLog] = []
    @Published var filteredHabits: [TimeOfDay: [Habit]] = [:]
    
    // selected date and for filtering
    @Published var selectedDate: Date = Date()
    
    static var shared: HabitsModel = HabitsModel()
    
    private var db = Firestore.firestore()
    
    // Firestore listeners
    private var listenerHabit: ListenerRegistration?
    private var listenerHabitLog: ListenerRegistration?
    
    // pipelines
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
        fetchHabits()
        fetchHabitLog()
        
        // pipeline for filtering habits after change of date, habits or habitlog
        Publishers.CombineLatest3($selectedDate, $habits, $habitLogs)
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .sink{[weak self] date, habits, habitLogs in
                self?.filterHabits()
            }
            .store(in: &cancellables)
        
        // pipeline for calculate completed duration statistic whenever habits or habitlog have changed
        Publishers.CombineLatest($habits, $habitLogs)
            .sink{ habits, habitLogs in
                let completedHabitsIds = habitLogs.map { $0.habitId }
                let completedHabits = habits.filter { completedHabitsIds.contains($0.id) }
                let completedDuration = completedHabits.reduce(0) { $0 + $1.duration }
                UserModel.shared.userStats.completedDuration = completedDuration
            }
            .store(in: &cancellables)
    }
    
    // setup loading data
    func loadAllData(){
        self.selectedDate = Date()
        self.fetchHabits()
        self.fetchHabitLog()
    }
    
    func fetchHabits(){
        listenerHabit?.remove()
        listenerHabit = db.collection("habits")
            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .addSnapshotListener{ (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    return
                }
                // add created habits statistic
                UserModel.shared.userStats.createdHabits = documents.count
                
                self.habits = documents.compactMap{ document in
                    return Habit(document: document)
                }
                
                self.filterHabits()
            }
        
    }
    
    func fetchHabitLog(){
        listenerHabitLog?.remove()
        listenerHabitLog = db.collection("habitLog")
            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .addSnapshotListener{ (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else{
                    return
                }
                // add completed habit statistic
                UserModel.shared.userStats.completedHabits = documents.count
                
                self.habitLogs = documents.compactMap{ document in
                    return HabitLog(document: document)
                }
            }
    }
    
    func filterHabits(){
        let selectedDay = Calendar.current.startOfDay(for: self.selectedDate)
        for time in TimeOfDay.allCases{
            // all day contain all habits
            if time == .allday{
                filteredHabits[.allday] = habits.compactMap{habit in
                    var mutableHabit = habit
                    mutableHabit.isChecked = habitLogs.contains(where: { $0.habitId == habit.id && Calendar.current.isDate($0.dateChecked, inSameDayAs: selectedDay) })
                    return shouldPerform(habit: habit) ? mutableHabit : nil
                }
                continue
            }
            // each time of day
            filteredHabits[time] = habits.compactMap { habit in
                var mutableHabit = habit
                mutableHabit.isChecked = habitLogs.contains(where: { $0.habitId == habit.id && Calendar.current.isDate($0.dateChecked, inSameDayAs: selectedDay) })
                return (habit.timeOfDay == time.rawValue && shouldPerform(habit: habit)) ? mutableHabit : nil
            }
        }
    }
    
    func clearModel(){
        listenerHabit?.remove()
        listenerHabitLog?.remove()
        habits = []
        habitLogs = []
        filteredHabits = [:]
    }
    
    func checkHabit(_ habit: Habit) {
        let selectedDay = Calendar.current.startOfDay(for: self.selectedDate)
        let today = Calendar.current.startOfDay(for: Date())

        // can check only past or today habits not future habits
        guard selectedDay <= today else {
            return
        }
        
        let addedPoints = habit.duration
    
        // update user points
        UserModel.shared.updateUserPoints(points: addedPoints)
        
        let habitLog = HabitLog(id: UUID().uuidString, userId: Auth.auth().currentUser?.uid ?? "", habitId: habit.id, dateChecked: selectedDay)
        
        do {
            try db.collection("habitLog").document(habitLog.id).setData(from: habitLog)
        } catch let error {
            print("Error writing habitLog to Firestore: \(error.localizedDescription)")
        }
    }

    func uncheckHabit(_ habit: Habit) {
        let selectedDay = Calendar.current.startOfDay(for: self.selectedDate)

        let addedPoints = habit.duration
        
        // Points can't be negative
        if let userPoints = UserModel.shared.user?.points {
            if userPoints >= addedPoints{
                UserModel.shared.updateUserPoints(points: -addedPoints)
            }
        }
        
        
        if let habitLog = habitLogs.first(where: { $0.habitId == habit.id && Calendar.current.isDate($0.dateChecked, inSameDayAs: selectedDay) }) {
            db.collection("habitLog").document(habitLog.id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err.localizedDescription)")
                }
            }
        }
    }
    
    func createNewHabit(title: String, frequency: Int, timeOfDay: Int, duration: Int){
        guard !title.isEmpty, let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let habitData: [String: Any] = [
            "title": title,
            "timeOfDay": timeOfDay,
            "frequency": frequency,
            "duration": duration,
            "userId": userId,
            "creationDate": Calendar.current.startOfDay(for: Date())
        ]
        
        db.collection("habits").addDocument(data: habitData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            }
        }
    }
    
    func editHabit(habit: Habit){
        do {
                try db.collection("habits").document(habit.id).setData(from: habit, merge: true) { err in
                    if let err = err {
                        print("Error updating habit: \(err)")
                    }
                }
            } catch let error {
                print("Error encoding habit: \(error)")
        }
    }
    
    func deleteHabitAndLogs(habitId: String) {
            // Delete the habit
            db.collection("habits").document(habitId).delete() { err in
                if let err = err {
                    print("Error deleting habit: \(err)")
                } else {
                    // Then delete all logs of the habit
                    self.db.collection("habitLog")
                        .whereField("habitId", isEqualTo: habitId)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    document.reference.delete()
                                }
                            }
                        }
                }
            }
        }
    
    // Check if habit should be contained in the selected date
    func shouldPerform(habit: Habit) -> Bool {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: habit.creationDate)
        let toDate = calendar .startOfDay(for: selectedDate)
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate)
        let numberOfMonths = calendar.dateComponents([.month, .day], from: fromDate, to: toDate)
        guard let days = numberOfDays.day, let months = numberOfMonths.month, let dayOfMonth = numberOfMonths.day else {
            return false
        }

        // habits before creationDate
        if days < 0 || months < 0{
            return false
        }
        
        switch habit.frequency {
        case 0:
            return true
        case 1:
            return days % 7 == 0
        case 2:
            return months % 1 == 0 && dayOfMonth == 0
        default:
            return false
        }
    }
}
