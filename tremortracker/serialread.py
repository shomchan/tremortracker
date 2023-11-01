import serial #this is the pyserial library
import time

arduino = serial.Serial(port='COM6', baudrate=9600) #pretty self explanatory, change com6 to whatever serial port is the arduino

def write_read(x):
    arduino.write(bytes(x, 'utf-8'))
    time.sleep(0.05)
    data = arduino.readline()
    return data

print(arduino.readline())
time.sleep(0.501)
arduino.write(bytes('start', 'utf-8')) #this sends 'start' to the arduino (arduino code has a loop to wait for start then go for 30s)

with open('static03.txt', 'w') as file: #creates test.txt in current directory
    while True:
        serialin=arduino.readline().decode('utf-8', 'strict').split('\n')[0]
        print(serialin) #prints in command line for you to see, optional
        file.write(serialin) #prints in file
        file.flush() #updates the file continuously rather than at the end
        #time.sleep(0.1)