#include <Arduino.h>

int LEDPins[5] = {9, 10, 11, 12, 13};

void setup() {
	init();
	Serial.begin(9600);
	for(int i=0 ; i < 5 ; i++) {
		pinMode(LEDPins[i],OUTPUT);
		digitalWrite(LEDPins[i],LOW);
	}
}

int8_t getHexValue(char digit) {
	if (int(digit)>=48 and int(digit)<=57) {
		digit=int(digit)-48;
	} else if (int(digit)>=65 and int(digit)<=70){
		digit=int(digit)-55;
	} else if (int(digit)>=97 and int(digit)<=102){
		digit=int(digit)-87;
	} else if (int(digit)== 32){
		digit=-2;
	} else{
		digit=-1;
	}
	return (digit);
}
void UpdateLEDS (uint8_t total) {
	char Binary[10];
	char SplittedBinary[5];
	int i = 0;
	int CurrentLEDTotal = 0;
	Serial.print(total);
	if (total==0){
		for (i=0;i<5;i++) {
			digitalWrite(LEDPins[i], LOW);
		}
	}
		for(i=0; i<5; i++){

			 if(total&(1<<i)){
			 	digitalWrite(LEDPins[i], HIGH);
			 }else{
				digitalWrite(LEDPins[i], LOW);
			 }
		}

	}
	


int main() {
	setup();
	uint8_t total = 0;
	char Digit;
	char digit;
	while (true){
		if (Serial.available()==1) {
			Digit = Serial.read();
			digit = getHexValue(Digit);
			if (digit==-2){
				total=0;
			}else if (digit!=-1) {
				total = total + digit;
			}
			UpdateLEDS(total);
		
	}
}
}

