#include <MPU9250.h>
#include <quaternionFilters.h>


#define includeMag false         // Set to false for basic data read
#define dataRate 100 //in ms

// Pin definitions
int intPin0 = 2;  // These can be changed, 2 and 3 are the Arduinos ext int pins
int intPin1 = 3;
int myLed  = 13;  // Set up pin 13 led for toggling

MPU9250 myIMU0;
MPU9250 myIMU1;

void init_imu(MPU9250 *, unsigned char);
void getData(MPU9250 *);

void setup()
{
  Wire.begin();
  // TWBR = 12;  // 400 kbit/sec I2C speed
  Serial.begin(115200);

  // Set up the interrupt pin, its set as active high, push-pull
  pinMode(intPin0, INPUT);
  digitalWrite(intPin0, LOW);

  // Set up the interrupt pin, its set as active high, push-pull
  pinMode(intPin1, INPUT);
  digitalWrite(intPin1, LOW);
  
  pinMode(myLed, OUTPUT);
  digitalWrite(myLed, LOW);
  
  delay(1000);
  
  init_imu(&myIMU0, 0, false);
  init_imu(&myIMU1, 1, false);

}


void loop()
{ 
  getData(&myIMU0);
  getData(&myIMU1);
}

void getData(MPU9250 * imu){
  if (imu->readByte(imu->getAddress(), INT_STATUS) & 0x01){
    //Get acceleration data
    imu->readAccelData(imu->accelCount);
    imu->ax = (float)imu->accelCount[0]*imu->aRes;
    imu->ay = (float)imu->accelCount[1]*imu->aRes;
    imu->az = (float)imu->accelCount[2]*imu->aRes;

    imu->readGyroData(imu->gyroCount);
    imu->gx = (float)imu->gyroCount[0] * imu->gRes;
    imu->gy = (float)imu->gyroCount[1] * imu->gRes;
    imu->gz = (float)imu->gyroCount[2] * imu->gRes;

    imu->mx = (float)imu->magCount[0] * imu->mRes
               * imu->factoryMagCalibration[0] - imu->magBias[0];
    imu->my = (float)imu->magCount[1] * imu->mRes
               * imu->factoryMagCalibration[1] - imu->magBias[1];
    imu->mz = (float)imu->magCount[2] * imu->mRes
               * imu->factoryMagCalibration[2] - imu->magBias[2];
               
    imu->updateTime();
  }

    // Sensors x (y)-axis of the accelerometer is aligned with the y (x)-axis of
  // the magnetometer; the magnetometer z-axis (+ down) is opposite to z-axis
  // (+ up) of accelerometer and gyro! We have to make some allowance for this
  // orientationmismatch in feeding the output to the quaternion filter. For the
  // MPU-9250, we have chosen a magnetic rotation that keeps the sensor forward
  // along the x-axis just like in the LSM9DS0 sensor. This rotation can be
  // modified to allow any convenient orientation convention. This is ok by
  // aircraft orientation standards! Pass gyro rate as rad/s
  MahonyQuaternionUpdate(imu->ax, imu->ay, imu->az, imu->gx * DEG_TO_RAD,
                         imu->gy * DEG_TO_RAD, imu->gz * DEG_TO_RAD, imu->my,
                         imu->mx, imu->mz, imu->deltat);

  imu->delt_t = millis() - imu->count;
  if (imu->delt_t > dataRate){ //MAYBE INCREASE THIS
    Serial.print(1000*imu->ax);
    Serial.print(", ");
    Serial.print(1000*imu->ay);
    Serial.print(", ");
    Serial.print(1000*imu->az);
    Serial.print(", ");
    Serial.print(imu->gx, 3);
    Serial.print(", ");
    Serial.print(imu->gy, 3);
    Serial.print(", ");
    Serial.print(imu->gz, 3);
    Serial.print(",");
    if (includeMag){
      Serial.print(" ");
      Serial.print(imu->mx);
      Serial.print(", ");
      Serial.print(imu->my);
      Serial.print(", ");
      Serial.print(imu->mz);
      Serial.println(",");
    }
    imu->count = millis();
    digitalWrite(myLed, !digitalRead(myLed));  // toggle led
    Serial.print("\n");
    
  }
}


