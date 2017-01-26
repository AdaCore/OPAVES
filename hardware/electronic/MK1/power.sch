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
Sheet 4 7
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
P 1150 2000
F 0 "BT1" H 1250 2050 50  0000 L CNN
F 1 "Battery" H 1250 1950 50  0000 L CNN
F 2 "" V 1150 2040 50  0001 C CNN
F 3 "" V 1150 2040 50  0000 C CNN
	1    1150 2000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 5885FB0A
P 1150 2150
F 0 "#PWR06" H 1150 1900 50  0001 C CNN
F 1 "GND" H 1150 2000 50  0000 C CNN
F 2 "" H 1150 2150 50  0000 C CNN
F 3 "" H 1150 2150 50  0000 C CNN
	1    1150 2150
	1    0    0    -1  
$EndComp
Text Notes 1650 2250 0    60   ~ 0
3 Cell NiMH:\n - Max: 4.5V\n - Typical: 3.6V\n - Low: 2.7V
$Comp
L R R3
U 1 1 5885FCA2
P 2700 2000
F 0 "R3" V 2780 2000 50  0000 C CNN
F 1 "5k" V 2700 2000 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 2630 2000 50  0001 C CNN
F 3 "" H 2700 2000 50  0000 C CNN
	1    2700 2000
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 5885FCD9
P 2700 2400
F 0 "R4" V 2780 2400 50  0000 C CNN
F 1 "10k" V 2700 2400 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 2630 2400 50  0001 C CNN
F 3 "" H 2700 2400 50  0000 C CNN
	1    2700 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	2700 2150 2700 2250
Wire Wire Line
	2700 2200 3000 2200
Connection ~ 2700 2200
$Comp
L GND #PWR07
U 1 1 5885FD97
P 2700 2550
F 0 "#PWR07" H 2700 2300 50  0001 C CNN
F 1 "GND" H 2700 2400 50  0000 C CNN
F 2 "" H 2700 2550 50  0000 C CNN
F 3 "" H 2700 2550 50  0000 C CNN
	1    2700 2550
	1    0    0    -1  
$EndComp
Text Notes 3000 2000 0    60   ~ 0
STM32F4 VBAT must be from 1.65V to 3.6V.\nSince the battery voltage is outside this range,\nwe use a 2/3 voltage divider to adjust it.\n\nVBAT MAX : 4.5V -> 3V\nVBAT Min : 2.7V -> 1.8V
Text HLabel 3000 2200 2    60   Input ~ 0
VBAT_SENSE
Wire Wire Line
	1150 1850 1150 1700
Wire Wire Line
	2700 1850 2700 1700
Text HLabel 1150 1700 1    60   Input ~ 0
VBAT
Text HLabel 2700 1700 1    60   Input ~ 0
VBAT
Text Notes 2550 1300 0    157  ~ 0
Battery
Text Notes 8050 2200 0    60   ~ 0
Pololu 5V \nStep-Up/Step-Down\nVoltage Regulator\nS7V8F5
Connection ~ 7350 1600
Wire Wire Line
	7350 1900 7350 1600
Wire Wire Line
	7500 1900 7350 1900
Wire Wire Line
	7500 2200 7250 2200
Wire Wire Line
	7400 2500 7400 2600
Wire Wire Line
	7500 2500 7400 2500
Wire Wire Line
	7500 1600 7250 1600
$Comp
L Pololu_StepUp/Down_Regulator StepUp_StepDown_5V0
U 1 1 588A675B
P 7700 1350
F 0 "StepUp_StepDown_5V0" H 8200 1400 60  0000 C CNN
F 1 "Pololu_StepUp/Down_Regulator" H 8450 1250 60  0000 C CNN
F 2 "" H 7700 1350 60  0001 C CNN
F 3 "" H 7700 1350 60  0001 C CNN
	1    7700 1350
	1    0    0    -1  
$EndComp
Text Notes 9350 2700 0    60   ~ 0
At some point this should be directly \nin the project rather than relying on \nan external board.  For the moment\nit's the more convenient solution.
Text Notes 6800 1100 0    157  ~ 0
5V step up / step down regulator
Text HLabel 7250 1600 0    60   Input ~ 0
VBAT
Text HLabel 7250 2200 0    60   Input ~ 0
5V
$Comp
L GND #PWR08
U 1 1 588A1F16
P 7400 2600
F 0 "#PWR08" H 7400 2350 50  0001 C CNN
F 1 "GND" H 7400 2450 50  0000 C CNN
F 2 "" H 7400 2600 50  0000 C CNN
F 3 "" H 7400 2600 50  0000 C CNN
	1    7400 2600
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
	7250 5400 7000 5400
Wire Wire Line
	7150 5700 7150 5800
Wire Wire Line
	7250 5700 7150 5700
Wire Wire Line
	7250 4800 7000 4800
$Comp
L Pololu_StepUp/Down_Regulator StepUp_StepDown_3V3
U 1 1 588A6FCC
P 7450 4550
F 0 "StepUp_StepDown_3V3" H 7950 4600 60  0000 C CNN
F 1 "Pololu_StepUp/Down_Regulator" H 8200 4450 60  0000 C CNN
F 2 "" H 7450 4550 60  0001 C CNN
F 3 "" H 7450 4550 60  0001 C CNN
	1    7450 4550
	1    0    0    -1  
$EndComp
Text Notes 9100 5900 0    60   ~ 0
At some point this should be directly \nin the project rather than relying on \nan external board.  For the moment\nit's the more convenient solution.
Text Notes 6550 4100 0    157  ~ 0
3.3V step up / step down regulator
Text HLabel 7000 4800 0    60   Input ~ 0
VBAT
Text HLabel 7000 5400 0    60   Input ~ 0
3V3
$Comp
L GND #PWR?
U 1 1 588A6FD6
P 7150 5800
F 0 "#PWR?" H 7150 5550 50  0001 C CNN
F 1 "GND" H 7150 5650 50  0000 C CNN
F 2 "" H 7150 5800 50  0000 C CNN
F 3 "" H 7150 5800 50  0000 C CNN
	1    7150 5800
	1    0    0    -1  
$EndComp
Wire Notes Line
	550  3350 11200 3350
Wire Notes Line
	5750 550  5750 6550
Wire Notes Line
	5750 6550 6950 6550
$EndSCHEMATC
