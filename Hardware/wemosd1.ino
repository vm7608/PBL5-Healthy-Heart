#include "FirebaseESP8266.h"
#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#define WIFI_SSID "7608"
#define WIFI_PASSWORD "76087608"
#define FIREBASE_HOST "****" // Điền vào địa chỉ của project firebase của bạn
#define FIREBASE_AUTH "****" // Điền vào mã token của project firebase của bạn
FirebaseData firebaseData;
FirebaseJson json;

// Khai báo các biến cần sử dụng
int sampleIndex = 0;
int run = 0;

String path = "sensor";


const int heartPin = A0;
const int buzzPin = 13;

LiquidCrystal_I2C lcd(0x27, 16, 2);


void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  // Set up cho lcd
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Connecting...");
  Firebase.setInt(firebaseData, "/isconnected", 0);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
  if (!Firebase.beginStream(firebaseData, path)) {
    Serial.println("REASON: " + firebaseData.errorReason());
    Serial.println();
  }

  Serial.print("Connected! IP address: ");
  Serial.println(WiFi.localIP());
  Serial.println("");
  lcd.setCursor(0, 0);
  lcd.print("Connected!   ");
}

void loop() {
  // Đọc biến run từ Firebase
  if (Firebase.getInt(firebaseData, "/run")) {
    if (firebaseData.dataType() == "int") {
      run = firebaseData.intData();
      delay(1);
    }
  } else {
    Serial.println(firebaseData.errorReason());
    run = 0;
  }

  if (run == 1) {
    Serial.println("Start!");

    lcd.setCursor(0, 1);
    lcd.print("Sensor is on! ");


    String data = "";
    for (int i = 0; i < 1600; i++) {
      if (i == 1599) {
        data += String(analogRead(A0));
      } else {
        data += String(analogRead(A0)) + ",";
      }
      tone(buzzPin, 250, 10);
      delay(30);
    }


    Firebase.setString(firebaseData, "/data", data);
    Firebase.setInt(firebaseData, "/run", 0);


    Serial.println("Done!");
    Serial.println(data.length());

    
  } else {
    Serial.println("Sensor is off!");
    lcd.setCursor(0, 1);
    lcd.print("Sensor is off!");
  }
}