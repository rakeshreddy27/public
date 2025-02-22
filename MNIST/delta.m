function delta = delta( input,weightcell,outputcell,expected,learningrate)
input(1,end+1)=0.9;
[~,jwc]=size(weightcell);
for i=jwc:-1:1
    if i==jwc
        smalldelta{i}=outputcell{i}.*(1-outputcell{i}).*(outputcell{i}-expected);
    else
        if i==jwc-1
        smalldelta{i}=outputcell{i}.*(1-outputcell{i}).*...
        (smalldelta{i+1}*transpose(weightcell{i+1}));
        else
       smalldelta{i}=outputcell{i}.*(1-outputcell{i}).*...
           (smalldelta{i+1}(1:end-1)*transpose(weightcell{i+1}));
        end
        
    end
end

for i=jwc:-1:1
    if i~=1
        if i==jwc
    delta{i}=learningrate(i).*(transpose(outputcell{i-1})*smalldelta{i});
        else
    delta{i}=learningrate(i).*(transpose(outputcell{i-1})*smalldelta{i}(1:end-1));
        end
    else
    delta{i}=learningrate(i).*(transpose(input)*smalldelta{i}(1:end-1));
    end
end

end

