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

; Variable definitions
CBLOCK 0x70
                TEMP0   ; Temporary variable
                TEMP1   ; Temporary variable
ENDC

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
                movfw   INDF0
                sublw   CMD_QUERY
                btfsc   STATUS, Z
                goto    DO_CMD_QUERY
                movfw   INDF0
                sublw   CMD_READ
                btfsc   STATUS, Z
                goto    DO_CMD_READ
                movfw   INDF0
                sublw   CMD_WRITE
                btfsc   STATUS, Z
                goto    DO_CMD_WRITE
                movfw   INDF0
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

; Read a character from the serial port.
;
; This reads a single character from the serial port. This is a blocking
; function and will wait for a character to come in before returning.
;
; Inputs: None
; Outputs: W = character read from serial port

READ_CHAR:
                BANKSEL RCSTA
                btfss   RCSTA, OERR     ; Check for overrun error
                goto    WAIT_CHAR
                bcf     RCSTA, CREN     ; Clear the error
                bsf     RCSTA, CREN
WAIT_CHAR:      BANKSEL PIR1
                btfss   PIR1, RCIF      ; Wait for a character
                goto    WAIT_CHAR
                BANKSEL RCREG
                movfw   RCREG           ; Read the character
                return

; Write a character to the serial port.
;
; This writes a single character on the serial port. This is a blocking
; function and will wait until the character can be sent.
;
; Inputs: W = Character to send

WRITE_CHAR:
                BANKSEL PIR1
                btfss   PIR1, RCIF      ; Wait until we can transmit
                goto    WRITE_CHAR
                BANKSEL TXREG
                movwf   TXREG           ; Queue the character
                return

READ_PKT:
                ; Set up a pointer to the packet buffer
                movlw   PACKET_BUFFER & 0x00FF
                movwf   FSR0L
                movlw   (PACKET_BUFFER >> 8) & 0x00FF
                movwf   FSR0H
READ_CMD:       movlw   1               ; Data for query is 1 extra byte
                movwf   TEMP0
                call    READ_CHAR       ; Read the first character
                movwf   INDF0           ; Save it
                ; Check for valid command byte
                sublw   CMD_QUERY
                btfsc   STATUS, Z
                goto    READ_DATA
                movlw   3               ; Size for R is address + term
                movwf   TEMP0
                movfw   INDF0
                sublw   CMD_READ
                btfsc   STATUS, Z
                goto    READ_DATA
                movlw   BLOCK_SIZE + 3  ; Size for W is address + block + term
                movwf   TEMP0
                movfw   INDF0
                sublw   CMD_WRITE
                btfsc   STATUS, Z
                goto    READ_DATA
                movlw   1               ; Size for ! is term
                movwf   TEMP0
                movfw   INDF0
                sublw   CMD_RESET
                btfsc   STATUS, Z
                goto    READ_DATA
                ; TODO: Bad command. Should do something other than ignore
                goto    READ_CMD
READ_DATA:
                return

WRITE_PKT:
                return

;-----------------------------------------------------------------------------
; Helper functions
;-----------------------------------------------------------------------------

                end

