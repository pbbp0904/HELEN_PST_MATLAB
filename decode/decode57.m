function [data,errors] = decode57(bytearray,littleEndian)
%decode57 This function decodes 57 bit SECDED code
%   bytearray is an array of 8 bytes encoded with hamming(57,63) with one
%   aditional parity bit to detect a double error. May optionally specify endianess of
%   the byte array. Uses even parity. The decoded value is put in data and
%   the number of errors detected in errors.
    errors=0;

    if ~exist('littleEndian','var')%check if user specified endianess
        littleEndian=1;
    end
    %parse bytes into a single value
    if littleEndian
        code = bytearray(1) + bytearray(2)*2^8 + bytearray(3)*2^16 + bytearray(4)*2^24 + bytearray(5)*2^32 + bytearray(6)*2^40 + bytearray(7)*2^48 + bytearray(8)*2^56;
    else
        code = bytearray(8) + bytearray(7)*2^8 + bytearray(6)*2^16 + bytearray(5)*2^24 + bytearray(4)*2^32 + bytearray(3)*2^40 + bytearray(2)*2^48 + bytearray(1)*2^56;
    end
    
    bcode=bitget(code,1:64);%convert to an array of bytes
    p=zeros(7,1);%array to hold pariity bits
    for idx=bcode
        p(1)=xor(p(1),idx);%check parity bit zero
    end
    
    
    correctbit=0;%value to hold the bit that has an error
    
    %check parity bits 1 through 6
    for idx = 2:7
        p(idx)=checkerror(bcode,idx-1);
        
        correctbit=correctbit+p(idx)*2^(idx-2);%error bit is the binary number represintation of parity bits
        
        if (~p(1)) && p(idx)%if p0 says error and another does not then we have two errors and cannot recover data
            errors=2;
            data=[];
            return
        end
    end
    if(correctbit~=0)
        errors=1;
        bcode(correctbit+1)=xor(bcode(correctbit+1),1);
    end
    data=getnumber(bcode);
end

function [num] = getnumber(bits)%function extracts origonal number out of bit array of coded data without checking parity bits
    pow=1;
    count=0;
    pnum=0;
    num=0;
    for idx = bits
        if(count==0)
            count=count+1;
            continue;
        end
        
        if count==pow
            pnum=pnum+1;
            pow=2^pnum;
        else
            num=num+idx*2^(count-pnum-1);
        end
        count=count+1;
    end
end


function [parity] = checkerror(bitarray,pbit)%given parity bit number this funciton checks the parity
    pow=2^(pbit-1);
    p=0;
    len=length(bitarray);
    
    for idx=1:(len-1)
        if(bitand(pow,idx)~=0)
            p = xor(bitarray(idx+1),p);
        end
    end
    parity=p;
    
end
