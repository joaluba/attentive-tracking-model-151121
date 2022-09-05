function col=double2rgb(x,colormapname)
mini=min(x);
maxi=max(x);
vals=linspace(mini,maxi,length(colormapname));
% y=floor(((x-mini)/ran))+1; 
col=zeros(length(x),3);
p=colormap(colormapname);
for i=1:length(x)
    [v idx]=min(abs(vals-x(i)));
    col(i,:)=p(idx,:);
end