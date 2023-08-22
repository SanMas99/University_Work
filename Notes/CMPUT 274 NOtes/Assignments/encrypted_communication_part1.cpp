#include <Arduino.h>


void setup() {
    init();
    Serial.begin(9600);
    Serial3.begin(9600);
    int ReadPin=13;
    if (digitalRead(ReadPin)== LOW){//Checks to see if Pin 13 is grounded or it is connected to the 5V pin.
        Serial.println("You are the Client");

    }else{
        Serial.println("You are the Server");
    }
}

// This is the function that will be used for modular multiplication, this is used to prevent overflow.
uint32_t Modular_Arithemtic(uint32_t a,uint32_t b,uint32_t n){
    uint32_t result = 0;
    while (b>0){//will stop once b is equal to 0
        if (b&1){
            result=result + a;
            result=result%n;
        }
        //bits for both a and b will be shifted to test next bit in the next loop iteration
        b=b>>1;
        a=a<<1;
        if (a>=n){
            a=a%n;
        }
    }
    return result;
}

// This, when called, will encrypt the character passed in using the encryption scheme given to us and will return an encryped character to the main function which will be sent to the other arduino
uint32_t encrypt(uint32_t Character, uint32_t e, uint32_t m) {
    uint32_t x=1%m;
    while (e > 0 ){
        if(e&1){
            x=Modular_Arithemtic(x,Character,m);
        }
        Character=Modular_Arithemtic(Character,Character,m) ;
        e = e>>1;
      }

  return x;
}


//This will decrypt a character, using the decryption scheme given to us, which will the return a character that will be displayed to the receiving arduino.
uint32_t decrypt(uint32_t Character, uint32_t pow, uint32_t n) {
    uint32_t y=1%n;
    while (pow > 0 ){
        if(pow&1){
          y=Modular_Arithemtic(y,Character,n);
        }
        Character=Modular_Arithemtic(Character,Character,n);
        pow = pow>>1;
      }

  return y;
}
//This is used to send the encrypted character to Serial 3 by writing 4 bytes into Serial 3 which will be read by the other Arduino
void  uint32_to_serial3(uint32_t  num) {
    Serial3.write((char) (num  >> 0));
    Serial3.write((char) (num  >> 8));
    Serial3.write((char) (num  >> 16));
    Serial3.write((char) (num  >> 24));
}
//The Arduino which will decrypt the encrypted character reads the character from Serial 3 and will store it into a variable.
uint32_t  uint32_from_serial3 () {
    uint32_t  num = 0;
    num = num | (( uint32_t) Serial3.read()) << 0;
    num = num | (( uint32_t) Serial3.read()) << 8;
    num = num | (( uint32_t) Serial3.read()) << 16;
    num = num | (( uint32_t) Serial3.read()) << 24;
    return  num;
}

int main(){
    setup();
    uint32_t ServerPublicKey=7;
    uint32_t ServerPrivateKey=27103;
    uint32_t ServerMod=95477;
    uint32_t ClientPublicKey=11;
    uint32_t ClientPrivate=38291;
    uint32_t ClientMod=84823;
    int ReadPin=13;
    uint32_t d,n,e,m;

    if (digitalRead(ReadPin)== LOW){//will check pin to determine if arduino is client or server and adjust d,e,n and m accordingly
        d = ClientPrivate;
        n=ClientMod;
        e =ServerPublicKey;
        m=ServerMod;

    }else{
        d= ServerPrivateKey;
        n=ServerMod;
        e =ClientPublicKey;
        m=ClientMod;
    }

    while (true){
        if (Serial.available()>0) {
            char Character = Serial.read();//Reads character entered in Serial monitor
            if (int(Character)==13){//Checks to see if the enter character is entered, it will print on a new line, else it will continue on the same line.
            }else{
                Serial.print(Character);
            }
            uint32_t encryptedChar = encrypt(Character,e,m);
            uint32_to_serial3(encryptedChar);
        }
       if(Serial3.available()>3){ //Checks to see if there is anything in Serial 3 to decrypt
            uint32_t SentChar=uint32_from_serial3();
            char DecryptedChar=decrypt(SentChar,d,n);
            if (int(DecryptedChar)==13){//Checks to see if the enter character is entered, it will print on a new line, else it will continue on the same line
                Serial.println(DecryptedChar);
            }else{
                Serial.print(DecryptedChar);
            }
        }
    }
    Serial.flush();
    Serial3.flush();

}


