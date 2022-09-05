    function p=trapzprobability(gm,G_ch)
        binwidth=0.00001;
        x1=G_ch-(binwidth/2);
        x2=G_ch+(binwidth/2);       
        y1=pdf(gm,x1);
        y2=pdf(gm,x2);
        p=(x2-x1).*(y1+y2)/2;
        %p=max(p,realmin);
    end
