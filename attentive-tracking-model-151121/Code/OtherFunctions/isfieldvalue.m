function b=isfieldvalue(struct,fieldname,value)

if isfield(struct,fieldname)
    if struct.(fieldname)==value
        b=1;
    else
        b=0;
    end
else
    b=0;
end