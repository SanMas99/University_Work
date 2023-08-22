#include <iostream>
#include <iomanip>
#include <cmath>
using namespace std;


unsigned int phi(unsigned int n){
	double result = n;
	unsigned int p=2;
	bool IsPrime;
	while (p<=sqrt(n)){
		if (n%p !=0){
			if (p==2){
				p+=1;//if it cant, add 1 to p as next prime is 3
			}else{
				p+=2;//if it cant, add 2 to p as no even number can be prime, to reduce run time
			}
		}else{
			while (n%p==0){
				n=n/p;//keep dividing n by p until it no longer can
			}
			result=(result/p)*(p-1);//updates result with current prime	
			}
	}
	if (n>1){
		result =(result/n)*(n-1);
	}
	return result;
}
uint32_t gcd_euclid_fast(uint32_t a, uint32_t b) {
  while (b > 0) {// will stop when b==0
    a %= b;
    // swaps a and b
    uint32_t tmp = a;
    a = b;
    b = tmp;
  }
  return a; // b is 0
}

int main(){
	unsigned int Number;
	int NoOfPrime = 0;
	cin>>Number;
	int GCD;
	double phi_n=phi(Number);
	cout<<"n"<<setw(13)<<"= "<<Number<<endl;
	cout<<"phi(n)"<<setw(8)<<"= "<<fixed<<std::setprecision(0)<<phi_n<<endl;//Prevent scientific notation being used
	cout<<"phi(n)/n"<<setw(6)<<"= "<<std::fixed<< std::setprecision(5)<<(double(phi_n)/double(Number))+0.00000<<endl;//Prints out value to 5 d.p
	if (Number>=32768){//Checks if it is greater than or equal to 2^15
		for (unsigned int i =16384; i<32768; i++){//loops from 2^14 to 2^15
			GCD=gcd_euclid_fast(i,Number);
			if (GCD==1){
					NoOfPrime=NoOfPrime+1;
				}
			}
			cout<<"15-bit test"<<setw(3)<<"= "<<std::fixed<< std::setprecision(5)<<(double(NoOfPrime)/16384)+0.00000<<endl;
		}
	}

