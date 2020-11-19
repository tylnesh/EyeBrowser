# EyeBrowser

A chromium-based web browser specialized on injecting gaze and pupil tracking code into regular webpages written in QT (QML / C++). 

Requirements for building it in QtCreator with qmake and running:

- qtquick
- qtquickcontrols 
- qtwebengine

In Ubuntu 20.04:
> sudo apt install qtdeclarative5-dev qtwebengine5-dev qml-module-qtquick-controls2 qml-module-qtwebengine 


To enable flash support, extract adobe flash plugin into your home folder and run the application with these options: 

--enable-pepper-testing --ppapi-flash-path=~/libpepflashplayer.so --no-sandbox
