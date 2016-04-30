% code to draw bar graphs
x=1:4;
% y contains the values of performance metrics of train 
% and test data on left and right respectively.
y = [0.907 0.9459;0.9412 0.9565;0.975 0.9722;0.8 0.9167];
bar(x,y);
title('KKN:Trail 9');
name = {'Sensitivity', 'Specificity', 'PPV', 'NPV'};
set(gca,'XTickLabel', name);