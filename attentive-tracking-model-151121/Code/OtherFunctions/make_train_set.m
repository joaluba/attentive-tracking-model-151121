function [g, s]=make_train_set(T_s_GT,oset_feat)
N=size(T_s_GT);
g=[];s=[];
for n=1:N
    g=[g oset_feat{n}];
    M_all=size(oset_feat{n},2);
    s=[s repmat(T_s_GT(n,:)',1,M_all)];
end