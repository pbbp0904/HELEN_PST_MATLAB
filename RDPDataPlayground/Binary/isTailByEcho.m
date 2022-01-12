function [isPulseTail] = isTailByEcho(pulsedata_b)

isPulseTail=[];
isPulseTail(1)=0;
isPulseTail(2:length(pulsedata_b))= sum(pulsedata_b(1:end-1, 2:4)' == pulsedata_b(2:end, 1:3)') == 3;
% for i = 2:length(pulsedata_b)
%     prevcolumn = pulsedata_b(i-1, 2:4);
%     column = pulsedata_b(i, 1:3);
%     if prevcolumn == column
%         isPulseTail(i)=1;
%     end
% end
isPulseTail = isPulseTail';
end

