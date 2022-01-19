function createReport(Stats)
import mlreportgen.dom.*
import mlreportgen.report.*
ReportName = "HELEN_Data_Report.docx";
TemplateName = "HELEN_Data_Report_Template.dotx";
rpt = Document(ReportName,'docx',TemplateName);

while ~strcmp(rpt.CurrentHoleId,'#end#')
    switch rpt.CurrentHoleId
        case 'Date'
            append(rpt,Date);
        case 'BSNumber'
            append(rpt,BSNumber);
        case 'RandomDots'
            append(rpt,Image(imagePathName));
        case 'Stats'

            t = rows2vars(struct2table(Stats));
            t.Properties.VariableNames = {'Stat','Payload_1', 'Payload_2', 'Payload_3', 'Payload_4'};
            T = Table(t);
            T.Border = 'single';
            T.BorderColor = 'black';
            T.RowSep = 'single';
            T.RowSepColor = 'black';
            T.ColSep = 'single';
            T.ColSepColor = 'black';
            append(rpt,T);
            format long
    end
    moveToNextHole(rpt);
end

close(rpt);