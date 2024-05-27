//
//  ContentView.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 21/05/24.
//

// import AVFoundation
// import SwiftUI

// struct VideoPreviewView: UIViewRepresentable {
//    let videoCapture = VideoCapture()
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        videoCapture.startCaptureSession()
//        let previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
//        previewLayer.frame = view.bounds
//        view.layer.addSublayer(previewLayer)
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // Handle any updates if needed
//    }
// }

import AVFoundation
import SwiftUI
import UIKit

//
// final class CameraPreview: UIView {
//    var previewLayer: AVCaptureVideoPreviewLayer {
//        layer as! AVCaptureVideoPreviewLayer
//    }
//
//    override class var layerClass: AnyClass {
//        AVCaptureVideoPreviewLayer.self
//    }
// }
//
// struct VideoPreviewView: UIViewControllerRepresentable {
////    let videoCapture = VideoCapture()
//
//    func makeUIViewController(context: Context) -> CameraViewController {
//        let view = CameraViewController()
//        return view
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
// }

// struct ContentView: View {
//    var body: some View {
//        VStack {
//            Text("Hello, Camera!")
//                .font(.largeTitle)
//                .padding()
//
//            // Add any other UI components here
//
//            VideoPreviewView()
//                .edgesIgnoringSafeArea(.all)
//        }
//    }
// }

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

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .frame(width: Device.width * 1.2, height: Device.height)
                    .position(bgLoc)
                    .scaledToFill()
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
                    .background(Color.gray.opacity(0.3))

                Button {
                    gameService.gameState = "start"
                    isGamePlayed = true
                } label: {
                    Image("fight")

                }.onTapGesture {
                    withAnimation(Animation.spring(duration: 1)) {
                        scaleEffect(1.5)
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
