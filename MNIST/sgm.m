function out = sgm( in,der )
[iin,jin]=size(in);

for i=1:iin
    for j=1:jin
        temp=1/(1+exp(-in(i,j)));
        if der==0
            out(i,j)=temp;
        else
            out(i,j)=temp*(1-temp);
        end
    end
end

end

