%% NONCrossing calc

function [noncrossing_ok] = noncrossingf0_calc_jl(A, B)


d_f0 = A(:,1) - B(:,1);
d_f1 = A(25:(end-25),2) - B(25:(end-25),2);
d_f2 = A(25:(end-25),3) - B(25:(end-25),3);

if sum(abs(diff(sign(d_f0)))) <=0 && ...
   sum(abs(diff(sign(d_f1)))) <=0 && ...
   sum(abs(diff(sign(d_f2)))) <=0  
   
  noncrossing_ok = 1;

else
    
  noncrossing_ok = 0;
    
end