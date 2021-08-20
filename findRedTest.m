clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
fontSize = 14;


%%%%%%%%%
folder = 'C:\Users\chris\Downloads';
filename = '2021_07_28_18_40_58.mp4';
movieFullFileName = fullfile(folder, filename);
doVisual = 0;
threshold = 80;
startFrame = 1;
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
numberOfFrames = videoObject.NumberOfFrames;

% Prepare a figure to show the images and enlarge figure to full screen.
if(doVisual)
    figure(1);
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    figure(2);
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
end

% Make lightning frame array
redFrames = [];
lFrame = 1;


% Loop through the movie.
for frame = startFrame : numberOfFrames
% Extract the frame from the movie structure.
thisFrame = read(videoObject, frame);

% Display it
if (doVisual==1)
    figure(1);
    cla;
    image(thisFrame);
    caption = sprintf('Frame %4d of %d.', frame, numberOfFrames);
    title(caption, 'FontSize', fontSize);
    drawnow; % Force it to refresh the window.m
end

% Calculate the red level in comparison to blue and green.
redImage = max(2*thisFrame(:,:,1)-thisFrame(:,:,2)-thisFrame(:,:,3),0)/2;
maxRedLevels(frame) = max(redImage(:));

% Check if the mean gray level has increased above threshold
if(frame>1 && maxRedLevels(frame)>threshold)
    redPrint = sprintf('Red on frame %4d!', frame);
    disp(redPrint);
    redFrames(lFrame) = frame;
    lFrame = lFrame + 1;

end

    figure(2);
    cla;
    imshow(redImage)
    drawnow

% Update user with the progress.  Display in the command window.
if(mod(frame,1000)==0)
    progressIndication = sprintf('Processed frame %4d of %d.', frame, numberOfFrames);
    disp(progressIndication);
end
end