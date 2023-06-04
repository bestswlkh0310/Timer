import SwiftUI

struct ContentView: View {
    @State private var timeRemaining = 0
    @State private var isTimerRunning = false
    @State private var selectedTime = 0
    
    @State private var isAlertPresented = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let timeOptions = [5, 10, 15, 20, 25]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("타이머에요")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if !isTimerRunning {
                Picker("시간을 선택하세요", selection: $selectedTime) {
                    ForEach(0..<timeOptions.count) { index in
                        Text("\(timeOptions[index]) 분")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }
            
            Text("\(timeRemaining) 분")
                .font(.title)
                .fontWeight(.bold)
            
            if isTimerRunning {
                Button(action: {
                    stopTimer()
                }) {
                    Text("쓰답!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            } else {
                Button(action: {
                    startTimer()
                }) {
                    Text("ㄱㄱ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
            
            Button(action: {
                resetTimer()
            }) {
                Text("리셋")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    adjustTime(by: -60)
                }) {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    adjustTime(by: 60)
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("끝!"), message: Text("아쉽네용"), dismissButton: .default(Text("확인")))
        }
        .onReceive(timer) { _ in
            if isTimerRunning && timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 && isTimerRunning {
                stopTimer()
                isAlertPresented = true
            }
        }
        .onAppear {
            resetTimer()
        }
    }
    
    func startTimer() {
        if selectedTime > 0 {
            timeRemaining = selectedTime * 60
            isTimerRunning = true
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
    }
    
    func resetTimer() {
        timeRemaining = 0
        isTimerRunning = false
    }
    
    func adjustTime(by seconds: Int) {
        if !isTimerRunning {
            timeRemaining += seconds
            if timeRemaining < 0 {
                timeRemaining = 0
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

