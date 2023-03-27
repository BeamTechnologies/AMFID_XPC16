//
//  amfid_xpc.m
//  im_not_amfid
//
//  Created by Ali on 27.03.2023.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import <mach/port.h>
#import <mach/mach.h>
#include <dirent.h>
#include <string.h>
#include <mach/message.h>

/*
  This only supports 15.0/16.2
  This is for educational purposes use it at your OWN RISK!
  Exploit and boom boom stuff by aliy_2001
 */

kern_return_t
bootstrap_look_up(mach_port_t bp, const char* service_name, mach_port_t *sp);




kern_return_t getAmfid() {
    // We will need an XPC service to try getting the amfid pid and build a ripped amfid service
    const char* amfid_xpc = "com.apple.MobileFileIntegrity";

    printf("We will be triggering some special sausage to make them drop the amfid???\n");

    // Declare and initialize mach_port_t variables
    mach_port_t amfid_port = MACH_PORT_NULL;
    mach_port_t client_port = MACH_PORT_NULL;
    mach_port_t reply_port = MACH_PORT_NULL;

    kern_return_t amfidRet = bootstrap_look_up(bootstrap_port, amfid_xpc, &amfid_port);
    if (amfidRet == KERN_SUCCESS) {
        printf("\namfid_bootstrap_port: 0x%u\n", amfid_port);
    }
    
    // Allocate a receive right for the client port
    amfidRet = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &client_port);
    if (amfidRet == KERN_SUCCESS) {
        printf("\nclient_port: 0x%x\n", client_port);
    }
  
    // Allocate a receive right for the amfid port
    

    // Insert send right to the client port
    amfidRet = mach_port_insert_right(mach_task_self(), client_port, client_port, MACH_MSG_TYPE_MAKE_SEND);
    if (amfidRet == KERN_SUCCESS) {
        printf("oh hell yeah we got dem send right -> gratz\n");
    }
  
    amfidRet = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &reply_port);
     if (amfidRet != KERN_SUCCESS) {
       printf("port allocation failed: %s\n", mach_error_string(amfidRet));

     }

 
    
    


    return 0;
}
