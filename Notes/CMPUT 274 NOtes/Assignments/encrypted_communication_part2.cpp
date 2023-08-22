//Names: Moyinoluwa Famobiwo, Sanad Masannat
//IDs: 1625393, 1626221

//CMPUT 274, Fall 2019

//Assignment 2: Encrypted Arduino Communication, part 2

#include <Arduino.h>
#include <math.h>

void setup() {
    init();
    Serial.begin(9600);
    Serial3.begin(9600);
    int pin = 13;

    //Checks to see if Pin 13 is grounded or it is connected to the 5V pin.
    if (digitalRead(pin) == LOW){
        Serial.println("You are the Client");
    }else{
        Serial.println("You are the Server");
    }
}

// This is the function that will be used for modular multiplication, this is used to prevent overflow.
uint32_t modmul(uint32_t a,uint32_t b,uint32_t n){
    uint32_t result = 0;
    while (b > 0){
        if (b & 1){
            result = result + a;
            result = result % n;
        }
        //bits for both a and b will be shifted to test next bit in the next loop iteration
        b = b >> 1;
        a = a << 1;
        if (a >= n){
            a = a % n;
        }
    }
    return result;
}

// This, when called, will encrypt the character passed in using the encryption scheme given to us and will return an encryped character to the main function which will be sent to the other arduino
uint32_t encrypt(uint32_t character, uint32_t e, uint32_t m) {
    uint32_t x = 1 % m;
    while (e > 0){
        if(e & 1){
            x = modmul(x,character,m);
        }
        character = modmul(character,character,m) ;
        e = e >> 1;
      }

  return x;
}

//This will decrypt a character, using the decryption scheme given to us, which will the return a character that will be displayed to the receiving arduino.
uint32_t decrypt(uint32_t character, uint32_t pow, uint32_t n) {
    uint32_t y = 1 % n;
    while (pow > 0 ){
        if(pow & 1){
          y = modmul(y,character,n);
        }
        character = modmul(character,character,n);
        pow = pow >> 1;
      }

  return y;
}

/*Waits for a certain number of bytes on Serial3 or timeout
 Returns true if the required number of bytes have arrived*/
bool wait_on_serial3(uint8_t nbytes, long timeout){
    unsigned long deadline = millis() + timeout;
    while(Serial3.available() < nbytes && (timeout <0 || millis() < deadline)){
        delay(1);
    }
    return Serial3.available() >= nbytes;
}

//This is used to send the encrypted character to Serial 3 by writing 4 bytes into Serial 3 which will be read by the other Arduino
void  uint32_to_serial3(uint32_t  num) {
    Serial3.write((char) (num  >> 0));
    Serial3.write((char) (num  >> 8));
    Serial3.write((char) (num  >> 16));
    Serial3.write((char) (num  >> 24));
}
//The Arduino that will decrypt the encrypted character reads the character from Serial 3 and will store it into a variable.
uint32_t  uint32_from_serial3 () {
    uint32_t  num = 0;
    num = num | (( uint32_t) Serial3.read()) << 0;
    num = num | (( uint32_t) Serial3.read()) << 8;
    num = num | (( uint32_t) Serial3.read()) << 16;
    num = num | (( uint32_t) Serial3.read()) << 24;
    return  num;
}

void sendChar(uint32_t e, uint32_t m){
    if (Serial.available()>0) {

        // Reads character entered in Serial monitor
        char character = Serial.read();

        /* Checks to see if the enter character is entered,
        if so, it will print on a new line, else it will continue on the same line.*/
        if (int(character)==13){
            Serial.println(character);
        }else{
            Serial.print(character);
        }
        uint32_t encryptedChar = encrypt(character, e, m);
        uint32_to_serial3(encryptedChar);
    }
}

void receiveChar(uint32_t d, uint32_t n){
    //Checks to see if there is anything in Serial 3 to decrypt
   if(Serial3.available() > 3){
        uint32_t SentChar=uint32_from_serial3();
        char DecryptedChar=decrypt(SentChar,d,n);
        /*Checks to see if the carriage return character is decrypted,
        if so, it will print on a new line, else it will continue on the same line*/
        if (int(DecryptedChar) == 13){
            Serial.println(DecryptedChar);
        }else{
            Serial.print(DecryptedChar);
        }
    }
}

//function to check if a number is prime
bool primality(uint32_t n) {
    int m = sqrt(n);
    int x = (n & 1);
    int i = 2;
    if(n <= 1){
        return false;
    }else if(n == 2){
        return true;
    }else if(x == 0){
        return false;
    }else{
        for(i = 2;i <= m;i++){
            if(n % i == 0){
                return false;
            }
        }
    }
    return true;
}


/*this is used to generate a random number
by reading from an analog pin
the parameter n is the upper power of 2
i.e. if you want a number below n bits*/
uint32_t randNum(int n){
    uint32_t k = n-1;
    uint32_t randNumber = 0;
    uint32_t analogPin = 1;
    uint32_t currentNum;
    uint32_t bit;

    for(int i = 0; i <= k; i++){
        currentNum = analogRead(analogPin);
        bit = currentNum & 1;
        randNumber = randNumber | (bit << i);
        delay(5);
    }

    randNumber = randNumber | ((uint32_t)1 << k);
    return randNumber;
}

/* this is used to generate a random prime number
 using the randNum and primality functions*/
