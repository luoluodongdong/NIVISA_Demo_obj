//
//  AppDelegate.m
//  NIVISAtest00200
//
//  Created by 曹伟东 on 2018/9/20.
//  Copyright © 2018年 曹伟东. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    lastChar=@"\r\n";
    logString =@"";
    openSerialPort_FLAG = false;
    openUSB_FLAG = false;
    openVISArm();
    USBdevices = findAllDevices();
    [usbDevicesCB removeAllItems];
    [usbDevicesCB addItemsWithObjectValues:USBdevices];
    [rs232BaudRateCB selectItemAtIndex:0];
    [self controlDisenable];
}

-(void)controlDisenable{
    [usbSendBtn setEnabled:NO];
    [rs232SendBtn setEnabled:NO];
    [gpibSendBtn setEnabled:NO];
    
    [usbReadBtn setEnabled:NO];
    [rs232ReadBtn setEnabled:NO];
    [gpibReadBtn setEnabled:NO];
    
    [closeUSBBtn setEnabled:NO];
    [closeGPIBBtn setEnabled:NO];
    [closeRS232Btn setEnabled:NO];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(IBAction)checkLastCharAction:(id)sender{
    if ([last_NAbtn state]) {
        lastChar=@"";
    }else if([last_Nbtn state]){
        lastChar=@"\n";
    }else if([last_RNbtn state]){
        lastChar=@"\r\n";
    }
}
-(IBAction)scanBtnAction:(id)sender{
    USBdevices = findAllDevices();
    [usbDevicesCB removeAllItems];
    [usbDevicesCB addItemsWithObjectValues:USBdevices];
}
-(IBAction)openRS232BtnAction:(id)sender{
    device = [usbDevicesCB objectValueOfSelectedItem];
    //if(!VISA_OPEN) openVISArm();
    int br = [[rs232BaudRateCB objectValueOfSelectedItem] intValue];
    fileDescriptorSP = openSerialPort(device,br);
    if(fileDescriptorSP != -1)
    {
        openSerialPort_FLAG = true;
        [openRS232Btn setEnabled:NO];
        [closeRS232Btn setEnabled:YES];
        [rs232SendBtn setEnabled:YES];
        [rs232ReadBtn setEnabled:YES];
        [self printInfo:@"Open Serial success." color:[NSColor greenColor]];
    }else{
        [self printInfo:@"Open Serial fail." color:[NSColor redColor]];
    }
}
-(IBAction)closeRS232BtnAction:(id)sender{
    if(!openSerialPort_FLAG) return;
    int rec = closeSerialPort(fileDescriptorSP);
    if(!VISA_OPEN) closeVISArm();
    
    if(rec != -1){
        openSerialPort_FLAG = false;
        [openRS232Btn setEnabled:YES];
        [closeRS232Btn setEnabled:NO];
        [rs232SendBtn setEnabled:NO];
        [rs232ReadBtn setEnabled:NO];
        [self printInfo:@"Close Serial success." color:[NSColor greenColor]];
    }else{
        [self printInfo:@"Close Serial fail." color:[NSColor redColor]];
    }
}
-(IBAction)rs232ReadBtnAction:(id)sender{
    if(!openSerialPort_FLAG) return;
    NSString *rec = readRS232(fileDescriptorSP);
    [self logUpdate:rec];
}
-(IBAction)rs232SendBtnAction:(id)sender{
    if(!openSerialPort_FLAG) return;
    cmd = [cmdTF stringValue];
    cmd=[cmd stringByAppendingString:lastChar];
    [self logUpdate:cmd];
    int a = writeRS232(fileDescriptorSP, cmd);
    NSLog(@"writeRS232 result:%d",a);
}

-(IBAction)usbReadBtnAction:(id)sender{
    if(!openUSB_FLAG) return;
    NSString *rec = readUSB(fileDescriptorUSB);
    [self logUpdate:rec];
}
-(IBAction)openUSBBtnAction:(id)sender{
    device = [usbDevicesCB objectValueOfSelectedItem];
    if(!VISA_OPEN) openVISArm();
    fileDescriptorUSB = openUSB(device);
    if(fileDescriptorUSB != -1) {
        openUSB_FLAG = true;
        [openUSBBtn setEnabled:NO];
        [closeUSBBtn setEnabled:YES];
        [usbSendBtn setEnabled:YES];
        [usbReadBtn setEnabled:YES];
        [self printInfo:@"Open USB success." color:[NSColor greenColor]];
    }else{
        [self printInfo:@"Open USB fail." color:[NSColor redColor]];
    }
}
-(IBAction)closeUSBBtnAction:(id)sender{
    if(!openUSB_FLAG) return;
    int rec = closeUSB(fileDescriptorUSB);
    if(!VISA_OPEN) closeVISArm();
    
    if(rec != -1){
        openUSB_FLAG = false;
        [openUSBBtn setEnabled:YES];
        [closeUSBBtn setEnabled:NO];
        [usbSendBtn setEnabled:NO];
        [usbReadBtn setEnabled:NO];
        [self printInfo:@"Close USB success." color:[NSColor greenColor]];
    }else{
        [self printInfo:@"Close USB fail." color:[NSColor redColor]];
    }
}
-(IBAction)usbSendBtnAction:(id)sender{
    if(!openUSB_FLAG) return;
    cmd = [cmdTF stringValue];
    cmd=[cmd stringByAppendingString:lastChar];
    [self logUpdate:cmd];
    int a = writeUSB(fileDescriptorUSB, cmd);
    NSLog(@"writeUSB result:%d",a);
}
-(IBAction)openGPIBBtnAction:(id)sender{
    device = [usbDevicesCB objectValueOfSelectedItem];
    if(!VISA_OPEN) openVISArm();
    fileDescriptorGPIB = openGPIB(device);
    if(fileDescriptorGPIB != -1) {
        openGPIB_FLAG = true;
        [openGPIBBtn setEnabled:NO];
        [closeGPIBBtn setEnabled:YES];
        [gpibSendBtn setEnabled:YES];
        [gpibReadBtn setEnabled:YES];
        [self printInfo:@"Open GPIB success." color:[NSColor greenColor]];
    }else{
        [self printInfo:@"Open GPIB fail." color:[NSColor redColor]];
    }
}
-(IBAction)closeGPIBBtnAction:(id)sender{
    if(!openGPIB_FLAG) return;
    int rec = closeGPIB(fileDescriptorGPIB);
    if(!VISA_OPEN) closeVISArm();
    
    if(rec != -1){
        openGPIB_FLAG = false;
        [openGPIBBtn setEnabled:YES];
        [closeGPIBBtn setEnabled:NO];
        [gpibSendBtn setEnabled:NO];
        [gpibReadBtn setEnabled:NO];
        [self printInfo:@"Close GPIB success." color:[NSColor greenColor]];
    }else{
        [self printInfo:@"Close GPIB fail." color:[NSColor redColor]];
    }
}
-(IBAction)gpibSendBtnAction:(id)sender{
    if(!openGPIB_FLAG) return;
    cmd = [cmdTF stringValue];
    cmd=[cmd stringByAppendingString:lastChar];
    [self logUpdate:cmd];
    int a = writeGPIB(fileDescriptorGPIB, cmd);
    NSLog(@"writeGPIB result:%d",a);
}
-(IBAction)gpibReadBtnAction:(id)sender{
    if(!openGPIB_FLAG) return;
    NSString *rec = readGPIB(fileDescriptorGPIB);
    [self logUpdate:rec];
}

-(void)printInfo:(NSString *)txt color:(NSColor *)col{
    [infoTF setBackgroundColor:col];
    [infoTF setStringValue:txt];
    [infoTF display];
}
-(void)logUpdate:(NSString *)txt{
    @synchronized(self) {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        NSString *dateText=[NSString string];
        dateText=[dateFormat stringFromDate:[NSDate date]];
        dateText=[dateText stringByAppendingString:@"\n"];
        logString = [logString stringByAppendingString:dateText];
        logString = [logString stringByAppendingString:txt];
        logString = [logString stringByAppendingString:@"\n"];
        
        [logView setString:logString];
        [logView scrollRangeToVisible:NSMakeRange([[logView textStorage] length],0)];
        [logView setNeedsDisplay: YES];
    }
}
-(void)windowWillClose:(id)sender{
    if(openSerialPort_FLAG) closeSerialPort(fileDescriptorSP);
    if(openUSB_FLAG) closeUSB(fileDescriptorUSB);
    if(openGPIB_FLAG) closeGPIB(fileDescriptorGPIB);
    if(!VISA_OPEN) closeVISArm();
    [NSThread sleepForTimeInterval:0.1];
    [NSApp terminate:NSApp];
}

@end