void init_imu(MPU9250 * imu, unsigned char addr, bool serialPrint){
  if (serialPrint){
    Serial.print("-------------------------------------------------\n");
    Serial.print("           Starting device: ");
    Serial.print(addr);
    Serial.print("\n-------------------------------------------------\n");
  }
  imu->setAddress(addr);

  // Read the WHO_AM_I register, this is a good test of communication
  byte c = imu->readByte(imu->getAddress(), WHO_AM_I_MPU9250);
  if (serialPrint){
    Serial.print(F("MPU9250 I AM 0x"));
    Serial.print(c, HEX);
    Serial.print(F(" I should be 0x"));
    Serial.println(0x73, HEX);
  }

  if (c == 0x73) // WHO_AM_I should always be 0x73
  {
    if (serialPrint)
      Serial.println(F("MPU9250 is online..."));

    // Start by performing self test and reporting values
    imu->MPU9250SelfTest(imu->selfTest, serialPrint);
    if (serialPrint){
      Serial.print(F("x-axis self test: acceleration trim within : "));
      Serial.print(imu->selfTest[0],1); Serial.println("% of factory value");
      Serial.print(F("y-axis self test: acceleration trim within : "));
      Serial.print(imu->selfTest[1],1); Serial.println("% of factory value");
      Serial.print(F("z-axis self test: acceleration trim within : "));
      Serial.print(imu->selfTest[2],1); Serial.println("% of factory value");
      Serial.print(F("x-axis self test: gyration trim within : "));
      Serial.print(imu->selfTest[3],1); Serial.println("% of factory value");
      Serial.print(F("y-axis self test: gyration trim within : "));
      Serial.print(imu->selfTest[4],1); Serial.println("% of factory value");
      Serial.print(F("z-axis self test: gyration trim within : "));
      Serial.print(imu->selfTest[5],1); Serial.println("% of factory value");
    }

    // Calibrate gyro and accelerometers, load biases in bias registers
    imu->calibrateMPU9250(imu->gyroBias, imu->accelBias);

    imu->initMPU9250();
    // Initialize device for active mode read of acclerometer, gyroscope, and
    // temperature
    if (serialPrint)
      Serial.println("MPU9250 initialized for active data mode....");

    // Read the WHO_AM_I register of the magnetometer, this is a good test of
    // communication
    byte d = imu->readByte(AK8963_ADDRESS, WHO_AM_I_AK8963);
    if (serialPrint){
      Serial.print("AK8963 ");
      Serial.print("I AM 0x");
      Serial.print(d, HEX);
      Serial.print(" I should be 0x");
      Serial.println(0xFF, HEX);
    }

    
    // Get magnetometer calibration from AK8963 ROM
    imu->initAK8963(imu->factoryMagCalibration);
    // Initialize device for active mode read of magnetometer
    if (serialPrint)
      Serial.println("AK8963 initialized for active data mode....");

    if (serialPrint)
    {
      //  Serial.println("Calibration values: ");
      Serial.print("X-Axis factory sensitivity adjustment value ");
      Serial.println(imu->factoryMagCalibration[0], 2);
      Serial.print("Y-Axis factory sensitivity adjustment value ");
      Serial.println(imu->factoryMagCalibration[1], 2);
      Serial.print("Z-Axis factory sensitivity adjustment value ");
      Serial.println(imu->factoryMagCalibration[2], 2);
    }

    // Get sensor resolutions, only need to do this once
    imu->getAres();
    imu->getGres();
    imu->getMres();

    // The next call delays for 4 seconds, and then records about 15 seconds of
    // data to calculate bias and scale.
    if (includeMag)
      imu->magCalMPU9250(imu->magBias, imu->magScale);
    if (serialPrint){
      Serial.println("AK8963 mag biases (mG)");
      Serial.println(imu->magBias[0]);
      Serial.println(imu->magBias[1]);
      Serial.println(imu->magBias[2]);
  
      Serial.println("AK8963 mag scale (mG)");
      Serial.println(imu->magScale[0]);
      Serial.println(imu->magScale[1]);
      Serial.println(imu->magScale[2]);
      delay(2000); // Add delay to see results before serial spew of data
      Serial.println("Magnetometer:");
      Serial.print("X-Axis sensitivity adjustment value ");
      Serial.println(imu->factoryMagCalibration[0], 2);
      Serial.print("Y-Axis sensitivity adjustment value ");
      Serial.println(imu->factoryMagCalibration[1], 2);
      Serial.print("Z-Axis sensitivity adjustment value ");
      Serial.println(imu->factoryMagCalibration[2], 2);
    }
  }else{
    if (serialPrint)
      Serial.println("Error connecting to IMU");
  }
}
