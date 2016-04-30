function quality = quality( w1,w2,w0,array)

% function to calculate the performance metrics

q00=0;  %true negatives
q11=0;  %true positives
q01=0;  %false positives
q10=0;  %false negatives

for i=1:max(size(array))
ws=w1*array(i,1)+w2*array(i,2)+w0*1;
if ws>=0
    if array(i,3)==1
        q11=q11+1;
    else
        q01=q01+1;
    end
else
    if array(i,3)==0
        q00=q00+1;
    else
        q10=q10+1;
    end     
end
end
sensitivity=q11/(q11+q10);
specificity=q00/(q00+q01);
ppv=q11/(q11+q01);
npv=q00/(q00+q10);

quality=[sensitivity,specificity,ppv,npv];


end

