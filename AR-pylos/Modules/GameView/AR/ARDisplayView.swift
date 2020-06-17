//
//  ARView.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/14/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI
import RealityKit

struct ARDisplayView: View {

    @ObservedObject var arViewManager: ARViewManager
    
    init(arViewManager: ARViewManager) {
          
        self.arViewManager = arViewManager
    }
    var body: some View {
        return ARViewContainer(arViewManager: arViewManager).edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
   
    @ObservedObject var arViewManager: ARViewManager
    
    init(arViewManager: ARViewManager) {
        self.arViewManager = arViewManager
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arViewManager.arView = arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}
