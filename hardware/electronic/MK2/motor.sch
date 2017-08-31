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
LIBS:template-cache
LIBS:MK2-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 6
Title "O'PAVES Mk-II"
Date ""
Rev "A"
Comp "AdaCore"
Comment1 "Licensed under CERN OHL v.1.2 or later"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L TAMIYA_High_Speed_Gearbox U1
U 1 1 5874F75F
P 10100 2700
F 0 "U1" H 9700 2800 60  0000 C CNN
F 1 "TAMIYA_High_Speed_Gearbox" H 10050 2650 60  0000 C CNN
F 2 "OPAVES_Footprints:TAMIYA_HIgh_Speed_Gearbox" H 10100 2700 60  0001 C CNN
F 3 "" H 10100 2700 60  0001 C CNN
	1    10100 2700
	1    0    0    -1  
$EndComp
$Comp
L TB6612FNG U5
U 1 1 588A9FC9
P 5400 2450
F 0 "U5" H 5400 2450 59  0000 C CNN
F 1 "TB6612FNG" H 6550 2050 59  0000 C CNN
F 2 "Housings_SSOP:SSOP-24_5.3x8.2mm_Pitch0.65mm" H 5400 2450 59  0001 C CNN
F 3 "" H 5400 2450 59  0001 C CNN
	1    5400 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 2900 7800 3550
Connection ~ 7800 3350
Wire Wire Line
	7800 3750 7800 3950
Connection ~ 7800 3100
Wire Wire Line
	7800 2500 7800 2700
Text HLabel 5350 2850 0    59   Input ~ 0
PWMA
Text HLabel 5350 3550 0    59   Input ~ 0
PWMA
Wire Wire Line
	6300 4200 7100 4200
Connection ~ 6500 4200
Connection ~ 6700 4200
Connection ~ 6900 4200
$Comp
L GND #PWR02
U 1 1 588AA5AC
P 6700 4300
F 0 "#PWR02" H 6700 4050 50  0001 C CNN
F 1 "GND" H 6700 4150 50  0000 C CNN
F 2 "" H 6700 4300 50  0000 C CNN
F 3 "" H 6700 4300 50  0000 C CNN
	1    6700 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	6700 4300 6700 4200
Wire Wire Line
	9200 3200 7800 3200
Connection ~ 7800 3200
Wire Wire Line
	8850 3750 7800 3750
Wire Wire Line
	8850 2700 8850 3750
Wire Wire Line
	8850 2950 9200 2950
Wire Wire Line
	7800 2700 8850 2700
Connection ~ 8850 2950
Text HLabel 5350 3050 0    59   Input ~ 0
IN1
Text HLabel 5350 3750 0    59   Input ~ 0
IN1
Text HLabel 5350 3250 0    59   Input ~ 0
IN2
Text HLabel 5350 3950 0    59   Input ~ 0
IN2
Text HLabel 5350 2600 0    59   Input ~ 0
Standby
Text HLabel 7950 1650 2    59   Input ~ 0
VMOTOR
Text HLabel 5200 1650 0    59   Input ~ 0
VLOGIC
$Comp
L C_Small C17
U 1 1 588AD03F
P 5600 1800
F 0 "C17" H 5610 1870 50  0000 L CNN
F 1 "100nF" H 5610 1720 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 5600 1800 50  0001 C CNN
F 3 "" H 5600 1800 50  0000 C CNN
	1    5600 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	6200 1650 6200 2250
$Comp
L GND #PWR03
U 1 1 588AD1AC
P 5600 1950
F 0 "#PWR03" H 5600 1700 50  0001 C CNN
F 1 "GND" H 5600 1800 50  0000 C CNN
F 2 "" H 5600 1950 50  0000 C CNN
F 3 "" H 5600 1950 50  0000 C CNN
	1    5600 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	6200 1650 5200 1650
Connection ~ 5600 1650
Wire Wire Line
	5600 1950 5600 1900
Wire Wire Line
	5600 1700 5600 1650
Wire Wire Line
	7950 1650 6600 1650
