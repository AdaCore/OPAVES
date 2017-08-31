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
Sheet 3 6
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
L Battery BT1
U 1 1 5885FA38
P 1650 2000
F 0 "BT1" H 1750 2050 50  0000 L CNN
F 1 "Battery" H 1750 1950 50  0000 L CNN
F 2 "" V 1650 2040 50  0001 C CNN
F 3 "" V 1650 2040 50  0000 C CNN
	1    1650 2000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 5885FB0A
P 1650 2350
F 0 "#PWR07" H 1650 2100 50  0001 C CNN
F 1 "GND" H 1650 2200 50  0000 C CNN
F 2 "" H 1650 2350 50  0000 C CNN
F 3 "" H 1650 2350 50  0000 C CNN
	1    1650 2350
	1    0    0    -1  
$EndComp
Text Notes 2600 1300 0    60   ~ 0
3 Cell NiMH:\n - Max: 4.5V\n - Typical: 3.6V\n - Low: 2.7V
$Comp
L R R3
U 1 1 5885FCA2
P 3300 2100
F 0 "R3" V 3380 2100 50  0000 C CNN
F 1 "5k" V 3300 2100 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 3230 2100 50  0001 C CNN
F 3 "" H 3300 2100 50  0000 C CNN
	1    3300 2100
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 5885FCD9
P 3300 2500
F 0 "R4" V 3380 2500 50  0000 C CNN
F 1 "10k" V 3300 2500 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 3230 2500 50  0001 C CNN
F 3 "" H 3300 2500 50  0000 C CNN
	1    3300 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 2250 3300 2350
Wire Wire Line
	3300 2300 3600 2300
Connection ~ 3300 2300
$Comp
L GND #PWR08
U 1 1 5885FD97
P 3300 2650
F 0 "#PWR08" H 3300 2400 50  0001 C CNN
F 1 "GND" H 3300 2500 50  0000 C CNN
F 2 "" H 3300 2650 50  0000 C CNN
F 3 "" H 3300 2650 50  0000 C CNN
	1    3300 2650
	1    0    0    -1  
$EndComp
Text Notes 3550 2150 0    60   ~ 0
STM32F4 VBAT must be from 1.65V to 3.6V.\nSince the battery voltage is outside this range,\nwe use a 2/3 voltage divider to adjust it.\n\nVBAT MAX : 4.5V -> 3V\nVBAT Min : 2.7V -> 1.8V
Text HLabel 3600 2300 2    60   Input ~ 0
VBAT_SENSE
Wire Wire Line
	3300 1950 3300 1800
Text HLabel 2100 1650 2    60   Input ~ 0
VBAT
Text HLabel 3300 1800 1    60   Input ~ 0
VBAT
Text Notes 2500 800  0    157  ~ 0
Battery
Text Notes 8050 2200 0    60   ~ 0
Pololu 5V \nStep-Up/Step-Down\nVoltage Regulator\nS7V8F5
Connection ~ 7350 1600
Wire Wire Line
	7350 1900 7350 1600
Wire Wire Line
	7500 1900 7350 1900
Wire Wire Line
	6600 2200 7500 2200
Wire Wire Line
	7400 2500 7400 2800
Wire Wire Line
	7500 2500 7400 2500
Wire Wire Line
	7000 1600 7500 1600
$Comp
L Pololu_StepUp/Down_Regulator StepUp_StepDown_5V0
U 1 1 588A675B
P 7700 1350
F 0 "StepUp_StepDown_5V0" H 8200 1400 60  0000 C CNN
F 1 "Pololu_StepUp/Down_Regulator + MOLEX 22-28-5044" H 8450 1250 60  0000 C CNN
F 2 "OPAVES_Footprints:Pololu_StepUp_StepDown_Regulator" H 7700 1350 60  0001 C CNN
F 3 "" H 7700 1350 60  0001 C CNN
	1    7700 1350
	1    0    0    -1  
$EndComp
Text Notes 9350 2700 0    60   ~ 0
At some point this should be directly \nin the project rather than relying on \nan external board.  For the moment\nit's the more convenient solution.
Text Notes 6800 1100 0    157  ~ 0
5V step up / step down regulator
Text HLabel 6600 2200 0    60   Input ~ 0
5V
$Comp
L GND #PWR09
U 1 1 588A1F16
P 7400 2800
F 0 "#PWR09" H 7400 2550 50  0001 C CNN
F 1 "GND" H 7400 2650 50  0000 C CNN
F 2 "" H 7400 2800 50  0000 C CNN
F 3 "" H 7400 2800 50  0000 C CNN
	1    7400 2800
	1    0    0    -1  
$EndComp
Text Notes 7800 5400 0    60   ~ 0
Pololu 3.3V \nStep-Up/Step-Down\nVoltage Regulator\nS7V8F3
Connection ~ 7100 4800
Wire Wire Line
	7100 5100 7100 4800
Wire Wire Line
	7250 5100 7100 5100
Wire Wire Line
	6450 5400 7250 5400
Wire Wire Line
	7150 5700 7150 6050
Wire Wire Line
	7250 5700 7150 5700
Wire Wire Line
	6700 4800 7250 4800
$Comp
L Pololu_StepUp/Down_Regulator StepUp_StepDown_3V3
U 1 1 588A6FCC
P 7450 4550
F 0 "StepUp_StepDown_3V3" H 7950 4600 60  0000 C CNN
F 1 "Pololu_StepUp/Down_Regulator + MOLEX 22-28-5044" H 8200 4450 60  0000 C CNN
F 2 "OPAVES_Footprints:Pololu_StepUp_StepDown_Regulator" H 7450 4550 60  0001 C CNN
F 3 "" H 7450 4550 60  0001 C CNN
	1    7450 4550
	1    0    0    -1  
