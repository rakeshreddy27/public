function metrics = permetrics(obtained,original)
q00=0;  %true negatives
q11=0;  %true positives
q01=0;  %false positives
q10=0;  %false negatives
for i=1:max(size(original))
if obtained(i)==1
    if original(i)==1
        q11=q11+1;
    else
        q01=q01+1;
    end
else
    if original(i)==0
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

metrics=[sensitivity,specificity,ppv,npv];

end

