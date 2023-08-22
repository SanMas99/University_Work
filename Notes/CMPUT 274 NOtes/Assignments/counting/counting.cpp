#include <Arduino.h>

int LEDPins[5] = {9, 10, 11, 12, 13};
int incbuttonpin=6;
int decbuttonpin=7;
int saverecallbuttonpin=5;
int LED[5] = {LOW, LOW, LOW, LOW, LOW};
int SaveRecallLED[5] = {LOW, LOW, LOW, LOW, LOW};
int Count=0;
int SaveRecallCount=0;
int i=9;
bool StopperCounter=false;
int IncButtonState=LOW;
int DecButttonState=LOW;
int SaveRecallButtonState=LOW;

void setup() {
	init();
	Serial.begin(9600);
	for(i=0 ; i < 5 ; i++) {
		pinMode(LEDPins[i],OUTPUT);
		digitalWrite(LEDPins[i],LED[i]);
	}
	pinMode(incbuttonpin, INPUT);
	pinMode(decbuttonpin, INPUT);
	pinMode(saverecallbuttonpin, INPUT);
	digitalWrite(incbuttonpin, HIGH);
	digitalWrite(decbuttonpin, HIGH);
	digitalWrite(saverecallbuttonpin, HIGH);
}


void loop() {
	if (digitalRead(incbuttonpin) == LOW) {
		for (i=0;i<5;i++) {
			if (StopperCounter==false) {
				if (digitalRead(LEDPins[i])== LOW) {
					digitalWrite(LEDPins[i], HIGH);
					StopperCounter=true;
				}
				else {
					digitalWrite(LEDPins[i], LOW);
				}
		}
	}
	while (IncButtonState==digitalRead(incbuttonpin)) {
		digitalRead(incbuttonpin);
	}
}
	if (digitalRead(decbuttonpin) == LOW ){
		for (i=0;i<5;i++) {
			if (StopperCounter==false) {
				if (digitalRead(LEDPins[i])== HIGH) {
					digitalWrite(LEDPins[i], LOW);
					StopperCounter=true;
				}
				else {
					digitalWrite(LEDPins[i], HIGH);
				}
		}
	}
		while (DecButttonState==digitalRead(decbuttonpin)) {
			digitalRead(decbuttonpin);
		}
}
	if (digitalRead(saverecallbuttonpin) == LOW ){
		if (SaveRecallCount==0) {
			for ( i = 0; i < 5; i++) {
				SaveRecallLED[i]=digitalRead(LEDPins[i]);
			SaveRecallCount=1;
			}
		}else{
			for (i = 0; i < 5; i++) {
				digitalWrite(LEDPins[i],SaveRecallLED[i]);
			SaveRecallCount=0;
			}
		}
		while (SaveRecallButtonState==digitalRead(saverecallbuttonpin)) {
			digitalRead(saverecallbuttonpin);
		}

	}
	StopperCounter=false;
}

int main() {
	setup();
	while (true){
		loop();
	}
}
