clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
%clear;  % Erase all existing variables.
fontSize = 14;


%%%%%%%%%
folder = 'D:\Flight Data\Flight 5\2-Data to Process';
filename = '4BLUE_CAM.mp4';
movieFullFileName = fullfile(folder, filename);
doVisual = 0;
threshold = 10;
startFrame = 72000;
endFrame = 90000;
%%%%%%%%%


% Check to see that it exists.
if ~exist(movieFullFileName, 'file')
  strErrorMessage = sprintf('File not found:\n%s\nYou can choose a new one, or cancel', movieFullFileName);
  response = questdlg(strErrorMessage, 'File not found', 'OK - choose a new movie.', 'Cancel', 'OK - choose a new movie.');
  if strcmpi(response, 'OK - choose a new movie.')
    [baseFileName, folderName, FilterIndex] = uigetfile('*');
    if ~isequal(baseFileName, 0)
      movieFullFileName = fullfile(folderName, baseFileName);
    else
      return;
    end
  else
    return;
  end
end

videoObject = VideoReader(movieFullFileName);
% Determine how many frames there are.
numberOfFrames = videoObject.NumFrames;

% Prepare a figure to show the images and enlarge figure to full screen.
if(doVisual)
    figure();
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
end

% Make lightning frame array
lightningFrames = [];
lFrame = 1;
meanGrayLevels = zeros(1,numberOfFrames);
maxRowDiff = zeros(1,numberOfFrames);

% Loop through the movie.
for frame = startFrame : endFrame%numberOfFrames
    % Extract the frame from the movie structure.
    thisFrame = read(videoObject, frame);
    
    % Display it
    if (doVisual==1)
        cla;
        image(thisFrame);
        caption = sprintf('Frame %4d of %d.', frame, numberOfFrames);
        title(caption, 'FontSize', fontSize);
        drawnow; % Force it to refresh the window.m
        
    end
    
    % Calculate the mean gray level.
    grayImage = rgb2gray(thisFrame);
    meanGrayLevels(frame) = mean(grayImage(:));
    
    meanRowLevels = mean(grayImage,2);
    maxRowDiff(frame) = max(meanRowLevels-meanGrayLevels(frame));
    
    % Check if the mean gray level has increased above threshold
    if(frame>1 && meanGrayLevels(frame)>meanGrayLevels(frame-1)+threshold)
        lightningPrint = sprintf('Lightning on frame %4d!', frame);
        disp(lightningPrint);
        lightningFrames(lFrame) = frame;
        lFrame = lFrame + 1;
    end
    
    % Update user with the progress.  Display in the command window.
    if(mod(frame,1000)==0)
        progressIndication = sprintf('Processed frame %4d of %d.', frame, numberOfFrames);
        disp(progressIndication);
    end
end

%save(strcat(folder(1:end-17),'\3-Processed Data\',filename(1:length(filename)-8),'_LightningFrames_',num2str(threshold),'.mat'),'lightningFrames','meanGrayLevels','videoObject','threshold')
finishedMessage = sprintf('Done!  Processed %d frames of "%s"\n', numberOfFrames, movieFullFileName);
disp(finishedMessage); % Write to command window.
uiwait(helpdlg(finishedMessage)); % Also pop up a message box.
