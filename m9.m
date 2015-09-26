clear all;
clc;
vidDevice = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ...
'ROI', [1 1 640 480], ...
'ReturnedColorSpace', 'rgb');

hVideoIn = vision.VideoPlayer;
hVideoIn.Name = 'Original Video';
hVideoIn.Position = [30 100 640 480];

hVideoOut = vision.VideoPlayer;
hVideoOut.Name = 'Fingers Tracking Video';
hVideoOut.Position = [700 100 640 480];

while 1
    img = step(vidDevice);
    out=skinDetect2Func(img);
    step(hVideoIn, img);
    step(hVideoOut,out);
end
release(hVideoOut);
release(hVideoIn);