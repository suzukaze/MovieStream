//
//  StringUtils.swift
//  MovieStream
//
//  Created by HiroeJun on 2025/07/03.
//

import Foundation

final class StringUtils {
    static func splitFilename(_ filename: String) -> (name: String, ext: String)? {
        let parts = filename.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
        guard parts.count == 2 else {
            return nil
        }
        
        return (String(parts[0]), String(parts[1]))
    }
    
    // 時間を "hh:mm:ss" 形式で返す
    static func timeString(from seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%02d:%02d", minutes, secs)
        }
    }
}
