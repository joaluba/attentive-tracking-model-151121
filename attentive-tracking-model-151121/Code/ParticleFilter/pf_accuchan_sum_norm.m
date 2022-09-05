function W =pf_accuchan_sum_norm(W_tmp)
% Function to integrate likelihood across frequency channels
% ---------- Input: ------------
% W_tmp - matrix with weights for each particle and each channel
% ---------- Output: ------------
% W - vector with weights for each particle
% -------------------------------------------

[K C]=size(W_tmp);

W_tmp=W_tmp./sum(W_tmp);

for k=1:K
    W(k)=sum(W_tmp(k,:));
end
end

