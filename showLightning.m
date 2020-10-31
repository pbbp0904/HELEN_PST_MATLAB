function showLightning(videoObject, lightningFrames)

numberOfFrames = videoObject.NumberOfFrames;

% Prepare a figure to show the images and enlarge figure to full screen.
h_fig = figure;
set(h_fig,'KeyPressFcn',@myfun);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
global i;
global skip;

% Start at
i = 1;
skip = 0;
while(i<=length(lightningFrames))
    frame = round(lightningFrames(i));
    frame
    restartScore = 0;
    for j = 1:i-1
        for k = 1:10
           if(abs(round(lightningFrames(i))-round(lightningFrames(i-j))-k*9020) < 5*k)
               restartScore = restartScore + 1;
           end  
        end
    end
    pause(0.1)
    if(restartScore < 30)
    for subFrame = -100:100
        thisFrame = read(videoObject, max(min(frame+subFrame,numberOfFrames),1));
        cla;
        image(thisFrame);
        

        caption = sprintf('Event #: %5d     Lightning Frame: %5d     Frame %5d of %d     Last event delta: %5d     Restart Score: %4d', i, frame, frame+subFrame, numberOfFrames,round(lightningFrames(i))-round(lightningFrames(max(i-1,1))), restartScore );
        title(caption, 'FontSize', 14);
        drawnow; % Force it to refresh the window.m
        if(skip~=0)
            break;
        end
    end
    end
    if(skip==-1)
        i = i - 1;
        skip = 0;
        continue;
    elseif(skip==1)
        i = i + 1;
        skip = 0;
        continue;
    elseif(skip==2)
        skip = 0;
        continue;
    end
    n = 1;
    while(round(lightningFrames(i+n))<frame+30)
        n = n + 1;
    end
    i = i + n;
end
end

function myfun(src,event)
global skip
if(strcmp(event.Key, 'leftarrow'))
   skip = -1;
elseif(strcmp(event.Key, 'rightarrow'))
   skip = 1;
elseif(strcmp(event.Key, 'downarrow'))
   skip = 2;
end
end

