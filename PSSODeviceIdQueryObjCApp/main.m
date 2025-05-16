//
//  main.m
//  PSSODeviceIdQueryObjCApp
//
//  Created by Michael Epping on 5/16/25.
//

#import <Foundation/Foundation.h>
#import <MSAL/MSAL.h>
#import <MSAL/MSALPublicClientApplication.h>
#import <MSAL/MSALDeviceInformation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Starting MSAL device ID query...");
        
        // Create an MSALPublicClientApplicationConfig
        NSError *error = nil;
        MSALPublicClientApplicationConfig *config = [[MSALPublicClientApplicationConfig alloc] 
            initWithClientId:@"99735b02-e878-4799-94ec-df2d653445ea"
            redirectUri:@"msauth.com.msauth.unsignedapp://auth"
            authority:nil];
            
        // Create the public client application
        MSALPublicClientApplication *application = [[MSALPublicClientApplication alloc] 
            initWithConfiguration:config
            error:&error];
            
        if (error) {
            NSLog(@"Error creating MSAL application: %@", error);
            return 1;
        }
        
        // Get device information with SSO extension enabled
        [application getDeviceInformationWithParameters:nil
                                      completionBlock:^(MSALDeviceInformation * _Nullable deviceInformation, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error getting device information: %@", error);
                CFRunLoopStop(CFRunLoopGetMain());
                return;
            }
            
            if (deviceInformation) {
                NSLog(@"Device ID: %@", deviceInformation);
                if (@available(macOS 10.15, *)) {
                    NSLog(@"Device mode: %@", deviceInformation.deviceMode == MSALDeviceModeShared ? @"Shared" : @"Personal");
                }
                
                // Print all device info for debugging
                NSLog(@"Full device information: %@", deviceInformation);
            } else {
                NSLog(@"No device information returned");
            }
            
            CFRunLoopStop(CFRunLoopGetMain());
        }];
        
        // Keep the app running until the async callback completes
        NSLog(@"Waiting for device information...");
        CFRunLoopRun();
    }
    return 0;
}
