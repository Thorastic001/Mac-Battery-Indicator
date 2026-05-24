//
//  BBActionView.swift
//  BatteryBoi
//
//  Created by Joe Barbour on 8/15/23.
//

import SwiftUI

struct SettingsScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        
    }
    
}

struct SettingsItem: View {
    @EnvironmentObject var manager:AppManager
    @EnvironmentObject var updates:UpdateManager
    @EnvironmentObject var settings:SettingsManager
    @EnvironmentObject var battery:BatteryManager

    @Binding var hover:Bool

    @State var item:SettingsActionObject
    @State var subtitle:String? = nil
    @State var color:String? = nil
    @State var icon:String? = nil
    @State private var isHovered = false

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(icon ?? item.type.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(self.color == nil ? Color("BatterySubtitle") : Color("BatteryEfficient"))
                .frame(width: 24, height: 24)
                .padding(.leading, 14)
                .padding(.trailing, 8)

            VStack(alignment: .leading, spacing: 1) {
                Text(item.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color("BatteryTitle"))
                    .lineLimit(1)
                
                if self.hover == true && self.subtitle != nil {
                    Text(self.subtitle ?? "")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color("BatterySubtitle"))
                        .lineLimit(1)
                    
                }
                
            }
            
            Spacer(minLength: 0)
        }
        .frame(width: 156, height: 60)
        .background(
            ZStack {
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
        )
        .onAppear() {
            if item.type == .appEfficencyMode {
                self.color = self.battery.saver == .efficient ? "BatteryEfficient" : nil
                self.subtitle = self.battery.saver == .efficient ? "SettingsEnabledLabel".localise() : "SettingsDisabledLabel".localise()

            }
            else if item.type == .appPinned {
                self.subtitle = self.settings.pinned.subtitle
                self.icon = self.settings.pinned.icon

            }
            else if item.type == .appUpdateCheck {
                self.subtitle = self.updates.state.subtitle(updates.checked)
                
            }
            else if item.type == .customiseDisplay {
                self.subtitle = self.settings.enabledDisplay(false).type
                self.icon = self.settings.enabledDisplay(false).icon

            }
            else if item.type == .customiseSoundEffects {
                self.subtitle = self.settings.sfx.subtitle
                self.icon = self.settings.sfx.icon

            }
            else if item.type == .customiseCharge {
                self.subtitle = self.settings.charge.subtitle
                self.icon = self.settings.charge.icon

            }
            else if item.type == .customiseMinThreshold {
                self.subtitle = self.settings.minChargeThreshold.subtitle
                self.icon = self.settings.minChargeThreshold.icon

            }
            else if item.type == .customiseMaxThreshold {
                self.subtitle = self.settings.maxChargeThreshold.subtitle
                self.icon = self.settings.maxChargeThreshold.icon

            }

        }
        .onChange(of: self.battery.saver, perform: { newValue in
            withAnimation(Animation.easeOut.delay(0.1)) {
                if item.type == .appEfficencyMode {
                    self.color = self.battery.saver == .efficient ? "BatteryEfficient" : nil
                    self.subtitle = self.battery.saver == .efficient ? "SettingsEnabledLabel".localise() : "SettingsDisabledLabel".localise()

                }
                
            }
            
        })
        .onChange(of: self.updates.state, perform: { newValue in
            withAnimation(Animation.easeOut.delay(0.1)) {
                if item.type == .appUpdateCheck {
                    self.subtitle = self.updates.state.subtitle(updates.checked)
                    
                }
                
            }
            
        })
        .onChange(of: self.settings.display, perform: { newValue in
            withAnimation(Animation.easeOut.delay(0.1)) {
                if item.type == .customiseDisplay {
                    self.subtitle = newValue.type
                    self.icon = newValue.icon
                    
                }
                
                
            }
            
        })
        .onChange(of: self.settings.sfx, perform: { newValue in
            if item.type == .customiseSoundEffects {
                self.subtitle = self.settings.sfx.subtitle
                self.icon = self.settings.sfx.icon

            }

        })
        .onChange(of: self.settings.pinned, perform: { newValue in
            if item.type == .appPinned {
                self.subtitle = self.settings.pinned.subtitle
                self.icon = self.settings.pinned.icon

            }
            
        })
        .onChange(of: self.settings.charge, perform: { newValue in
            if item.type == .customiseCharge {
                self.subtitle = self.settings.charge.subtitle
                self.icon = self.settings.charge.icon

            }

        })
        .onChange(of: self.settings.minChargeThreshold, perform: { newValue in
            if item.type == .customiseMinThreshold {
                self.subtitle = newValue.subtitle
                self.icon = newValue.icon

            }

        })
        .onChange(of: self.settings.maxChargeThreshold, perform: { newValue in
            if item.type == .customiseMaxThreshold {
                self.subtitle = newValue.subtitle
                self.icon = newValue.icon

            }

        })
        .onTapGesture {
            SettingsManager.shared.settingsAction(item)
            
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
        
    }
    
}

struct SettingsOverlayItem: View {
    @EnvironmentObject var bluetooth:BluetoothManager
    @EnvironmentObject var manager:AppManager

    @State private var item:SettingsActionType
    @State private var icon:String = ""
    @State private var visible:Bool = true
    @State private var timeline = Array<String>()
    @State private var index:Int = 0
    @State private var isHovered = false

    init(_ item:SettingsActionType) {
        self._item = State(initialValue: item)
        
    }
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(Color.clear)
            .frame(width: 60)
            .background(
                ZStack {
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
            )
            .overlay(
                Image(systemName: self.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("BatterySubtitle"))
            
            )
            .onAppear() {
                self.index = 0
                self.timeline = self.bluetooth.connected.map({ $0.type.icon })
                
                if self.item == .appQuit {
                    self.icon = "power"
                    
                }
                else {
                    switch self.manager.menu {
                        case .settings : self.icon = self.timeline.index(self.index) ?? "headphones"
                        default : self.icon = "gearshape.fill"
                        
                    }
                    
                }
                

            }
            .onChange(of: self.manager.menu) { newValue in
                if self.item == .appDevices {
                    switch self.manager.menu {
                        case .settings : self.icon = self.timeline.index(self.index) ?? "headphones"
                        default : self.icon = "gearshape.fill"
                        
                    }

                }
                
            }
            .onChange(of: self.bluetooth.connected) { newValue in
                if item == .appDevices {
                    self.timeline = newValue.map({ $0.type.icon })
                    
                }
                
            }
            .onReceive(timer) { _ in
                if item == .appDevices {
                    switch self.timeline.index(self.index) {
                        case nil : self.index = 0
                        default : self.index += 1
                        
                    }
                    
                    if let icon = self.timeline.index(self.index) {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.9, blendDuration: 1)) {
                            self.icon = icon
                            
                            
                        }
                        
                    }
                   
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
            .onTapGesture {
                switch self.item {
                    case .appQuit : SettingsManager.shared.settingsAction(.init(self.item))
                    default : AppManager.shared.appToggleMenu(true)
                    
                }
            
            }

    }
    
}