uint32_t randPrime(int k){
    uint32_t randomPrime;
    randomPrime = randNum(k);
    bool flag = primality(randomPrime);

    // while the randomNumber generated is not a prime, generate a new number
    while(flag == false){
        randomPrime = randNum(k);
        flag = primality(randomPrime);
    }

    return randomPrime;
}


// this calculates the greatest common divisor of two numbers
uint32_t gcd(uint32_t a, uint32_t b) {
  while (b > 0) {
    a %= b;

    // now swap them
    uint32_t tmp = a;
    a = b;
    b = tmp;
  }
  return a;
}

// this generates the public key
uint32_t generate_e(uint32_t phi_n){
    uint32_t e = randNum(16);
    uint32_t cdenominator = gcd(e,phi_n);
    while (cdenominator != 1){
        e = randNum(16);
        cdenominator = gcd(e,phi_n);
    }
    return e;
}

// this generates the private key
uint32_t generate_d(uint32_t phi_n, uint32_t e){
    uint32_t r[40], s[40], t[40], q;
    int i = 1;
    r[0] = phi_n; r[1] = e;
    s[0] = 1; s[1] = 0;
    t[0] = 0; t[1] = 1;

    while(r[i] > 0){
        q = r[i - 1]/r[i];
        r[i+1] = r[i-1] - q*r[i];
        s[i+1] = s[i-1] - q*s[i];
        t[i+1] = t[i-1] - q*t[i];
        i = i + 1;
    }

    uint32_t d = t[i-1];

    return d;
}

/* this function generates the values of e (the current arduino's public key)
d (the current arduino's private key) and n (the current arduino's modulus)*/
uint32_t keyGenerators(uint32_t &e, uint32_t &d, uint32_t &n){
    uint32_t p = randPrime(15);
    uint32_t q = randPrime(16);
    n = p * q;
    uint32_t totient = (p-1)*(q-1);
    e = generate_e(totient);
    d = generate_d(totient, e);

    return 0;
}


//this is the function that implements the handshake protocol
void handshake(uint32_t &d, uint32_t &e, uint32_t &n, uint32_t &m){
    keyGenerators(e, d, n);

    enum clientStates {
        start, waitingForAck, clientDataExchange
    };

    enum serverStates {
        listen, waitingForKey, waitForAck, serverDataExchange
    };
    bool client;
    int pin = 13;
    if (digitalRead(pin) == LOW){
        client = true;
    }else{
        client = false;
    }

    char ack = 'A';
    char cr = 'C';

    // skey: server's public key; smod: server's modulus
    // ckey: client's public key; cmod: client's modulus
    uint32_t skey, smod, ckey, cmod;

    if (client == true){
        clientStates state = start;

        while(state != clientDataExchange){
            if (state == start){
                ckey = e;
                cmod = n;
                // send CR(ckey,cmod)
                Serial3.write(cr);
                uint32_to_serial3(ckey);
                uint32_to_serial3(cmod);

                state = waitingForAck;
            }
            else if (state == waitingForAck){
                // if it receives ACK(skey,smod)
                if(wait_on_serial3(9,1000) == true && Serial3.read() == ack){
                    // store skey and smod and send ACK
                    skey = uint32_from_serial3();
                    smod = uint32_from_serial3();
                    Serial3.write(ack);
                    state = clientDataExchange;
                }
                else{ 
                        // this is to consume all unnecessary characters
                        while(Serial3.available() > 0){
                            Serial3.read();
                        }
                        state = start;
                }
            }
        }
        m = smod;
        e = skey;
    }
    else{
        serverStates state = listen;
        bool second = false;

        while(state != serverDataExchange){
            if (state == listen){
                if(wait_on_serial3(1,1000) == true && Serial3.read() == cr){
                    state = waitingForKey;
                }else{
                    while(Serial3.available() > 0){
                        Serial3.read();
                    }
                }
            }
            else if (state == waitingForKey){
                if(wait_on_serial3(8,1000) == true){
                    //store ckey and cmod
                    ckey = uint32_from_serial3();
                    cmod = uint32_from_serial3();

                    // if it hasn't done this before
                    if(second == false){
                        // send ACK(skey,smod)
                        skey = e;
                        smod = n;
                        Serial3.write(ack);
                        uint32_to_serial3(skey);
                        uint32_to_serial3(smod);
                    }
                    state = waitForAck;
                }else{
                    state = listen;
                }
            }
            else if (state == waitForAck){
                second = true;
                if(wait_on_serial3(1,1000) == true){
                    char readByte = Serial3.read();
                    if (readByte == ack){
                        state = serverDataExchange;
                    }else if (readByte == cr){
                        state = waitingForKey;
                    }else{
                        state = listen;
                    }
                }else{
                    state = listen;
                }
            }
        }
        m = cmod;
        e = ckey;
    }
}


int main(){
    setup();
    uint32_t d, n, e, m;

    /* after the handshake,
    n is the current arduino's modulus, m is the other arduino's modulus
    d is the current arduino's private key, e is the the other arduino's public key*/
    handshake(d, e, n, m);

    // Display "Ready" after the handshake
    Serial.println("Ready for Chat!");

    // Get rid of any extra bytes so they don't interfere with the communication
    Serial3.flush();

    while (true){
        sendChar(e,m);
        receiveChar(d,n);
    }

    Serial.flush();
    Serial3.flush();
    return 0;

}