%Set up objects.

videoReader = vision.VideoFileReader('Camera Highway Surveillance.mp4','ImageColorSpace','Intensity','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter; 
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);
%opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom', 'CustomBorderColor', 255);
videoPlayer = vision.VideoPlayer('Name','Motion Vector');

%Convert the image to single precision, then compute optical flow for the video. Generate coordinate points and draw lines to indicate flow. Display results.

while ~isDone(videoReader)
    frame = step(videoReader);
    im = step(converter, frame);
    VSQ = step(opticalFlow, im);
    lines = videooptflowlines(VSQ, 20);
    if ~isempty(lines)
      out =  step(shapeInserter, im, lines); 
      step(videoPlayer, out);
    end
end
%Close the video reader and player

release(videoPlayer);
release(videoReader);