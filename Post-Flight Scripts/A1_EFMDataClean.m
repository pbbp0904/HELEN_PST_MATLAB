FilePath = 'D:\Flight Data\Flight 2\2-Data to Process\2GREEN_EFM Raw Data\';
FileName = '2GREEN_EFM';
FileExt  = '.TXT';

A = importdata(strcat(FilePath,FileName,FileExt),'');
B = A;

for i = 1:length(A)
    for j = 1:length(A{i})
        Ad = double(A{i}(j));
        if Ad > 128
            B{i}(j) = char(Ad-128);
        end
        if Ad == 352
            B{i}(j) = newline;
        end
        if Ad == 8090+128
            B{i}(j) = newline;
        end
        if Ad == 141
            B{i}(j) = '-';
        end
        
        
        if Ad == 210+128
            B{i}(j) = ',';
        end
        if Ad == 211+128
            B{i}(j) = ',';
        end
        if Ad == 29+128
            B{i}(j) = ',';
        end
        if Ad == 253+128
            B{i}(j) = '.';
        end
        if Ad == 254+128
            B{i}(j) = '.';
        end
        if Ad == 16+128
            B{i}(j) = '0';
        end
        if Ad == 8088+128
            B{i}(j) = '1';
        end
        if Ad == 8089+128
            B{i}(j) = '2';
        end
        if Ad == 8092+128
            B{i}(j) = '3';
        end
        if Ad == 8093+128
            B{i}(j) = '4';
        end
        if Ad == 8098+128
            B{i}(j) = '5';
        end
        if Ad == 8083+128
            B{i}(j) = '6';
        end
        if Ad == 8084+128
            B{i}(j) = '7';
        end
        if Ad == 604+128
            B{i}(j) = '8';
        end
        if Ad == 8354+128
            B{i}(j) = '9';
        end
        
        
        if length(Ad) > 1
            if Ad(1) == 211 && Ad(2) == 8236
                B{i}(j) = ', ';
            end
        end
    end
end

writecell(B,strcat(FilePath,FileName,'_CLEANED',FileExt),'QuoteStrings',false);