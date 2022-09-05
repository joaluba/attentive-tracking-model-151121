function T = f0f1f2_jl(duration_ms, rate,F0_range,stepsize)
% Created by Kevin Woods 
% Edited by Joanna Luberadzka
sr=16000;

f0range = 12; % contour is scaled so that max(abs(ST from mean)) equals f_range
f1range = 9;
f2range = 9;
a=(stepsize/1000)*sr;
contour = gnoise(200000,0.01,rate*(2^.5),-20,1,sr);
contour = contour - mean(contour);
contour = contour(ceil(length(contour)/10):length(contour))./max(abs(contour(ceil(length(contour)/10):length(contour)))); 
vec=1:1:(length(contour)-((duration_ms/1000)*sr));
f0_r=200*2.^((12*contour(vec))/12);
idx_f0=find(f0_r>F0_range(1) & f0_r<F0_range(2));
while isempty(idx_f0)
contour = gnoise(200000,0.01,rate*(2^.5),-20,1,sr);
contour = contour - mean(contour);
contour = contour(ceil(length(contour)/10):length(contour))./max(abs(contour(ceil(length(contour)/10):length(contour)))); 
vec=1:1:(length(contour)-((duration_ms/1000)*sr));
f0_r=200*2.^((12*contour(vec))/12);
idx_f0=find(f0_r>F0_range(1) & f0_r<F0_range(2));
end
r = idx_f0(randi(length(idx_f0)));
T(:,1) =0.1*2000.* 2.^((f0range.*contour(r:a:r+(duration_ms/1000)*sr))./12);

r = abs(randi(length(contour)-((duration_ms/1000)*sr)));
T(:,2) = 550.* 2.^((f1range.*contour(r:a:r+(duration_ms/1000)*sr))./12);

r = abs(randi(length(contour)-((duration_ms/1000)*sr)));
T(:,3) = 1500.* 2.^((f2range.*contour(r:a:r+(duration_ms/1000)*sr))./12);

T(:,4)=0;

end

