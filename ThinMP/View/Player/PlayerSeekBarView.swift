//
//  PlayerSeekBarView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 再生位置のスライダーと、その下の経過 / 全体の時間
struct PlayerSeekBarView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer

    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        Slider(value: $musicPlayer.currentSecond, in: 0 ... musicPlayer.durationSecond, step: 1, onEditingChanged: { editing in
            if editing {
                musicPlayer.beginSeek()
            } else {
                musicPlayer.endSeek()
            }
        })
        .frame(height: StyleConstant.button)
        .padding(.horizontal, isPad ? 40 : 30)
        .accentColor(Color(.label))
        HStack {
            SecondaryTextView(Self.format(musicPlayer.currentSecond)).frame(width: 50, height: 20).padding(.leading, 40)
            Spacer()
            SecondaryTextView(Self.format(musicPlayer.durationSecond)).frame(width: 50, height: 20).padding(.trailing, 40)
        }
    }

    /// 毎秒呼ばれるので formatter は使い回す
    private static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()

        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]

        return formatter
    }()

    /// "mm:ss"
    private static func format(_ time: TimeInterval) -> String {
        if time < 1 {
            return "00:00"
        }

        return timeFormatter.string(from: time) ?? "00:00"
    }
}
