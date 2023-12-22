// This is a project for basic kernel development. The goal is to gain a better understanding of kernel development, C, and Assembly
// About this kernel: x86 architecture, written in C and x86 assembly 
// Should be capable of displaying text on the screen (maybe a GUI in the future)
// Should be able to have an ISO disc image for the kernel that can be run on emulator or real software 
// Should give a rudimentary understanding of x86 architecture and x86 assembly 

// TODO: Build Cross Compiler!!! 
// https://wiki.osdev.org/GCC_Cross-Compiler
// code definition for start label 


// This file will contain the x86 assembly code that starts the kernel and sets up the x86

// Declare the 'kernel_main' label as being external to this file 
// It is the name of the main C function in 'kernel.c'
.extern kernel_main 

// Declare the start label as global, this is for the linker 
// Look for code definiton later 
.global start 

// GRUB (Bootloader) needs to know some basic information about the kernel before boot 
// Give GRUB this information using 'Multiboot' standard 
// To define a valid multiboot header, that will be recognized by GRUB, we need to hard code some constants into the exe
// The following will calculate these constants:
.set MB_MAGIC, 0x1BADB002   // This is a 'magic' constant that GRUB will use to detect the location of the kernel
.set MB_FLAGS, (1 << 0) | (1 << 1) // This tells GRUB to 1: load modules on page boundaries and 2: provide a memory map (this is useful later in development)

// Calculate the Checksum that includes all the previous values
.set MB_CHECKSUM, (0 - (MB_MAGIC + MB_FLAGS))

// Start the section of the exe that will contain the multiboot header 
.section .multiboot
    .align 4 // make sure the following data is aligned on multiples of 4 bytes 
    // use the previously calculated constants in exe code 
    .long MB_MAGIC
    .long MB_FLAGS
    .long MB_CHECKSUM

// This section contains the data initialized to zeroes when the kernel is loaded:
// declaration for an uninitialized buffer
.section .bss
    // The C code needs a stack so it can run. 
    // We can expand this later if we want a larger stack. Initially this is set to 4Kb 
    .align 16 
    stack_bottom:
        .skip 4096 // Reserve a 4096 byte stack (4Kb)
    stack_top:

// This section contains the actually assembly to be ran when the kernel loads 
.section .text 
    // This is the start label comes in. This is the first code ran in the kernel 
    start:
        // Set up an environment thats able to run C 
        // C needs the stack to be initialized
        // on x86, the stack grows downward. 
        mov $stack_top, %esp // set the stack pointer to the top of the stack. the %esp is the stack pointer register which points to the top of the stack 

        // now we have a C-worthy (haha!) environment ready to run the rest of the kernel 
        // now we can call our main C function:
        call kernel_main

		// If, by some mysterious circumstances, the kernel's C code ever returns, all we want to do is to hang the CPU
		hang:
			cli      // Disable CPU interrupts
			hlt      // Halt the CPU
			jmp hang // If that didn't work, loop around and try again.



