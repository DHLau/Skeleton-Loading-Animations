//
//  SkeletonView.swift
//  Skeleton Loading Animations
//
//  Created by Alan on 2025/4/22.
//

import SwiftUI

struct SkeletonView<S: Shape>: View {
    var shape: S
    var color: Color
    init(_ shape: S, _ color: Color = .gray.opacity(0.3)) {
        self.shape = shape
        self.color = color
    }
    @State private var isAnimation: Bool = false
    var body: some View {
        shape
            .fill(color)
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let skeletonWidth = size.width / 2
                    let blurRadius = max(skeletonWidth / 2, 30)
                    let blurDiameter = blurRadius * 2
                    let minX = -(skeletonWidth + blurDiameter)
                    let maxX = size.width + skeletonWidth + blurDiameter
                    
                    Rectangle()
                        .fill(.gray)// 填充灰色
                        .frame(width: skeletonWidth, height: size.height * 2)// 设置矩形尺寸
                        .frame(height: size.height)// 调整高度
                        .blur(radius: blurRadius)// 添加模糊效果
                        .rotationEffect(.init(degrees: rotation))// 旋转5度
                        .blendMode(.softLight)// 设置混合模式
                        .offset(x: isAnimation ? maxX : minX) // 控制位移动画
                }
            }
            .clipShape(shape)// 使用传入的形状裁剪整个视图
            .compositingGroup()// 将所有效果组合在一起进行渲染
            .onAppear {// 当视图出现时
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
    
    var rotation: Double {
        return 5
    }
    
    var animation: Animation {
        .easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    }
}

#Preview {
    @Previewable
    @State var isTapped: Bool = false
    SkeletonView(.circle)
        .frame(width: 100, height: 100)
        .onTapGesture {
            withAnimation(.smooth) {
                isTapped.toggle()
            }
        }
        .padding(.bottom, isTapped ? 15 : 0)
}
