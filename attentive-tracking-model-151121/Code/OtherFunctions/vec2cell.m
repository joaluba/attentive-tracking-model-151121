function outcell = vec2cell(invec);
outcell=cellfun(@num2str,num2cell(invec(:)),'uniformoutput',false);
end