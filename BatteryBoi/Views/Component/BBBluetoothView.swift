//
//  BBBluetoothView.swift
//  BatteryBoi
//
//  Created by Joe Barbour on 9/6/23.
//

import SwiftUI

struct BluetoothIcon: View {
    @State private var item:BluetoothObject?
    @State private var icon:String
    @State private var animation:Namespace.ID
    
    @Binding private var style:RadialStyle

    init(_ item:BluetoothObject?, style:Binding<RadialStyle>, animation:Namespace.ID) {
        self._item = State(initialValue: item)
        self._icon = State(initialValue: item?.type.icon ?? AppManager.shared.appDeviceType.icon)
        self._animation = State(initialValue: animation)
        
        self._style = style

    }
    
    var body: some View {
        HStack {
            ZStack {
                if self.item == nil || self.item?.battery.percent != nil {
                    RadialProgressMiniContainer(self.item, style: $style)
                    
                    Image(systemName: self.icon)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(self.style == .light ? Color("BatteryButton") : Color("BatterySubtitle"))
                        .padding(2)
                        .background(
                            Circle()
                                .fill(self.style == .light ? Color("BatteryTitle") : Color("BatteryButton"))
                                .blur(radius: 2)
                            
                        )
                        .matchedGeometryEffect(id: self.icon, in: animation)
                        .offset(x:12, y:12)
                    
                }
                else {
                    Image(systemName: self.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(self.style == .light ? Color("BatteryButton") : Color("BatterySubtitle"))
                        .padding(2)
                        .matchedGeometryEffect(id: item?.type.icon ?? "laptopcomputer", in: animation)
                    
                }

            }
            
            Spacer().frame(width:18)
            
        }
        
    }
    
}

struct BluetoothItem: View {
    @EnvironmentObject var manager:AppManager
    @EnvironmentObject var battery:BatteryManager

    @Binding var hover:Bool

    @State var item:BluetoothObject?
    @State var style:RadialStyle = .light
    @State private var isHovered = false

    @Namespace private var animation
    
    init(_ item:BluetoothObject?, hover:Binding<Bool>) {
        self._item = State(initialValue: item)
        self._hover = hover
        
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            BluetoothIcon(item, style: $style, animation: animation)
                .padding(.leading, 14)

            VStack(alignment: .leading, spacing: 1) {
                if let item = self.item {
                    Text(item.device ?? item.type.type.rawValue)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(self.style == .light ? Color("BatteryButton") : Color("BatteryTitle"))
                        .lineLimit(1)
                    
                    if self.hover == true {
                        Group {
                            if item.connected == .disconnected {
                                Text("BluetoothDisconnectedLabel".localise())
                            }
                            else {
                                if let percent = item.battery.percent {
                                    Text("AlertSomePercentTitle".localise([Int(percent)]))
                                }
                                else {
                                    Text("BluetoothInvalidLabel".localise())
                                }
                            }
                        }
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color("BatterySubtitle"))
                        .lineLimit(1)
                        
                    }
                    
                }
                else {
                    Text(AppManager.shared.appDeviceType.name)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(self.style == .light ? Color("BatteryButton") : Color("BatteryTitle"))
                        .lineLimit(1)
                    
                    if self.hover == true {
                        Text("AlertSomePercentTitle".localise([Int(battery.percentage)]))
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Color("BatterySubtitle"))
                            .lineLimit(1)
                        
                    }
                    
                }
                
            }
            
            Spacer(minLength: 0)
        }
        .frame(width: 156, height: 60)
        .background(
            ZStack {
                if self.style == .light {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color("BatteryTitle"))
                    
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.white.opacity(0.8), lineWidth: 1.0)
                } else {
                    // 1. Volumetric carved glass depth backing
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.black.opacity(self.isHovered ? 0.22 : 0.14))
                    
                    // 2. Liquid translucent body
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(self.isHovered ? 0.14 : 0.06))
                    
                    // 3. Cloudy shine gradient
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(self.isHovered ? 0.18 : 0.10),
                                    Color.white.opacity(self.isHovered ? 0.05 : 0.01)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // 4. Curved reflective streak highlight
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.12),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                        .frame(height: 25)
                        .offset(y: -12)
                        .blur(radius: 1.0)
                        .blendMode(.plusLighter)

                    // 5. Internal bottom shadow for carved 3D indentation
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.black.opacity(0.60), lineWidth: 1.5)
                        .blur(radius: 1.5)
                        .mask(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.black]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        )

                    // 6. Curvature lighting stroke with bright top edge and strong glow
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(self.isHovered ? 0.75 : 0.45),
                                    Color.white.opacity(self.isHovered ? 0.25 : 0.10),
                                    Color.white.opacity(0.02)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1.0
                        )
                }
            }
        )
        .onTapGesture {
            withAnimation(Animation.easeOut) {
                self.manager.device = item
                
            }
            
        }
        .onHover { hover in
            withAnimation(.easeOut(duration: 0.2)) {
                self.isHovered = hover
            }
            switch hover {
                case true : NSCursor.pointingHand.push()
                default : NSCursor.pop()
                
            }
            
        }
        .onChange(of: manager.device) { newValue in
            withAnimation(Animation.easeOut) {
                if newValue == item {
                    self.style = .light
                    
                }
                else {
                    self.style = .dark
                    
                }
                
            }
            
        }
        .onAppear() {
            if AppManager.shared.device == item {
                self.style = .light
                
            }
            else {
                self.style = .dark

            }
            
        }
        
    }
    
}
