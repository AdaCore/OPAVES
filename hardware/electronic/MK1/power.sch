EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:OPAVES_components
LIBS:stm32
LIBS:battery_management
LIBS:logo
LIBS:motor_drivers
LIBS:nordicsemi
LIBS:nxp_armmcu
LIBS:powerint
LIBS:Power_Management
LIBS:references
LIBS:silabs
LIBS:stm8
LIBS:switches
LIBS:transf
LIBS:video
LIBS:Worldsemi
LIBS:Xicor
LIBS:Zilog
LIBS:MK1-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 6
Title "O'PAVES Mk-I"
Date ""
Rev "A"
Comp "AdaCore"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Battery BT1
U 1 1 5885FA38
P 1900 1550
F 0 "BT1" H 2000 1600 50  0000 L CNN
F 1 "Battery" H 2000 1500 50  0000 L CNN
F 2 "" V 1900 1590 50  0001 C CNN
F 3 "" V 1900 1590 50  0000 C CNN
	1    1900 1550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 5885FB0A
P 1900 1700
F 0 "#PWR06" H 1900 1450 50  0001 C CNN
F 1 "GND" H 1900 1550 50  0000 C CNN
F 2 "" H 1900 1700 50  0000 C CNN
F 3 "" H 1900 1700 50  0000 C CNN
	1    1900 1700
	1    0    0    -1  
$EndComp
Text GLabel 1900 1400 1    60   Input ~ 0
VBAT
Text Notes 2400 1800 0    60   ~ 0
3 Cell NiMH:\n - Max: 4.5V\n - Typical: 3.6V\n - Low: 2.7V
Text GLabel 4000 1400 1    60   Input ~ 0
VBAT
$Comp
L R R3
U 1 1 5885FCA2
P 4000 1550
F 0 "R3" V 4080 1550 50  0000 C CNN
F 1 "5k" V 4000 1550 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 3930 1550 50  0001 C CNN
F 3 "" H 4000 1550 50  0000 C CNN
	1    4000 1550
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 5885FCD9
P 4000 1950
F 0 "R4" V 4080 1950 50  0000 C CNN
F 1 "10k" V 4000 1950 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 3930 1950 50  0001 C CNN
F 3 "" H 4000 1950 50  0000 C CNN
	1    4000 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 1700 4000 1800
Wire Wire Line
	4000 1750 4300 1750
Connection ~ 4000 1750
$Comp
L GND #PWR07
U 1 1 5885FD97
P 4000 2100
F 0 "#PWR07" H 4000 1850 50  0001 C CNN
F 1 "GND" H 4000 1950 50  0000 C CNN
F 2 "" H 4000 2100 50  0000 C CNN
F 3 "" H 4000 2100 50  0000 C CNN
	1    4000 2100
	1    0    0    -1  
$EndComp
Text GLabel 4300 1750 2    60   Input ~ 0
VBAT_MCU
Text Notes 4300 1550 0    60   ~ 0
STM32F4 VBAT must be from 1.65V to 3.6V.\nSince the battery voltage is outside this range,\nwe use a 2/3 voltage divider to adjust it.\n\nVBAT MAX : 4.5V -> 3V\nVBAT Min : 2.7V -> 1.8V
$EndSCHEMATC
