%===================== Declarations ======================================
numFrames = 0;

%===================== Reading Video Frame By Frame ======================

v = VideoReader('Camera Highway Surveillance.mp4');
currAxes = axes; % axes made
v.CurrentTime = 13;
while hasFrame(v)
    vidFrame = readFrame(v);
    image(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    pause(1/v.FrameRate);
    numFrames = numFrames+1;
end
%disp(numFrames);

% ==================== Function for Bounding Box ========================

function B = B_box(frame)

bg = frame.cdata;
bg_bw = rgb2gray(bg);

%----- set frame size variables -----

fr_size = size(bg);
wdth = fr_size(2);
height = fr_size(1);
fg = zeros(height, wdth);
fg=uint8(fg);
end



function f = fact(n)
    f = prod(1:n);
end
