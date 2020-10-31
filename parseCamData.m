function [PayloadCamData] = parseCamData(DirectoryLocation, PayloadPrefixes, CamPrefix, threshold)

PayloadCamData = {};

disp('Parsing Camera Data...')
for payload = 1:length(PayloadPrefixes)

    movieFullFileName = strcat(DirectoryLocation, "/", PayloadPrefixes{payload}, "_", CamPrefix, ".mp4");

    startFrame = 1000;

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

    % Make lightning frame array
    lightningFrames = [];
    lFrame = 1;


    % Loop through the movie.
    for frame = startFrame : numberOfFrames
        % Extract the frame from the movie structure.
        thisFrame = read(videoObject, frame);

        % Calculate the mean gray level.
        grayImage = rgb2gray(thisFrame);
        meanGrayLevels(frame) = mean(grayImage(:));

        % Check if the mean gray level has increased above threshold
        if(frame>1 && meanGrayLevels(frame)>meanGrayLevels(frame-1)+threshold)
            lightningFrames(lFrame) = frame;
            lFrame = lFrame + 1;
        end

        % Update user with the progress.  Display in the command window.
        if(mod(frame,100000)==0)
            progressIndication = sprintf('Processed frame %4d of %d.', frame, numberOfFrames);
            disp(progressIndication);
        end
    end

    save(strcat(DirectoryLocation,'\Proccessed Data\',filename(1:length(filename)-8),'_LightningFrames_',num2str(threshold),'.mat'),'lightningFrames','meanGrayLevels','videoObject','threshold')
    
    PayloadCamData{payload}.lightningFrames = lightningFrames;
    PayloadCamData{payload}.meanGrayLevels = meanGrayLevels;
    PayloadCamData{payload}.videoObject = videoObject;
    PayloadCamData{payload}.threshold = threshold;

    fprintf('Done with %s\n', PayloadPrefixes{payload});
end

end


