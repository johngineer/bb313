; blinky test program for AVR ATTiny2313/4313
; written/assembled in AVRStudio 4
; 
; by John M. De Cristofaro - 6 June 2011
; 
; This code is in the public domain and is unsupported.



.nolist

.include "tn2313Adef.inc" ;ATTiny2313A definitions file -- change as needed

.list

.def temp = R16
.def temp2 = R17

.equ blinkerpin         = PB6       ; pin LED is connected to
.equ blinker_ddr        = DDRB
.equ blinker_port       = PORTB

.equ clockdiv16bit = 0b00000011     ; 16-bit timer clkdiv = 64


; toggle LED on/off at about a 1 second interval @ 1MHz
; changing clock speed using fuses will make it blink faster or slower

.equ onesecond = 0x3D      ; (1000000 / 64 = 15625 = 0x3D09 = ~0x3D00)

.cseg

.org 0x0000

    rjmp init



init:

    ;set 16-bit timer control registers
    clr temp
    out TCCR1A, temp

    ldi temp, clockdiv16bit     ; set clockdiv to whatever is defined in
    out TCCR1B, temp            ; clockdiv16bit

    clr temp
    out blinker_ddr, temp
    out blinker_port, temp

    sbi blinker_ddr, blinkerpin

main:
    clr temp

    out TCNT1H, temp
    out TCNT1L, temp

    sbi blinker_port, blinkerpin

loop1:                                  ; LED is OFF
    in temp, TCNT1H
    in temp2, TCNT1L

    cpi temp, onesecond
    brne loop1

    cbi blinker_port, blinkerpin

    clr temp
    out TCNT1H, temp
    out TCNT1L, temp

loop2:                                  ; LED is ON
    in temp, TCNT1H
    in temp2, TCNT1L

    cpi temp, onesecond
    brne loop2

    sbi blinker_port, blinkerpin

    clr temp
    out TCNT1H, temp
    out TCNT1L, temp

    rjmp loop1
    


