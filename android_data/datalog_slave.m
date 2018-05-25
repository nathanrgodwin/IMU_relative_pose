%% Data Collection -- Slave
connector('off');
connector('on','ece251b');
clear m
m = mobiledev;
disp('Waiting for mobile connection');
waitfor(m, 'Connected');
pause(1);
disp('Mobile connection established');
m.SampleRate = 100;
m.AccelerationSensorEnabled = 1;
m.AngularVelocitySensorEnabled = 1;
m.OrientationSensorEnabled = 1;
m.MagneticSensorEnabled = 1;
warning ('off','all');
%Check if other collector ready
DateString = split(datestr(datetime));
fid = fopen([cell2mat(DateString(1)) '_connection.log'], 'wt');
fclose(fid);
disp('Waiting for other mobile connection');
while(exist([cell2mat(DateString(1)) '_connection.log'], 'file'))
end
disp('Other mobile connection established');

currTime = datetime;
minute = currTime.Minute;
second = currTime.Second;
waitminute = minute;
waitsecond = 0;
if (second < 55)
    waitsecond = ceil(second/5)*5;
else
    waitminute = minute+1;
    waitsecond = 0;
end
currTime = datetime;
while (currTime.Minute < waitminute || currTime.Second < waitsecond)
    currTime = datetime;
end

discardlogs(m);

disp('Beginning data collection');
m.Logging = 1;
currTime = datetime;
disp(currTime);

while(exist([cell2mat(DateString(1)) '_connection.log'], 'file'))
end

currTime = datetime;
minute = currTime.Minute;
second = currTime.Second;
waitminute = minute;
waitsecond = 0;
if (second < 55)
    waitsecond = ceil(second/5)*5;
else
    waitminute = minute+1;
    waitsecond = 0;
end
currTime = datetime;
while (currTime.Minute < waitminute || currTime.Second < waitsecond)
    currTime = datetime;
end

m.Logging = 0;
disp('Data logging ended');
currTime = datetime;
disp(currTime);
disp('Disconnecting sensors');
m.AccelerationSensorEnabled = 0;
m.AngularVelocitySensorEnabled = 0;
m.OrientationSensorEnabled = 0;
m.MagneticSensorEnabled = 0;

acceldata = accellog(m);
angveldata = angvellog(m);
magfielddata = magfieldlog(m);
orientdata = orientlog(m);
disp(['Initial timestamp is ' m.InitialTimestamp]);


connector off;


maxsize = max([size(acceldata,1), size(angveldata,1), size(magfielddata,1), size(orientdata,1)]);


data = [repmat(size(acceldata,1),1,3),...
        repmat(size(angveldata,1),1,3),...
        repmat(size(magfielddata,1),1,3),...
        repmat(size(orientdata,1),1,3)];
data = [data; ...
        [[acceldata;zeros(maxsize-size(acceldata,1),3)],...
        [angveldata;zeros(maxsize-size(angveldata,1),3)],...
        [magfielddata;zeros(maxsize-size(magfielddata,1),3)],...
        [orientdata;zeros(maxsize-size(orientdata,1),3)]]];

dateString = datestr(now,'mm_dd_yyyy_HH_MM');
    
csvwrite(['sensor_data2_' dateString '.csv'], data);
exit;