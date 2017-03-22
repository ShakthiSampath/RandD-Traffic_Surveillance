function [ speed ] = SpeedDetectionFunction(old_frame_number,new_frame_number)
source = VideoReader('Camera Highway Surveillance.mp4');
% source = VideoReader('video.mp4');
nFrames = source.NumberOfFrames;
i_center = zeros(1,2);
j_center = zeros(1,2);

    if(old_frame_number == new_frame_number)
        speed = 0;
    else
        mov(old_frame_number).cdata = read(source,old_frame_number);
        ref_img = mov(old_frame_number).cdata;
        ref_img = rgb2gray(ref_img);
        ref_img = double(ref_img);
        track_old = regionprops(ref_img,'basic');
        i_center = track_old.Centroid;

        mov(new_frame_number).cdata = read(source,new_frame_number);
        frame = mov(new_frame_number).cdata; 
        frame_bw = rgb2gray(frame);
        frame_bw = double(frame_bw);
        frame_diff = frame_bw - ref_img;
        frame_diff = uint8(frame_diff);

        track_objects = regionprops(frame_diff,'basic');
        j_center = track_objects.Centroid;
        v = pdist2(j_center,i_center);
        speed = (v/30)*2.4;
        display(speed);
    end
end

