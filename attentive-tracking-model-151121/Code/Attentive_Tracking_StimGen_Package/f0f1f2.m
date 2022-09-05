function [score] = f0f1f2(duration_ms, rate)

sr=16000;

f0range = 12; % contour is scaled so that max(abs(ST from mean)) equals f_range
f1range = 9;
f2range = 9;

contour = gnoise(20000,0.01,rate*(2^.5),-20,1,sr);
contour = contour - mean(contour);
contour = contour(ceil(length(contour)/10):length(contour))./max(abs(contour(ceil(length(contour)/10):length(contour)))); 

score(:,1) = 0:2:duration_ms;

r = abs(randi(int16(length(contour)-((duration_ms/1000)*sr))));
score(:,2) = 2000.* 2.^((f0range.*contour(r:32:r+(duration_ms/1000)*sr))./12);

score(2:length(score(:,1)),3) = 50;

r = abs(randi(length(contour)-((duration_ms/1000)*sr)));
score(:,4) = 550.* 2.^((f1range.*contour(r:32:r+(duration_ms/1000)*sr))./12);

r = abs(randi(length(contour)-((duration_ms/1000)*sr)));
score(:,5) = 1500.* 2.^((f2range.*contour(r:32:r+(duration_ms/1000)*sr))./12);


 
end

