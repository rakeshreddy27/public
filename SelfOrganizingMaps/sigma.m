function s = sigma( t )
%Calculates sigma for each epoch
%T=2000/ln(0.5(max(height,width)))=1243 in this case
s=5*exp(-t/1243);
end

