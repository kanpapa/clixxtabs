;-----------------------------------------------------------------------------
; Serial Bootloader for 16F1827
;-----------------------------------------------------------------------------
                list P = 16F1827     ; Identify the chip to use
                include  P16F1827.INC

                ; Set the configuration bits for this application
                __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _BOREN_OFF & _FCMEN_OFF
                __CONFIG _CONFIG2, _LVP_ON & _PLLEN_OFF

                ; Reset vector
                org     0
                goto    BOOTLOADER

;-----------------------------------------------------------------------------
; Constants
;-----------------------------------------------------------------------------

VECTOR_SIZE     equ     0x0004          ; Size of interrupt vector space
LOADER_SIZE     equ     0x00FF          ; Size of the bootloader itself
MEMORY_SIZE     equ     0x0FFF          ; Total size of program memory

;-----------------------------------------------------------------------------
; Reset vector instruction will be moved to here by the host utility. This is
; how we enter the user application.
;-----------------------------------------------------------------------------

                org     MEMORY_SIZE - LOADER_SIZE - VECTOR_SIZE

USERCODE:
                goto    USERCODE

;-----------------------------------------------------------------------------
; Bootloader entry point
;-----------------------------------------------------------------------------

                org     MEMORY_SIZE - LOADER_SIZE

BOOTLOADER:
                ; Set up the internal oscillator (32MHz HF)
                BANKSEL OSCCON
                movlw   0xF0
                movwf   OSCCON
                ; Initialise the entry pin and check the state

                ; If we are not entering the loader restore the port state
                ; Launch the user application
                goto    USERCODE

SERIAL_INIT:
                ; Initialise the serial port and await commands

;-----------------------------------------------------------------------------
; Helper functions
;-----------------------------------------------------------------------------

