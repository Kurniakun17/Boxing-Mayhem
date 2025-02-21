
import AVFoundation
import SwiftUI
import UIKit

class ViewController: UIViewController {
    var gameService: GameService?
    let videoCapture = VideoCapture()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var pointsLayer = CAShapeLayer()
    var actionTimer: DispatchSourceTimer?
    var actionPending: String?
    var lastActionTime: Date = .init(timeIntervalSince1970: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupVideoPreview()

        videoCapture.predictor.delegate = self
    }

    private func setupVideoPreview() {
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
//
        guard let previewLayer = previewLayer else { return }
//
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = CGRect(x: 0.0, y: Device.height - 180, width: 320, height: 180)
        previewLayer.connection?.videoRotationAngle = 180

//        Dots Hand
        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.red.cgColor
    }

    private func performPendingAction() {}
}

extension ViewController: PredictorDelegate {
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        if confidence >= 0.9 {
            DispatchQueue.main.async {
                print(action)
                self.gameService?.updatePlayerState(newState: action)
//                Pause for 1 seconds
//                self.videoCapture.pauseCaptureSecssion()
            }
        }
    }

    func predictor(_ predictor: Predictor, didFindRecognizedPoints points: [CGPoint]) {
        guard let previewLayer = previewLayer else { return }

        let convertedPoints = points.map {
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }

        let combinedPath = CGMutablePath()

        for point in convertedPoints {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }

        pointsLayer.path = combinedPath

        DispatchQueue.main.async {
            self.pointsLayer.didChangeValue(for: \.path)
        }
    }
}
