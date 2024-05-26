import AVFoundation
import UIKit

class ViewController: UIViewController {
    let videoCapture = VideoCapture()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var pointsLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupVideoPreview()

        videoCapture.predictor.delegate = self
    }

    private func setupVideoPreview() {
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)

        guard let previewLayer = previewLayer else { return }

        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame

        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.red.cgColor
    }
}

extension ViewController: PredictorDelegate {
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        if confidence >= 0.9 {
            print(action)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {}
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

//
// class CameraViewController: UIViewController {
//    private var cameraView: CameraPreview { view as! CameraPreview }
//    private var cameraFeedSession: AVCaptureSession?
//
//    override func loadView() {
//        view = CameraPreview()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        do {
//            if cameraFeedSession == nil {
//                try setupAVSession(
//                    position: nil
//                )
//                cameraView.previewLayer.session = cameraFeedSession
//                cameraView.previewLayer.videoGravity = .resizeAspectFill
//            }
//
//            DispatchQueue.main.async {
//                self.cameraFeedSession?.startRunning()
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        cameraFeedSession?.stopRunning()
//        super.viewWillDisappear(animated)
//    }
//
//    func setupAVSession(
//        position: AVCaptureDevice.Position?
//    ) throws {
//        guard let videoDevice = AVCaptureDevice.default(
//            .builtInWideAngleCamera,
//            for: .video,
//            position: position ?? .front
//        )
//        else {
//
//            return
//        }
//
//        guard let deviceInput = try? AVCaptureDeviceInput(
//            device: videoDevice
//        ) else {
//
//            return
//        }
//
//        let session = AVCaptureSession()
//        session.beginConfiguration()
//        session.sessionPreset = AVCaptureSession.Preset.high
//
//        // Add a video input.
//        guard session.canAddInput(deviceInput) else {
//
//            return
//        }
//        session.addInput(deviceInput)
//
//        //        let dataOutput = AVCaptureVideoDataOutput()
//        //        if session.canAddOutput(dataOutput) {
//        //            session.addOutput(dataOutput)
//        //            // Add a video data output.
//        //            dataOutput.alwaysDiscardsLateVideoFrames = true
//        //            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
//        //        } else {
//        //
//        //        }
//        session.commitConfiguration()
//        cameraFeedSession = session
//    }
// }
