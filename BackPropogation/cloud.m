data = load('b.txt');
%data(:,2)=data(:,2)/1000000;
bar(data(:,1),data(:,2),'LineWidth',1);
title('Year vs Words ');
xlabel('Year');
ylabel('Set of Words')