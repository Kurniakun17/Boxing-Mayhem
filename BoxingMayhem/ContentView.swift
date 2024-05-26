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
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
//        <#code#>
    }
}

struct ContentView: View {
    @StateObject var gameService = GameService()
    @StateObject var device = Device()

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
            Character(info: CharInfo.opponent, state: $gameService.opponentState, isFlipped: $gameService.opponentFlipped)
                .position(x: device.width/2, y: device.height/2 - (device.height/3))

            Character(info: CharInfo.player, state: $gameService.playerState, isFlipped: $gameService.playerFlipped)

//            Jab
            Button(action: {
                gameService.updatePlayerState(newState: "jab")
            }) {
                Text("Jab")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
            .disabled(gameService.playerState != "none" ? true : false)
            .padding(40)
            .background(.black)
            .font(.title)
            .cornerRadius(20)
            .position(x: UIScreen.main.bounds.width - 200, y: UIScreen.main.bounds.height - 200)

//            Hook
            Button(action: {
                gameService.updatePlayerState(newState: "hook")
            }) {
                Text("Hook")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
            .disabled(gameService.playerState != "none" ? true : false)
            .padding(40)
            .background(.black)
            .font(.title)
            .cornerRadius(20)
            .position(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 350)

//            Uppercut
            Button(action: {
                gameService.updatePlayerState(newState: "uppercut")
            }) {
                Text("uppercut")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
            .disabled(gameService.playerState != "none" ? true : false)
            .padding(40)
            .background(.black)
            .font(.title)
            .cornerRadius(20)
            .position(x: UIScreen.main.bounds.width - 300, y: UIScreen.main.bounds.height - 350)

            Text("State: " + gameService.playerState)
                .padding(40)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .background(.blue)
                .font(.title)
                .cornerRadius(20)
                .position(x: 200, y: 100)

            if gameService.playerHealth <= 0 || gameService.opponentHealth <= 0 {
                KnockedCount()
            }
        }
        .environmentObject(device)
        .environmentObject(gameService)
        .onAppear {
            print("Width: \(device.width)")
            print("Height: \(device.height)")
        }
//        .background(.blue)
//        NavigationLink {
//            VideoPreview()
//                .ignoresSafeArea(.all)
//        } label: {
//            Image("play.fill")
//                .resizable()
//                .frame(width: 50, height: 50)
//        }

//        VideoPreview()

//            .ignoresSafeArea(.all)
//                .rotationEffect(.degrees(90))
//                .background(.black)
    }
}

#Preview {
    ContentView()
}
