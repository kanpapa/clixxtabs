;-----------------------------------------------------------------------------
; Serial Bootloader for 16F1827
;-----------------------------------------------------------------------------
                list P = 16F1827     ; Identify the chip to use
                include  p16f1827.inc

                ; Set the configuration bits for this application
                __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _BOREN_OFF & _FCMEN_OFF
                __CONFIG _CONFIG2, _LVP_ON & _PLLEN_OFF

                ; Reset vector
                org     0
                goto    BOOTLOADER

;-----------------------------------------------------------------------------
; Constants and memory locations
;-----------------------------------------------------------------------------

VECTOR_SIZE     equ     0x0004            ; Size of interrupt vector space
LOADER_SIZE     equ     0x00FF            ; Size of the bootloader itself
MEMORY_SIZE     equ     0x0FFF            ; Total size of program memory
BLOCK_SIZE      equ     32                ; Size of a read/write block

PACKET_BUFFER   equ     0x01A0            ; Location of packet buffer
COMMAND_BYTE    equ     PACKET_BUFFER + 0 ; Where to find the command
ADDRESS         equ     PACKET_BUFFER + 1 ; Where to find the address
CHECKSUM        equ     PACKET_BUFFER + BLOCK_SIZE + 3

; Commands
CMD_QUERY       equ     '?'
CMD_READ        equ     'R'
CMD_WRITE       equ     'W'
CMD_RESET       equ     '!'

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
                ; Test the entry pin
                BANKSEL ANSELB
                bcf     ANSELB, ANSB6
                BANKSEL PORTB
                btfss   PORTB, RB6
                call    MAIN_LOADER
                ; Restore the pin configuration
                BANKSEL ANSELB
                bsf     ANSELB, ANSB6
                ; Launch the user application
                goto    USERCODE

MAIN_LOADER:
                ; Initialise the serial port
COMMAND_LOOP:
                ; Read commands
                call    READ_PKT
                ; Check the command
                movlw   COMMAND_BYTE & 0x00FF
                movwf   FSR0L
                movlw   (COMMAND_BYTE >> 8) & 0x00FF
                movwf   FSR0H
                movfw   FSR0
                sublw   CMD_QUERY
                btfsc   STATUS, Z
                goto    DO_CMD_QUERY
                movfw   FSR0
                sublw   CMD_READ
                btfsc   STATUS, Z
                goto    DO_CMD_READ
                movfw   FSR0
                sublw   CMD_WRITE
                btfsc   STATUS, Z
                goto    DO_CMD_WRITE
                movfw   FSR0
                sublw   CMD_RESET
                btfsc   STATUS, Z
                goto    DO_CMD_RESET
                ; Should never get to here
                goto    COMMAND_LOOP
DO_CMD_QUERY:
                goto    COMMAND_LOOP
DO_CMD_READ:
                goto    COMMAND_LOOP
DO_CMD_WRITE:
                goto    COMMAND_LOOP
DO_CMD_RESET:
                goto    COMMAND_LOOP

;-----------------------------------------------------------------------------
; Serial IO
;-----------------------------------------------------------------------------

READ_CHAR:
                return

WRITE_CHAR:
                return

READ_PKT:
                return

WRITE_PKT:
                return

;-----------------------------------------------------------------------------
; Helper functions
;-----------------------------------------------------------------------------

; Calculate a CCITT-16 CRC value for a block of data
; See http://www.digitalnemesis.com/info/codesamples/embeddedcrc16/
;
; Inputs: FSR0(H/L) points to data to be processed
;         W contains number of bytes to process
;
; Outputs: CRC_HI contains high byte of calculated CRC
;          CRC_LO contains low byte of calculated CRC

CRC16_TABLE_H   dw      0x00, 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70
                dw      0x81, 0x91, 0xA1, 0xB1, 0xC1, 0xD1, 0xE1, 0xF1
CRC16_TABLE_L   dw      0x00, 0x21, 0x42, 0x63, 0x84, 0xA5, 0xC6, 0xE7
                dw      0x08, 0x29, 0x4A, 0x6B, 0x8C, 0xAD, 0xCE, 0xEF

CCITT_CRC:
                return

                end

