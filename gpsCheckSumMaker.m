inputString='0x06, 0x01, 0x08, 0x00, 0x0D, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01';

inputString = replace(inputString,'0x','');
inputString = replace(inputString,', ','');

CK_A = 0; CK_B = 0;
for i = 1:2:length(inputString)
    numVal = hex2dec(inputString(i:i+1));
    CK_A = mod(CK_A + numVal,256);
    CK_B = mod(CK_B + CK_A,256);
end

CK_A = dec2hex(CK_A)
CK_B = dec2hex(CK_B)