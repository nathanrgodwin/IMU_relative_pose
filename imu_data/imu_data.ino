#include <SparkFunMPU9250-DMP-modified.h> //IMU library, modified to support 2 IMUs

#define INTERRUPT_PIN 

MPU9250_DMP imu1;
MPU9250_DMP imu2;


void setup(){
  a = imu1.begin();
  b = imu2.begin();
  Serial.begin(57600);
  if (a != 0){
    Serial.print("Error initializing IMU1");
  }
  if (b != 0){
    Serial.print("Error initializing IMU2");
  }

  pinMode(INTERRUPT_PIN, INPUT_PULLUP);

}

void loop(){
  
}