Wire Wire Line
	6600 1650 6600 2250
Wire Wire Line
	6850 2250 6850 1650
Connection ~ 6850 1650
Wire Wire Line
	7100 2250 7100 1650
Connection ~ 7100 1650
$Comp
L C_Small C18
U 1 1 588AD5D1
P 7350 1800
F 0 "C18" H 7360 1870 50  0000 L CNN
F 1 "100nF" H 7360 1720 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 7350 1800 50  0001 C CNN
F 3 "" H 7350 1800 50  0000 C CNN
	1    7350 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 1700 7650 1650
Connection ~ 7650 1650
$Comp
L CP1 C19
U 1 1 588AD684
P 7650 1850
F 0 "C19" H 7675 1950 50  0000 L CNN
F 1 "10uF 20V" H 7675 1750 50  0000 L CNN
F 2 "Capacitors_Tantalum_SMD:TantalC_SizeT_EIA-3528" H 7650 1850 50  0001 C CNN
F 3 "" H 7650 1850 50  0000 C CNN
	1    7650 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 1700 7350 1650
Connection ~ 7350 1650
Wire Wire Line
	7350 2050 7650 2050
Wire Wire Line
	7500 2050 7500 2100
Connection ~ 7500 2050
$Comp
L GND #PWR04
U 1 1 588AD740
P 7500 2100
F 0 "#PWR04" H 7500 1850 50  0001 C CNN
F 1 "GND" H 7500 1950 50  0000 C CNN
F 2 "" H 7500 2100 50  0000 C CNN
F 3 "" H 7500 2100 50  0000 C CNN
	1    7500 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 2050 7650 2000
Wire Wire Line
	7350 2050 7350 1900
Text Label 8150 2700 0    59   ~ 0
MOTOR_1
Text Label 8150 3200 0    59   ~ 0
MOTOR_2
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
$Comp
L Pololu_TB6612 U3
U 1 1 59887112
P 2500 2450
F 0 "U3" H 2850 2250 60  0000 C CNN
F 1 "Pololu_TB6612" H 2550 1550 60  0000 C CNN
F 2 "OPAVES_Footprints:Pololu_TB6612" H 3600 1800 60  0001 C CNN
F 3 "" H 3600 1800 60  0001 C CNN
	1    2500 2450
	1    0    0    -1  
$EndComp
Text HLabel 2650 2250 1    59   Input ~ 0
VMOTOR
Text HLabel 2350 2250 1    59   Input ~ 0
VLOGIC
Text HLabel 1700 2650 0    59   Input ~ 0
PWMA
Text HLabel 1700 3100 0    59   Input ~ 0
PWMB
Text HLabel 1700 2950 0    59   Input ~ 0
IN1
Text HLabel 1700 3250 0    59   Input ~ 0
IN1
Text HLabel 1700 3400 0    59   Input ~ 0
IN2
Text HLabel 1700 2800 0    59   Input ~ 0
IN2
$Comp
L GND #PWR06
U 1 1 59887758
P 2500 4050
F 0 "#PWR06" H 2500 3800 50  0001 C CNN
F 1 "GND" H 2500 3900 50  0000 C CNN
F 2 "" H 2500 4050 50  0000 C CNN
F 3 "" H 2500 4050 50  0000 C CNN
	1    2500 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 4050 2500 3950
Wire Wire Line
	2350 3950 2650 3950
Connection ~ 2500 3950
Text HLabel 1700 3550 0    59   Input ~ 0
Standby
Wire Wire Line
	3250 2850 3350 2850
Wire Wire Line
	3250 2950 3350 2950
Wire Wire Line
	3250 3050 3350 3050
Wire Wire Line
	3250 3150 3350 3150
Text Label 3350 2850 0    59   ~ 0
MOTOR_A1
Text Label 3350 2950 0    59   ~ 0
MOTOR_A2
Text Label 3350 3050 0    59   ~ 0
MOTOR_B2
Text Label 3350 3150 0    59   ~ 0
MOTOR_B1
$EndSCHEMATC
