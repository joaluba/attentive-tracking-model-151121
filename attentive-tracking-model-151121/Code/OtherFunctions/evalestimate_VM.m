function prob=evalestimate_VM(F0_GT,F0_EST)
% Function to compute a distance measure between the
% ground truth and estimated F0 using F0 observation 
% model (mixture of von mises). 
% contact: joanna.luberadzka@uni-oldenburg.de
N=11;
nn=[1:1:11];mm=[1:1:3];
for t=1:length(F0_GT)
    G_EST=(1./(nn*F0_EST(t)))'*mm;G_EST=G_EST(:);
    
    for n=1:N
        P0_GT(n)=1/(n*F0_GT(t));
        m_max_k=floor(0.0125./P0_GT(n));
        m_min_k=ceil(0.0014./P0_GT(n));
        P_n=[m_min_k:1:m_max_k]*P0_GT(n);
        nnorm(n)=1/length(P_n);
    end
    
    nnorm=nnorm./sum(nnorm);
    mu=0;
    C= 1/(2*pi*besseli(0,5,1));
    
    for i=1:length(G_EST)
        for n=1:N
            nturns=G_EST(i)*(n*F0_GT(t));
            theta=nturns*2*pi;
            [p_pure(i,n), ~]=circ_vmpdf(theta,mu,5,C);
            p(i,n)= p_pure(i,n)*nnorm(n);
        end
    end
prob(t)=sum(log(sum(p,2)));
end





% N=11;
% nn=[1:1:11];mm=[1:1:3];
% for t=1:length(F0_GT)
%     G_GT=(1./(nn*F0_GT(t)))'*mm;G_GT=G_GT(:);
%     
%     for n=1:N
%         P0_EST(n)=1/(n*F0_EST(t));
%         m_max_k=floor(0.0125./P0_EST(n));
%         m_min_k=ceil(0.0014./P0_EST(n));
%         P_n=[m_min_k:1:m_max_k]*P0_EST(n);
%         nnorm(n)=1/length(P_n);
%     end
%     
%     nnorm=nnorm./sum(nnorm);
%     mu=0;
%     C= 1/(2*pi*besseli(0,5,1));
%     
%     for i=1:length(G_GT)
%         for n=1:N
%             nturns=G_GT(i)*(n*F0_EST(t));
%             theta=nturns*2*pi;
%             [p_pure(i,n), ~]=circ_vmpdf(theta,mu,5,C);
%             p(i,n)= p_pure(i,n)*nnorm(n);
%         end
%     end
% prob(t)=sum(log(sum(p,2)));
% end
end
