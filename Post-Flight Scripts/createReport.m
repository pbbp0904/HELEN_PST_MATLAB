function createReport(Stats,imagePath,reportPath)
import mlreportgen.dom.*
import mlreportgen.report.*
ReportName = "HELEN_Data_Report.docx";
TemplateName = "HELEN_Data_Report_Template.dotx";
rpt = Document(ReportName,'docx',TemplateName);

graphImageNames = dir(imagePath);
graphImageNames = {graphImageNames(:).name};
graphImageNames = graphImageNames(3:end);


while ~strcmp(rpt.CurrentHoleId,'#end#')
    switch rpt.CurrentHoleId
        % Add table of stats
        case 'Stats'
            
            fn = fieldnames(Stats);
            for k=1:numel(fn)
                if( isnumeric(Stats.(fn{k})) )
                    s = Stats.(fn{k});
                    for i = 1:length(s)
                        sString(i) = sprintf("%0.4f",s(i));
                    end
                    StatsString.(fn{k}) = sString';
                end
            end

            t = rows2vars(struct2table(StatsString));
            t.Properties.VariableNames = {'Stat','Payload_1', 'Payload_2', 'Payload_3', 'Payload_4'};
            T = Table(t);
            T.Border = 'single';
            T.BorderColor = 'black';
            T.RowSep = 'single';
            T.RowSepColor = 'black';
            T.ColSep = 'single';
            T.ColSepColor = 'black';
            T.Style = [T.Style {Width('8in'), OuterMargin('-0.75in')}];
            append(rpt,T);
    end

    for i = 1:length(graphImageNames)
        if rpt.CurrentHoleId + ".png"  == graphImageNames(i)
            img = Image(imagePath + graphImageNames(i));
            img.Style = [img.Style {Height('4in'), Width('5.335in')}];
            append(rpt,img);
        end
    end

    moveToNextHole(rpt);
end

close(rpt);

copyfile(ReportName,reportPath);

end