$EndComp
Text Notes 9100 5900 0    60   ~ 0
At some point this should be directly \nin the project rather than relying on \nan external board.  For the moment\nit's the more convenient solution.
Text Notes 6550 4100 0    157  ~ 0
3.3V step up / step down regulator
Text HLabel 6450 5400 0    60   Input ~ 0
3V3
$Comp
L GND #PWR010
U 1 1 588A6FD6
P 7150 6050
F 0 "#PWR010" H 7150 5800 50  0001 C CNN
F 1 "GND" H 7150 5900 50  0000 C CNN
F 2 "" H 7150 6050 50  0000 C CNN
F 3 "" H 7150 6050 50  0000 C CNN
	1    7150 6050
	1    0    0    -1  
$EndComp
Wire Notes Line
	550  3350 11200 3350
Wire Notes Line
	5750 550  5750 6550
Wire Notes Line
	500  6550 6950 6550
Wire Wire Line
	1650 2150 1650 2350
Wire Wire Line
	1500 1650 2100 1650
$Comp
L CONN_01X03 Battery1
U 1 1 588B953B
P 1200 1950
F 0 "Battery1" H 1200 2150 50  0000 C CNN
F 1 "MOLEX 22-28-4033" V 1300 1950 50  0001 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x03" H 1200 1950 50  0001 C CNN
F 3 "" H 1200 1950 50  0000 C CNN
	1    1200 1950
	-1   0    0    1   
$EndComp
Wire Wire Line
	1500 1950 1400 1950
Wire Wire Line
	1500 1650 1500 1950
Wire Wire Line
	1650 1850 1650 1650
Connection ~ 1650 1650
Wire Wire Line
	1400 2050 1500 2050
Wire Wire Line
	1500 2050 1500 2200
Wire Wire Line
	1500 2200 1650 2200
Connection ~ 1650 2200
NoConn ~ 1400 1850
Text Notes 700  3150 0    118  ~ 0
TODO: Reverse polarity protection (maybe)
$Comp
L Led_Small D4
U 1 1 58DB4328
P 6850 2350
F 0 "D4" H 6800 2475 50  0000 L CNN
F 1 "Red" H 6800 2250 50  0000 L CNN
F 2 "LEDs:LED_0805" V 6850 2350 50  0001 C CNN
F 3 "" V 6850 2350 50  0000 C CNN
	1    6850 2350
	0    -1   -1   0   
$EndComp
$Comp
L R R15
U 1 1 58DB4330
P 6850 2600
F 0 "R15" V 6930 2600 50  0000 C CNN
F 1 "330" V 6850 2600 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 6780 2600 50  0001 C CNN
F 3 "" H 6850 2600 50  0000 C CNN
	1    6850 2600
	-1   0    0    1   
$EndComp
Wire Wire Line
	7400 2750 6850 2750
Connection ~ 7400 2750
Wire Wire Line
	6850 2250 6850 2200
Connection ~ 6850 2200
$Comp
L Led_Small D5
U 1 1 58DB4F4F
P 6850 5550
F 0 "D5" H 6800 5675 50  0000 L CNN
F 1 "Green" H 6750 5450 50  0000 L CNN
F 2 "LEDs:LED_0805" V 6850 5550 50  0001 C CNN
F 3 "" V 6850 5550 50  0000 C CNN
	1    6850 5550
	0    -1   -1   0   
$EndComp
$Comp
L R R16
U 1 1 58DB4F57
P 6850 5800
F 0 "R16" V 6930 5800 50  0000 C CNN
F 1 "330" V 6850 5800 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 6780 5800 50  0001 C CNN
F 3 "" H 6850 5800 50  0000 C CNN
	1    6850 5800
	-1   0    0    1   
$EndComp
Wire Wire Line
	6850 5450 6850 5400
Connection ~ 6850 5400
Wire Wire Line
	7150 5950 6850 5950
Connection ~ 7150 5950
$Comp
L DP3T_switch U7
U 1 1 58DB8591
P 3000 4500
F 0 "U7" H 3000 4500 60  0000 C CNN
F 1 "0S203013MT8QN1" H 3000 4400 60  0000 C CNN
F 2 "OPAVES_Footprints:DP3T_switch" H 3000 4500 60  0001 C CNN
F 3 "" H 3000 4500 60  0001 C CNN
	1    3000 4500
	1    0    0    -1  
$EndComp
NoConn ~ 3350 4750
Text Notes 2150 4850 0    60   ~ 0
Off
Text Notes 1850 5000 0    60   ~ 0
MCU only
Text Notes 1600 5150 0    60   ~ 0
All circuits on
NoConn ~ 2650 4750
Text HLabel 2650 5200 0    60   Input ~ 0
VMOTOR
Text HLabel 2650 5050 0    60   Input ~ 0
VBAT
Text HLabel 3350 5050 2    60   Input ~ 0
VBAT
Wire Wire Line
	3350 4900 4050 4900
Wire Wire Line
	3700 4900 3700 5200
Wire Wire Line
	3700 5200 3350 5200
NoConn ~ 2650 4900
Connection ~ 3700 4900
Text Label 4050 4900 0    60   ~ 0
VCTRL
Text Label 7000 1600 0    60   ~ 0
VCTRL
Text Label 6700 4800 0    60   ~ 0
VCTRL
Text Notes 2150 3850 0    157  ~ 0
Master switch
$EndSCHEMATC
