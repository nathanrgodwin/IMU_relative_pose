clear variables
close all
collectData = 1;
install = 0;
if (collectData==1)
    if (install == 1)
        !install_supportsoftware.exe
    end
    !matlab /r datalog_slave &
    datalog
end
imshow('stop.jpg')
pause(10);
align_data

