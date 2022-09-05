function sig_out=mynormalize(sig_in,a,b,varargin)
sig_in_v=sig_in(:);
if ~isempty(varargin)
    range=varargin{1};
    sig_out = ((sig_in_v-range(1))*(b-a))./(range(2)-range(1)) + a;
else
    sig_out = ((sig_in_v-min(sig_in_v))*(b-a))./(max(sig_in_v)-min(sig_in_v)) + a;
    sig_out=reshape(sig_out,size(sig_in));
end
