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
Rev "B"
Comp "AdaCore"
Comment1 "Licensed under CERN OHL v.1.2 or later"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Pololu_TB6612 U1
U 1 1 59887112
P 5400 2650
F 0 "U1" H 5750 2450 60  0000 C CNN
F 1 "Pololu_TB6612" H 5450 1750 60  0000 C CNN
F 2 "OPAVES_Footprints:Pololu_TB6612" H 6500 2000 60  0001 C CNN
F 3 "" H 6500 2000 60  0001 C CNN
	1    5400 2650
	1    0    0    -1  
$EndComp
Text HLabel 5550 2450 1    59   Input ~ 0
VMOTOR
Text HLabel 5250 2450 1    59   Input ~ 0
VLOGIC
Text HLabel 4600 2850 0    59   Input ~ 0
PWMA
Text HLabel 4600 3300 0    59   Input ~ 0
PWMB
Text HLabel 4600 3150 0    59   Input ~ 0
IN1
Text HLabel 4600 3450 0    59   Input ~ 0
IN1
Text HLabel 4600 3600 0    59   Input ~ 0
IN2
Text HLabel 4600 3000 0    59   Input ~ 0
IN2
$Comp
L GND #PWR02
U 1 1 59887758
P 5400 4250
F 0 "#PWR02" H 5400 4000 50  0001 C CNN
F 1 "GND" H 5400 4100 50  0000 C CNN
F 2 "" H 5400 4250 50  0000 C CNN
F 3 "" H 5400 4250 50  0000 C CNN
	1    5400 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 4250 5400 4150
Wire Wire Line
	5250 4150 5550 4150
Connection ~ 5400 4150
Text HLabel 4600 3750 0    59   Input ~ 0
Standby
Wire Wire Line
	6150 3050 6800 3050
Wire Wire Line
	6150 3250 6900 3250
Wire Wire Line
	6150 3350 6800 3350
Text Label 6250 3050 0    59   ~ 0
MOTOR_A1
Text Label 6250 3150 0    59   ~ 0
MOTOR_A2
Text Label 6250 3250 0    59   ~ 0
MOTOR_B2
Text Label 6250 3350 0    59   ~ 0
MOTOR_B1
$Comp
L CONN_01X02 Motor_Left1
U 1 1 5A0F32AD
P 7350 2950
F 0 "Motor_Left1" H 7350 3100 50  0000 C CNN
F 1 "CONN_01X02" H 7350 2800 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02" H 7350 2950 50  0001 C CNN
F 3 "" H 7350 2950 50  0000 C CNN
	1    7350 2950
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X02 Motor_Right1
U 1 1 5A0F331A
P 7350 3450
F 0 "Motor_Right1" H 7350 3600 50  0000 C CNN
F 1 "CONN_01X02" H 7350 3300 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02" H 7350 3450 50  0001 C CNN
F 3 "" H 7350 3450 50  0000 C CNN
	1    7350 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6900 3250 6900 3400
Wire Wire Line
	6900 3400 7150 3400
Wire Wire Line
	6800 3350 6800 3500
Wire Wire Line
	6800 3500 7150 3500
Wire Wire Line
	6800 3050 6800 2900
Wire Wire Line
	6800 2900 7150 2900
Wire Wire Line
	6150 3150 6900 3150
Wire Wire Line
	6900 3150 6900 3000
Wire Wire Line
	6900 3000 7150 3000
$EndSCHEMATC
