//
//  SkeletonModifier.swift
//  Skeleton Loading Animations
//
//  Created by Eren on 2025/4/22.
//

import SwiftUI

extension View {
    func skeleton(isRedacted: Bool) -> some View {
        self.modifier(SkeletonModifier(isRedacted: isRedacted))
    }
}

struct SkeletonModifier: ViewModifier {
    var isRedacted: Bool
    // view properties
    @State private var isAnimation: Bool = false
    @Environment(\.colorScheme) private var scheme
    func body(content: Content) -> some View {
        content
            .redacted(reason: isRedacted ? .placeholder: [])
            .overlay {
                if isRedacted {
                    GeometryReader {
                        let size = $0.size
                        let skeletonWidth = size.width / 2
                        let blurRadius = max(skeletonWidth / 2, 30)
                        let blurDiameter = blurRadius * 2
                        let minX = -(skeletonWidth + blurDiameter)
                        let maxX = size.width + skeletonWidth + blurDiameter
                        
                        Rectangle()
                            .fill(scheme == .dark ? .white : .black)// 填充灰色
                            .frame(width: skeletonWidth, height: size.height * 2)// 设置矩形尺寸
                            .frame(height: size.height)// 调整高度
                            .blur(radius: blurRadius)// 添加模糊效果
                            .rotationEffect(.init(degrees: rotation))// 旋转5度
                            .offset(x: isAnimation ? maxX : minX) // 控制位移动画
                    }
                    .mask {
                        content.redacted(reason: .placeholder)
                    }
                    .blendMode(.softLight)
                    .task {// 当视图出现时
                        guard !isAnimation else { return }
                        withAnimation(animation) {
                            isAnimation = true
                        }
                    }
                    .onDisappear {
                        /// Stopping Animation
                        isAnimation = false
                    }
                    .transaction {// 处理动画事务
                        if $0.animation != animation {// 如果当前动画不是我们指定的动画
                            $0.animation = .none// 则禁用其他动画效果
                        }
                    }
                }
            }
        
        var rotation: Double {
            return 5
        }
        
        var animation: Animation {
            .easeInOut(duration: 1.5).repeatForever(autoreverses: false)
        }
    }
    
    #Preview {
        ContentView()
    }
}
