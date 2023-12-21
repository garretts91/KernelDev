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




