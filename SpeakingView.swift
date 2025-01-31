import SwiftUI

struct SpeakingView: View {
    @StateObject private var viewModel: SpeakingViewModel

    init(word: WordPair) {
        _viewModel = StateObject(wrappedValue: SpeakingViewModel(word: word))
    }

    var body: some View {
        VStack {
            Text("Say the following word in Korean:")
                .font(.headline)
                .padding()

            Text(viewModel.word.english)
                .font(.largeTitle)
                .padding()

            Button(action: {
                if viewModel.isRecording {
                    viewModel.stopRecording()
                } else {
                    viewModel.startRecording()
                }
            }) {
                HStack {
                    if viewModel.isRecording {
                        Image(systemName: "stop.circle")
                    } else {
                        Image(systemName: "mic.circle")
                    }
                    Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.isRecording ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView("Transcribing...")
                    .padding()
            }

            if !viewModel.resultText.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recognized:")
                        .font(.subheadline)
                        .bold()

                    Text(viewModel.resultText)
                        .font(.body)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)

                    if let correct = viewModel.isCorrect {
                        Text(correct ? "Correct!" : "Incorrect.")
                            .foregroundColor(correct ? .green : .red)
                            .font(.headline)
                    }
                }
                .padding()
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct SpeakingView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakingView(word: WordPair(korean: "자동차", english: "Car"))
    }
}