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
Sheet 2 7
Title "O'PAVES Mk-I"
Date ""
Rev "B"
Comp "AdaCore"
Comment1 "Licensed under CERN OHL v.1.2 or later"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L TAMIYA_High_Speed_Gearbox U1
U 1 1 5874F75F
P 8650 3050
F 0 "U1" H 8250 3150 60  0000 C CNN
F 1 "TAMIYA_High_Speed_Gearbox" H 8600 3000 60  0000 C CNN
F 2 "OPAVES_Footprints:TAMIYA_HIgh_Speed_Gearbox" H 8650 3050 60  0001 C CNN
F 3 "" H 8650 3050 60  0001 C CNN
	1    8650 3050
	1    0    0    -1  
$EndComp
$Comp
L TB6612FNG U5
U 1 1 588A9FC9
P 3950 2800
F 0 "U5" H 3950 2800 59  0000 C CNN
F 1 "TB6612FNG" H 5100 2400 59  0000 C CNN
F 2 "Housings_SSOP:SSOP-24_5.3x8.2mm_Pitch0.65mm" H 3950 2800 59  0001 C CNN
F 3 "" H 3950 2800 59  0001 C CNN
	1    3950 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	6350 3250 6350 3900
Connection ~ 6350 3700
Wire Wire Line
	6350 4100 6350 4300
Connection ~ 6350 3450
Wire Wire Line
	6350 2850 6350 3050
Text HLabel 3900 3200 0    59   Input ~ 0
PWM
Text HLabel 3900 3900 0    59   Input ~ 0
PWM
Wire Wire Line
	4850 4550 5650 4550
Connection ~ 5050 4550
Connection ~ 5250 4550
Connection ~ 5450 4550
$Comp
L GND #PWR02
U 1 1 588AA5AC
P 5250 4650
F 0 "#PWR02" H 5250 4400 50  0001 C CNN
F 1 "GND" H 5250 4500 50  0000 C CNN
F 2 "" H 5250 4650 50  0000 C CNN
F 3 "" H 5250 4650 50  0000 C CNN
	1    5250 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	5250 4650 5250 4550
Wire Wire Line
	7750 3550 6350 3550
Connection ~ 6350 3550
Wire Wire Line
	7400 4100 6350 4100
Wire Wire Line
	7400 3050 7400 4100
Wire Wire Line
	7400 3300 7750 3300
Wire Wire Line
	6350 3050 7400 3050
Connection ~ 7400 3300
Text HLabel 3900 3400 0    59   Input ~ 0
IN1
Text HLabel 3900 4100 0    59   Input ~ 0
IN1
Text HLabel 3900 3600 0    59   Input ~ 0
IN2
Text HLabel 3900 4300 0    59   Input ~ 0
IN2
Text HLabel 3900 2950 0    59   Input ~ 0
Standby
Text HLabel 6500 2000 2    59   Input ~ 0
VMOTOR
Text HLabel 3750 2000 0    59   Input ~ 0
VLOGIC
$Comp
L C_Small C17
U 1 1 588AD03F
P 4150 2150
F 0 "C17" H 4160 2220 50  0000 L CNN
F 1 "100nF" H 4160 2070 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 4150 2150 50  0001 C CNN
F 3 "" H 4150 2150 50  0000 C CNN
	1    4150 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 2000 4750 2600
$Comp
L GND #PWR03
U 1 1 588AD1AC
P 4150 2300
F 0 "#PWR03" H 4150 2050 50  0001 C CNN
F 1 "GND" H 4150 2150 50  0000 C CNN
F 2 "" H 4150 2300 50  0000 C CNN
F 3 "" H 4150 2300 50  0000 C CNN
	1    4150 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 2000 3750 2000
Connection ~ 4150 2000
Wire Wire Line
	4150 2300 4150 2250
Wire Wire Line
	4150 2050 4150 2000
Wire Wire Line
	6500 2000 5150 2000
Wire Wire Line
	5150 2000 5150 2600
Wire Wire Line
	5400 2600 5400 2000
Connection ~ 5400 2000
Wire Wire Line
	5650 2600 5650 2000
Connection ~ 5650 2000
$Comp
L C_Small C18
U 1 1 588AD5D1
P 5900 2150
F 0 "C18" H 5910 2220 50  0000 L CNN
F 1 "100nF" H 5910 2070 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 5900 2150 50  0001 C CNN
F 3 "" H 5900 2150 50  0000 C CNN
	1    5900 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	6200 2050 6200 2000
Connection ~ 6200 2000
$Comp
L CP1 C19
U 1 1 588AD684
P 6200 2200
F 0 "C19" H 6225 2300 50  0000 L CNN
F 1 "10uF 20V" H 6225 2100 50  0000 L CNN
F 2 "Capacitors_Tantalum_SMD:TantalC_SizeT_EIA-3528" H 6200 2200 50  0001 C CNN
F 3 "" H 6200 2200 50  0000 C CNN
	1    6200 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 2050 5900 2000
Connection ~ 5900 2000
Wire Wire Line
	5900 2400 6200 2400
Wire Wire Line
	6050 2400 6050 2450
Connection ~ 6050 2400
$Comp
L GND #PWR04
U 1 1 588AD740
P 6050 2450
F 0 "#PWR04" H 6050 2200 50  0001 C CNN
F 1 "GND" H 6050 2300 50  0000 C CNN
F 2 "" H 6050 2450 50  0000 C CNN
F 3 "" H 6050 2450 50  0000 C CNN
	1    6050 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6200 2400 6200 2350
Wire Wire Line
	5900 2400 5900 2250
Text Label 6700 3050 0    59   ~ 0
MOTOR_A
Text Label 6700 3550 0    59   ~ 0
MOTOR_B
Text HLabel 2000 4900 3    60   Input ~ 0
Encoder_A
$Comp
L CONN_01X04 Encoder1
U 1 1 5893DD3A
P 1950 4700
F 0 "Encoder1" V 2050 4700 50  0000 C CNN
F 1 "MOLEX 22-28-5044" V 2050 4700 50  0001 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04" H 1950 4700 50  0001 C CNN
F 3 "" H 1950 4700 50  0000 C CNN
	1    1950 4700
	0    -1   -1   0   
$EndComp
Text HLabel 2100 4900 3    60   Input ~ 0
Encoder_B
Text HLabel 1800 4900 3    59   Input ~ 0
VLOGIC
$Comp
L GND #PWR05
U 1 1 5893DF17
P 1900 4900
F 0 "#PWR05" H 1900 4650 50  0001 C CNN
F 1 "GND" H 1900 4750 50  0000 C CNN
F 2 "" H 1900 4900 50  0000 C CNN
F 3 "" H 1900 4900 50  0000 C CNN
	1    1900 4900
	1    0    0    -1  
$EndComp
$EndSCHEMATC
