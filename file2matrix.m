function [matrix] = file2matrix(payloadn,filen)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    path=getfpath(payloadn,filen);
    fid=fopen(path);
    if(fid==-1)
        matrix=[];
        return;
    end
    
    matrix=zeros(6944,35);
    row=1;
    while(~feof(fid))
        A = fread(fid,1,'int32');
        if(A~=-1)
            fprintf("First value of file %d from payload %d on row %d is not all ones\n",filen,payloadn,row);
        end
        data = fread(fid,[1 35],'int32');
        if(isempty(data))
            return;
        end
        if(length(data)<35)
            fprintf("File %d on payload %d is not a valid length",filen,payloadn);
            return;
        end
        matrix(row,:) = data;
        row=row+1;
    end
end

function [fname] = getfpath(payloadn,filen)
    if(filen<10)
        fname="flightdata"+int2str(payloadn)+"/"+"data00"+int2str(filen)+".bin";
        return;
    end
    if(filen<100)
        fname="flightdata"+int2str(payloadn)+"/"+"data0"+int2str(filen)+".bin";
        return
    end
    fname="flightdata"+int2str(payloadn)+"/"+"data"+int2str(filen)+".bin";
end