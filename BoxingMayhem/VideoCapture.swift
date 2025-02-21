    //
    //  VideoCapture.swift
    //  BoxingMayhem
    //
    //  Created by Kurnia Kharisma Agung Samiadjie on 21/05/24.
    //

    import AVFoundation
    import Foundation

    class VideoCapture: NSObject {
        let captureSession = AVCaptureSession()
        let videoOutput = AVCaptureVideoDataOutput()

        let predictor = Predictor()
        private let sessionQueue = DispatchQueue(label: "sessionQueue")

        override init() {
            super.init()
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }

            captureSession.sessionPreset = AVCaptureSession.Preset.high
            captureSession.addInput(input)

            captureSession.addOutput(videoOutput)
            videoOutput.alwaysDiscardsLateVideoFrames = true
        }

        func startCaptureSession() {
            // Using dedicated serial queue for session management
            sessionQueue.async { [weak self] in
                guard let self = self else { return }
                self.captureSession.startRunning()
                self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDispatchQueue"))
            }
        }

        func pauseCaptureSession() {
            captureSession.stopRunning()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.captureSession.startRunning()
            }
        }
    }

    extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            predictor.estimation(sampleBuffer)
        }
    }
