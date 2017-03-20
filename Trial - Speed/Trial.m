%===================== Declarations ======================================
numFrames = 0;

%===================== Reading Video Frame By Frame ======================

v = VideoReader('Camera Highway Surveillance.mp4');
currAxes = axes;% axes made
v.CurrentTime = 13;
while hasFrame(v)
    vidFrame = readFrame(v);
    numFrames = numFrames+1;
    image(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    pause(1/v.FrameRate);
end
% disp(numFrames);
