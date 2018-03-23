//
//  EmuGLView.swift
//  emulator-osx
//
//  Created by admin on 8/5/15.
//  Copyright (c) 2015 reicast. All rights reserved.
//

import Cocoa

class EmuGLView: NSOpenGLView {

    override var acceptsFirstResponder: Bool {
        return true;
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        // screen_width = view.drawableWidth;
        // screen_height = view.drawableHeight;
        
        //glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
        //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        openGLContext!.makeCurrentContext()
        
        while 0==emu_single_frame(Int32(dirtyRect.width), Int32(dirtyRect.height)) { }
        
        openGLContext!.flushBuffer()
    }
    
    override func awakeFromNib() {
        let renderTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(EmuGLView.timerTick), userInfo: nil, repeats: true)
        
        RunLoop.current.add(renderTimer, forMode: RunLoopMode.defaultRunLoopMode);
        RunLoop.current.add(renderTimer, forMode: RunLoopMode.eventTrackingRunLoopMode);
        
        let attrs:[NSOpenGLPixelFormatAttribute] =
        [
                UInt32(NSOpenGLPFADoubleBuffer),
                UInt32(NSOpenGLPFADepthSize), 24,
                // Must specify the 3.2 Core Profile to use OpenGL 3.2
                UInt32(NSOpenGLPFAOpenGLProfile),
                UInt32(NSOpenGLProfileVersion3_2Core),
                0
        ]
        
        let pf = NSOpenGLPixelFormat(attributes:attrs)
        
        let context = NSOpenGLContext(format: pf!, share: nil);
        
        self.pixelFormat = pf;
        self.openGLContext = context;
        
        openGLContext!.makeCurrentContext()
        emu_gles_init();
    }
    
   
    @objc func timerTick() {
        self.needsDisplay = true;
    }
    
    override func keyDown(with e: NSEvent) {
        emu_key_input(e.characters!, true);
    }
    
    override func keyUp(with e: NSEvent) {
        emu_key_input(e.characters!, false);
    }
    
}
