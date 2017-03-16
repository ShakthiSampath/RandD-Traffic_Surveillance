%=====================Reading Video Frame By Frame========================
v = VideoReader('Camera Highway Surveillance.mp4');
while hasframe(v)
    video = readFrame(v);
end

    