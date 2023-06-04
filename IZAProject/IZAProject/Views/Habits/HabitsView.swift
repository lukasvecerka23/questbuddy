//
//  HabitsView.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 27.05.2023.
//

import SwiftUI

struct HabitsView: View {
    @Binding var showMenu: Bool
    @State var showDatePicker = false
    @State var showHabitSheet = false
    @State var showHabitDetailSheet = false
    @State var selectedHabit: Habit? = nil
    @State var selectedTimeOfDay: TimeOfDay = .allday
    @ObservedObject var habitsModel: HabitsModel = HabitsModel.shared
    @ObservedObject var userModel: UserModel = UserModel.shared
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack{
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer().frame(height: 70)
                
                // Date selection
                HStack{
                    Text("\(habitsModel.selectedDate, formatter: dateFormatter)")
                        .padding()
                        .font(Font.custom("Poppins-Bold", size: 24))
                        .foregroundColor(.white)
                    
                    Button(action: { self.showDatePicker = true }) {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("Aqua"))
                    }
                }
                
                // List of day time
                ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(TimeOfDay.allCases, id: \.self) { time in
                                        Button(action: {
                                            withAnimation {
                                                selectedTimeOfDay = time
                                            }
                                        }) {
                                            Text(time.stringValue)
                                                .frame(height: 40)
                                                .padding(.horizontal)
                                                .background(selectedTimeOfDay == time ? Color("GrayLight") : Color.clear)
                                                .foregroundColor(selectedTimeOfDay == time ? Color("Aqua") : Color.white.opacity(0.8))
                                                .cornerRadius(20)
                                                .font(Font.custom("Poppins-Regular", size: 16))
                                                
                                        }
                                    }
                                }
                            }
                
                // List of habits based on choosed time of day
                TabView(selection: $selectedTimeOfDay) {
                                ForEach(TimeOfDay.allCases, id: \.self) { time in
                                    if let filteredHabits = habitsModel.filteredHabits[time]{
                                        
                                        // Nothing found
                                        if filteredHabits.isEmpty{
                                            VStack{
                                                Spacer().frame(height: 100)
                                                Image("nothing")
                                                    .resizable()
                                                    .frame(width: 120, height: 120)
                                                    
                                                Text("Can't find any habits out there.\nLet's create new one!")
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(.white)
                                                    .font(Font.custom("Poppins-Light", size: 16))
                                                Spacer()
                                            }.opacity(0.9)
                                        } else {
                                            // List of habits
                                            ScrollView(.vertical, showsIndicators: false){
                                                    LazyVStack{
                                                        ForEach(filteredHabits){ habit in
                                                            Button(action: {
                                                                selectedHabit = habit
                                                                showHabitDetailSheet.toggle()
                                                            }){
                                                                    // Check circle
                                                                    HStack{
                                                                        Button(action: {
                                                                            if habit.isChecked {
                                                                                habitsModel.uncheckHabit(habit)
                                                                            }else
                                                                            {
                                                                                habitsModel.checkHabit(habit)
                                                                            }
                                                                        }){
                                                                            Image(systemName: habit.isChecked ? "checkmark.circle.fill" : "circle")
                                                                                .resizable()
                                                                                .frame(width: 35, height: 35)
                                                                                .foregroundColor(habit.isChecked ? Color("Aqua") : Color("GrayMid"))
                                                                        }
                                                                        .padding(.trailing)
                                                                        
                                                                        // Habit title
                                                                        Text(habit.title)
                                                                            .foregroundColor(Color("Aqua"))
                                                                            .opacity(habit.isChecked ? 0.6 : 1.0)
                                                                            .strikethrough(habit.isChecked)
                                                                            .font(Font.custom("Poppins-Bold", size: 20))
                                                                        
                                                                        Spacer()
                                                                        // Duration
                                                                        Text((habit.isChecked ? "\(habit.duration.duration)" : "0") + "/\(habit.duration.durationFormat)")
                                                                            .foregroundColor(.white)
                                                                            .opacity(habit.isChecked ? 0.6 : 1.0)
                                                                            .strikethrough(habit.isChecked)
                                                                            .font(Font.custom("Poppins-Light", size: 16))
                                                                    }.frame(maxWidth: .infinity)
                                                                        .padding()
                                                                        .background(Color("GrayLight"))
                                                                        .cornerRadius(30)
                                                                    
                                                                }.sheet(isPresented: $showHabitDetailSheet){
                                                                    NavigationView{
                                                                        HabitDetailView(habit: $selectedHabit)
                                                                    }.presentationDetents([.fraction(0.5)])
                                                                }
                                                        }
                                                    
                                                    }
                                                    .padding()
                                            }
                                            
                                        }
                                    }
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                Spacer()
            }.sheet(isPresented: $showDatePicker){
                VStack {
                    // Calendar for picking date
                    Spacer()
                    DatePicker("Select Date", selection: $habitsModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .accentColor(Color("Aqua"))
                                .colorScheme(.dark)
                        }
                        .background(Color("GrayDark"))
                        .presentationDetents([.fraction(0.5)])
            }
            .toolbar {
                // Points
                ToolbarItem(placement: .navigationBarLeading){
                    HStack {
                            Text(userModel.user?.points.pointsFormat ?? "0")
                                    .font(Font.custom("Poppins-Bold", size: 18))
                                    .foregroundColor(.white)
                                Image(systemName: "diamond.fill")
                                    .foregroundColor(Color("Aqua"))
                                    .imageScale(.small)
                            }
                            .padding()
                            .frame(height: 30)
                            .background(Color("GrayLight"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                }
                
                ToolbarItem(placement: .principal){
                    Text("Habits")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Bold", size: 30))
                }

                // Menu icon
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        withAnimation{
                            showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            // Button for adding habit
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {self.showHabitSheet = true}){
                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color("Aqua"))
                                            .background(.black)
                                            .cornerRadius(50)
                                            .padding()
                    }
                }
                Spacer().frame(height:150)
            }.sheet(isPresented: $showHabitSheet){
                NavigationView{
                    AddNewHabitView()
                }
            }
            
           
        }

    }
}
