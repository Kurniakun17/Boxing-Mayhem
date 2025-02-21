//
//  Predictor.swift
//  BoxingMayhem
//
//  Created by Kurnia Kharisma Agung Samiadjie on 21/05/24.
//
import Foundation
import Vision

typealias BoxingClassifier = BoxingHand_Refined

protocol PredictorDelegate: AnyObject {
    func predictor(_ predictor: Predictor, didFindRecognizedPoints points: [CGPoint])
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double)
}

class Predictor: ObservableObject {
    weak var delegate: PredictorDelegate?

    let predictionWindowSize = 30
    var posesWindow: [VNHumanHandPoseObservation] = []

    private var lastActionTime: Date = .init()
    private var minimumActionInterval: TimeInterval = 1.0
    private var confidenceThreshold: Double = 0.9
    private var lastAction: String?
    private var actionCounter: Int = 0
    private var maxConsecutiveActions: Int = 3
    
    init() {
        posesWindow.reserveCapacity(predictionWindowSize)
    }

    func estimation(_ sampleBuffer: CMSampleBuffer) {
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)

        let request = VNDetectHumanHandPoseRequest(completionHandler: handPoseHandler)

        do {
            try requestHandler.perform([request])
        } catch {
            print("Error: \(error)")
        }
    }

    func handPoseHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNHumanHandPoseObservation] else { return }

        for observation in observations {
            processObservation(observation)
        }

        if let result = observations.first {
            storeObservation(result)
        }

        labelActionType()
    }

    func labelActionType() {
        guard let boxingClassifier = try? BoxingClassifier(configuration: MLModelConfiguration()),
              let poseMultiArray = prepareInputWithObservation(posesWindow),
              let predictions = try? boxingClassifier.prediction(poses: poseMultiArray)
        else {
            return
        }

        let label = predictions.label
        let confidence = predictions.labelProbabilities[label] ?? 0.0

        // Check if enough time has passed since last action
        let currentTime = Date()
        let timeSinceLastAction = currentTime.timeIntervalSince(lastActionTime)

        // Implement action filtering logic
        if confidence >= confidenceThreshold, timeSinceLastAction >= minimumActionInterval {
            // Check for repetitive actions
            if label == lastAction {
                actionCounter += 1
                if actionCounter >= maxConsecutiveActions {
                    // Increase cooldown for repetitive actions
                    return
                }
            } else {
                actionCounter = 0
            }

            // Update state and notify delegate
            lastAction = label
            lastActionTime = currentTime
            delegate?.predictor(self, didLabelAction: label, with: confidence)
        }
    }

    // Add method to adjust sensitivity
    func adjustSensitivity(confidenceThreshold: Double = 0.7,
                           cooldownInterval: TimeInterval = 1.0,
                           maxConsecutive: Int = 3)
    {
        self.confidenceThreshold = confidenceThreshold
        minimumActionInterval = cooldownInterval
        maxConsecutiveActions = maxConsecutive
    }

    func prepareInputWithObservation(_ observations: [VNHumanHandPoseObservation]) -> MLMultiArray? {
        let numAvailableFrames = observations.count
        let observationsNeeded = 30
        var multiArrayBuffer = [MLMultiArray]()

        for frameIndex in 0 ..< min(numAvailableFrames, observationsNeeded) {
            let pose = observations[frameIndex]
            do {
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArrayBuffer.append(oneFrameMultiArray)
            } catch {
                continue
            }
        }

        if numAvailableFrames < observationsNeeded {
            for _ in 0 ..< (observationsNeeded - numAvailableFrames) {
                do {
                    let oneFrameMultiArray = try MLMultiArray(shape: [1, 3, 21], dataType: .double)
                    try resetMultiArray(oneFrameMultiArray)
                    multiArrayBuffer.append(oneFrameMultiArray)
                } catch {
                    continue
                }
            }
        }

        return MLMultiArray(concatenating: [MLMultiArray](multiArrayBuffer), axis: 0, dataType: .float)
    }

    func resetMultiArray(_ predictionWindow: MLMultiArray, with value: Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }

    func storeObservation(_ observation: VNHumanHandPoseObservation) {
        if posesWindow.count >= predictionWindowSize {
            posesWindow.removeFirst()
        }

        posesWindow.append(observation)
    }

    func processObservation(_ observation: VNHumanHandPoseObservation) {
        do {
            let recognizedPoints = try observation.recognizedPoints(forGroupKey: .all)

            var displayedPoints = recognizedPoints.map {
                CGPoint(x: $0.value.x, y: 1 - $0.value.y)
            }

            delegate?.predictor(self, didFindRecognizedPoints: displayedPoints)
        } catch {
            print("Error Finding recognizedPoints")
        }
    }
}
