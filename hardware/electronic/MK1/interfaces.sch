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
Sheet 5 7
Title "O'PAVES Mk-I"
Date ""
Rev "A"
Comp "AdaCore"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 2000 950  0    60   ~ 0
Arduino UNO like headers
$Comp
L CONN_01X10 P3
U 1 1 58866D50
P 3350 1700
F 0 "P3" H 3350 2250 50  0000 C CNN
F 1 "CONN_01X10" V 3450 1700 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x10" H 3350 1700 50  0001 C CNN
F 3 "" H 3350 1700 50  0000 C CNN
	1    3350 1700
	-1   0    0    1   
$EndComp
$Comp
L CONN_01X08 P4
U 1 1 58866E4A
P 3350 2750
F 0 "P4" H 3350 3200 50  0000 C CNN
F 1 "CONN_01X08" V 3450 2750 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x08" H 3350 2750 50  0001 C CNN
F 3 "" H 3350 2750 50  0000 C CNN
	1    3350 2750
	-1   0    0    1   
$EndComp
$Comp
L CONN_01X08 P1
U 1 1 58866E83
P 1750 2000
F 0 "P1" H 1750 2450 50  0000 C CNN
F 1 "CONN_01X08" V 1850 2000 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x08" H 1750 2000 50  0001 C CNN
F 3 "" H 1750 2000 50  0000 C CNN
	1    1750 2000
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X06 P2
U 1 1 58866F7C
P 1750 2850
F 0 "P2" H 1750 3200 50  0000 C CNN
F 1 "CONN_01X06" V 1850 2850 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x06" H 1750 2850 50  0001 C CNN
F 3 "" H 1750 2850 50  0000 C CNN
	1    1750 2850
	1    0    0    -1  
$EndComp
Text GLabel 3550 1250 2    60   Input ~ 0
ARDU_D15_SCL
Text GLabel 3550 1350 2    60   Input ~ 0
ARDU_D14_SDA
Text GLabel 3550 1450 2    60   Input ~ 0
VCCA
Text GLabel 3550 1650 2    60   Input ~ 0
ARDU_D13_SCK
Text GLabel 3550 1750 2    60   Input ~ 0
ARDU_D12_MISO
Text GLabel 3550 1850 2    60   Input ~ 0
ARDU_D11_MOSI
Text GLabel 3550 1950 2    60   Input ~ 0
ARDU_D10
Text GLabel 3550 2050 2    60   Input ~ 0
ARDU_D9
Text GLabel 3550 2150 2    60   Input ~ 0
ARDU_D8
Text GLabel 3550 2400 2    60   Input ~ 0
ARDU_D7
Text GLabel 3550 2500 2    60   Input ~ 0
ARDU_D6
Text GLabel 3550 2600 2    60   Input ~ 0
ARDU_D5
Text GLabel 3550 2700 2    60   Input ~ 0
ARDU_D4
Text GLabel 3550 2800 2    60   Input ~ 0
ARDU_D3
Text GLabel 3550 2900 2    60   Input ~ 0
ARDU_D2
Text GLabel 3550 3000 2    60   Input ~ 0
ARDU_D1_TXD
Text GLabel 3550 3100 2    60   Input ~ 0
ARDU_D0_RXD
Text GLabel 1550 1750 0    60   Input ~ 0
ARDU_IOREF
Text GLabel 1550 1850 0    60   Input ~ 0
NRST
Text GLabel 1550 1950 0    60   Input ~ 0
ARDU_3V3
Text GLabel 1550 2050 0    60   Input ~ 0
ARDU_5V
Text GLabel 1550 2350 0    60   Input ~ 0
ARDU_VIN
Text GLabel 1550 2600 0    60   Input ~ 0
ARDU_A0
Text GLabel 1550 2700 0    60   Input ~ 0
ARDU_A1
Text GLabel 1550 2800 0    60   Input ~ 0
ARDU_A2
Text GLabel 1550 2900 0    60   Input ~ 0
ARDU_A3
Text GLabel 1550 3000 0    60   Input ~ 0
ARDU_A4
Text GLabel 1550 3100 0    60   Input ~ 0
ARDU_A5
$Comp
L GND #PWR010
U 1 1 5886770A
P 750 2450
F 0 "#PWR010" H 750 2200 50  0001 C CNN
F 1 "GND" H 750 2300 50  0000 C CNN
F 2 "" H 750 2450 50  0000 C CNN
F 3 "" H 750 2450 50  0000 C CNN
	1    750  2450
	1    0    0    -1  
$EndComp
NoConn ~ 1550 1650
Wire Wire Line
	3550 1550 4650 1550
Wire Wire Line
	4650 1550 4650 1850
$Comp
L GND #PWR011
U 1 1 5886A835
P 4650 1850
F 0 "#PWR011" H 4650 1600 50  0001 C CNN
F 1 "GND" H 4650 1700 50  0000 C CNN
F 2 "" H 4650 1850 50  0000 C CNN
F 3 "" H 4650 1850 50  0000 C CNN
	1    4650 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 2150 750  2150
Wire Wire Line
	750  2150 750  2450
Wire Wire Line
	1550 2250 750  2250
Connection ~ 750  2250
$EndSCHEMATC
