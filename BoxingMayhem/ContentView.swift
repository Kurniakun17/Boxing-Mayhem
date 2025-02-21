
import AVFoundation
import SwiftUI
import UIKit

struct VideoPreview: UIViewControllerRepresentable {
    @EnvironmentObject var gameService: GameService

    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.gameService = gameService
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
//        <#code#>
    }
}

struct ContentView: View {
    @StateObject var gameService = GameService()
    @State var bgLoc = CGPoint(x: Device.width / 2, y: Device.height / 2)
    @State var bgPosX = Device.width / 2 * 1.2
    @State var goToLeft = false
    @State var isGamePlayed = false
    @State var playScale = 1.0

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .frame(width: Device.width, height: Device.height)
                    .position(bgLoc)
                    .background(Color.blue.secondary)
                    .ignoresSafeArea(.all)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 15).repeatForever()) {
                            bgLoc = CGPoint(x: bgPosX, y: Device.height / 2)
                        }

                        Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
                            if goToLeft {
                                bgPosX = Device.width / 2 / 1.2
                            }
                        })
                    }

             

                VStack {}
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .background(Color.black.opacity(0.3))

                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .offset(y: -100)

                Button(action: {
                    isGamePlayed = true
                }) {
                    Image("play")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }

                .frame(width: 140, height: 72)
                .scaleEffect(x: CGFloat(playScale), y: CGFloat(playScale))
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2).repeatForever()) {
                        playScale = playScale == 1.0 ? 1.1 : 1.0
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isGamePlayed) {
            Game(isGamePlayed: $isGamePlayed)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
