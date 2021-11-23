function B = runFile()
%RUNFILE- Created by Sean Hassler - Pulls the path to the datastore.
%   This is to make things more general since everyone will have their
%own text files.
%   Possible Upgrade - Find the files anywhere on the computer?

%open the file.
fileID = fopen('PathtoData.txt','r');
%read the file.
A = textscan(fileID,'%s','Delimiter','\n');
%convert to a string.
B = string(A);
%print to check. This is not needed.
disp(B);
%Close the file.
fclose(fileID);

end

