close all;
clc;
%===========Declarations======================
o_centroid=zeros(20,2);
n_centroid=zeros(20,2);
source = VideoReader('video1.mp4');
nFrames = source.CurrentTime;
adptthreshold = 35;

mov(1).cdata = readFrame(source,'native');
bg = mov(1).cdata;
bg_bw = rgb2gray(bg);

% ----------------------- set frame size variables -----------------------

fr_size = size(bg);
wdth = fr_size(2);
height = fr_size(1);
fg = zeros(height, wdth);
fg=uint8(fg);

% --------------------- process frames -----------------------------------
i = 1;
mov(i).cdata = readFrame(source,'native');
for i = 10:nFrames
    fr = mov(i).cdata;
    fr_bw = rgb2gray(fr);
    fr_diff = abs(double(fr_bw) - double(bg_bw));% differencing.
    for j=1:wdth
        for k=1:height
            if ((fr_diff(k,j) > adptthreshold))
                if (k>250 && j<1000)
                    fg(k,j) = 255;
                else
                    fg(k,j)=0;
                end
            else
                fg(k,j) = 0;
            end
        end
    end

%---------different morphological operations----------------
    fg = bwconvhull(fg,'objects');
    fg=imfill(fg,'holes');
    se = strel('square',4);
    fg=imclose(fg,se);
    fg=imfill(fg,'holes');
    fg = bwareaopen(fg,500);
    fg1=fg;

%output(:,:,:,i) = fg1;(use this to check binary image.(implay fucntion) below)

%--------------------Bounding box tracking-----------------------------
    tracking=regionprops(fg1,'basic');
    % message = sprintf('This image has %d blobs in it', length(tracking));
    %uiwait(helpdlg(message));
    n_centroid=cat(1,tracking.Centroid);
    if size(n_centroid,1)< size(o_centroid,1)
        v1=o_centroid(1:size(n_centroid,1),:);
        v2=n_centroid;
        v3=v2;
    else
        v1=n_centroid(1:size(o_centroid,1),:);
        v2=o_centroid;
        v3=v1;
    end

%---------------------speed calculation-----------------------------------

    v=pdist2(v1,v2);
    v=diag(v);
    v = v*2.4;
    v = v1-v2;
    v= ((sum(v.^2,2)).^1/2)*0.72; %assuming 24fps and k is calibration factor to be calculated.
    %v is a coloumn vector of velocities.
    o_centroid=n_centroid;

%-------------------all plottings on image-------------------------

    figure(1);
    imshow(fr);
    hold on
    for indices=1:length(tracking)
        box=tracking(indices).BoundingBox;
        plot(tracking(indices).Centroid(1),tracking(indices).Centroid(2),'g*');%centroid
        text(v3(:,1)+10,v3(:,2)+10,num2str(v),'Color','red');%speed plotting
        rectangle('position',box,'Edgecolor','red','LineWidth',2);%bounding box
    end
    
    hold off
    p=0.95;
    bg_bw = p*bg_bw + (1-p)*fr_bw;
    sum=0;
    for a=1:9
        sum=sum+fr_bw(a*height/10,wdth/10)+fr_bw(a*height/10,2*wdth/10)+fr_bw(a*height/10,3*wdth/10)+fr_bw(a*height/10,4*wdth/10)+fr_bw(a*height/10,5*wdth/10)+fr_bw(a*height/10,6*wdth/10)+fr_bw(a*height/10,7*wdth/10)+fr_bw(a*height/10,8*wdth/10)+fr_bw(a*height/10,9*wdth/10);
    end
    
    avg=sum/81;
    adptthresold=0.032*avg+30;
end