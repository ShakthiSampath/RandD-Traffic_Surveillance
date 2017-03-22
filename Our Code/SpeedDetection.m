%  Steps to be followed
%     1) Read an input video and variable intialization
%     2) Extract the first frame as the backgorund frame
%     3) Apply background subtraction on the subsequent video frames, and
%     some morphological operations
%     4) Calculate the area of the detected object
%     5) If object is of interset , track the motion of the object
%     6) Find the centroid,add bounding box on the detected object and speed detection of the object.

% Read an input video and variable intialization
format shortG;
source = VideoReader('Camera Highway Surveillance.mp4');
% source = VideoReader('video.mp4');
nFrames = source.NumberOfFrames;
threshold = 60;
n_centroid = zeros(20,2);
o_centroid = zeros(20,2);

% Extract the first frame
mov(1).cdata = read(source,1);
ref_img = mov(1).cdata;
imshow(ref_img);
ref_img = rgb2gray(ref_img);
ref_img = double(ref_img);
[h,w] = size(ref_img);

% static brute-force background
% ref_img = imread('ref_img.png');
% imshow(ref_img);
% ref_img = double(ref_img);

old_frame_number = 1; 
% nFrames = 180;

for x = 2:5:nFrames
%   Background subtraction and other morhpological operations
    mov(x).cdata = read(source,x);
    frame = mov(x).cdata; 
    frame_bw = rgb2gray(frame);
    frame_bw = double(frame_bw);
    frame_diff = frame_bw - ref_img;
    frame_diff = uint8(frame_diff);
    
    for i = 1:h
        for j = 1:w
            if(frame_diff(i,j) >= threshold)
%                thresholding is done only on the objects that are in this
%                ,range -> Main area (object will be tracked here!) 
                if (i > 250 && i < 1050)  
                    frame_diff(i,j) = 255;
                else
                    frame_diff(i,j) = 0;
                end
            else
                  frame_diff(i,j) = 0;
            end    
        end
    end
    new_frame_number = x;
    
    %Morphological Operations performed - 
    frame_diff = bwconvhull(frame_diff,'objects');
    frame_diff = imfill(frame_diff,'holes');
    frame_diff = bwareaopen(frame_diff,900,8);

    %   Object tracking
    track_objects = regionprops(frame_diff,'basic');
    n_centroid = cat(1,track_objects.Centroid);

    %   Calling Speed function that will calculate the speed of the object
    speed = SpeedDetectionFunction(old_frame_number,new_frame_number);
    if size(n_centroid,1)< size(o_centroid,1)
         v1 = o_centroid(1:size(n_centroid,1),:);
         v2 = n_centroid;
         v3 = v2;
     else
        v1 = n_centroid(1:size(o_centroid,1),:);
        v2 = o_centroid;
        v3 = v1;
    end
    
%      ZoneMarking(new_frame_number);
    imshow(frame);

    %   Applying bounding boxes on the tracked object 
    hold on 
        for index = 1:length(track_objects)
            box = track_objects(index).BoundingBox;
            plot(track_objects(index).Centroid(1),track_objects(index).Centroid(2),'b*');
            text(v3(:,1)+10,v3(:,2)+10,num2str(speed),'Color','red');
            rectangle('position',box,'Edgecolor','green','LineWidth',2);
        end
        movegui(gcf);
        F(x) = getframe(figure(1));
    hold off  

    %     Updating the old_frame_number
    if(old_frame_number > 50)
        old_frame_number = x - 50;
    end
end
message = sprintf('Speed of the object after exiting the main area is: %.3f',speed);
helpdlg(message);