//
//  FormatDisplay.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-06-24.
//

import Foundation

struct FormatDisplay {
  static func dist1(_ distance: Double) -> String {
    let distanceMeasurement = Measurement(value: distance, unit: UnitLength.kilometers)
    return FormatDisplay.dist2(distanceMeasurement)
  }
  
    static func dist2(_ distance: Measurement<UnitLength>) -> String {
    let formatter = MeasurementFormatter()
    formatter.numberFormatter.maximumFractionDigits = 3
    formatter.numberFormatter.numberStyle = .decimal
    formatter.unitOptions = .providedUnit
    formatter.unitStyle = MeasurementFormatter.UnitStyle.long
    return formatter.string(from: distance)
  }

    static func preciseRound(
        _ value: Double,
        precision: RoundingPrecision = .ones) -> Double
    {
        switch precision {
        case .ones:
            return round(value)
        case .tenths:
            return round(value * 10) / 10.0
        case .hundredths:
            return round(value * 100) / 100.0
        }
    }
    
    public enum RoundingPrecision {
        case ones
        case tenths
        case hundredths
    }
    
  
  static func time(_ seconds: Int) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    return formatter.string(from: TimeInterval(seconds))!
  }
  
  static func pace(distance: Measurement<UnitLength>, seconds: Int, outputUnit: UnitSpeed) -> String {
    let formatter = MeasurementFormatter()
    formatter.unitOptions = [.providedUnit] // 1
    let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
    let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
    return formatter.string(from: speed.converted(to: outputUnit))
  }
  
  static func date(_ timestamp: Date?) -> String {
    guard let timestamp = timestamp as Date? else { return "" }
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: timestamp)
  }
}
