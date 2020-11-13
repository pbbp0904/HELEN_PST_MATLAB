%%Reads in my hamming code data and spits out a csv
name='data.bin';
outfile='outfile.txt';
OUT=fopen(outfile,'w');
ID = fopen(name,'r');
idx = 1;
while 1
    [data,count]=fread(ID,8,'uint8');
    if count==0
        break
    end
    [data, errors]=decode57(data);
    fprintf(OUT,'%d,',data);
end
fclose(ID);
fclose(OUT);