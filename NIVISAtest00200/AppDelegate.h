//
//  AppDelegate.h
//  NIVISAtest00200
//
//  Created by 曹伟东 on 2018/9/20.
//  Copyright © 2018年 曹伟东. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "NIVISAHelp.h"
@interface AppDelegate : NSObject <NSApplicationDelegate>

{
    IBOutlet NSButton *scanBtn;
    IBOutlet NSButton *usbSendBtn;
    IBOutlet NSButton *usbReadBtn;
    IBOutlet NSButton *openUSBBtn;
    IBOutlet NSButton *closeUSBBtn;
    IBOutlet NSTextView *logView;
    IBOutlet NSComboBox *usbDevicesCB;
    IBOutlet NSTextField *cmdTF;
    IBOutlet NSComboBox *rs232BaudRateCB;
    IBOutlet NSButton *rs232SendBtn;
    IBOutlet NSButton *rs232ReadBtn;
    IBOutlet NSButton *openRS232Btn;
    IBOutlet NSButton *closeRS232Btn;
    IBOutlet NSButton *gpibSendBtn;
    IBOutlet NSButton *gpibReadBtn;
    IBOutlet NSButton *openGPIBBtn;
    IBOutlet NSButton *closeGPIBBtn;
    IBOutlet NSTextField *infoTF;
    IBOutlet NSButton *last_NAbtn;
    IBOutlet NSButton *last_RNbtn;
    IBOutlet NSButton *last_Nbtn;
    
    NSThread *mainThread;
    NSString *logString;
    NSMutableArray *USBdevices;
    NSString *cmd;
    NSString *device;
    NSString *lastChar;
    
    int fileDescriptorSP;
    int fileDescriptorUSB;
    int fileDescriptorGPIB;
    bool openSerialPort_FLAG;
    bool openUSB_FLAG;
    bool openGPIB_FLAG;
}
-(IBAction)scanBtnAction:(id)sender;
-(IBAction)usbSendBtnAction:(id)sender;
-(IBAction)usbReadBtnAction:(id)sender;
-(IBAction)openUSBBtnAction:(id)sender;
-(IBAction)closeUSBBtnAction:(id)sender;
-(IBAction)rs232SendBtnAction:(id)sender;
-(IBAction)rs232ReadBtnAction:(id)sender;
-(IBAction)openRS232BtnAction:(id)sender;
-(IBAction)closeRS232BtnAction:(id)sender;
-(IBAction)gpibSendBtnAction:(id)sender;
-(IBAction)gpibReadBtnAction:(id)sender;
-(IBAction)openGPIBBtnAction:(id)sender;
-(IBAction)closeGPIBBtnAction:(id)sender;
-(IBAction)checkLastCharAction:(id)sender;
@end

