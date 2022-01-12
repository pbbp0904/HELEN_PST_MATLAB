function createReport(Date, BSNumber, imagePathName)
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
   end
   moveToNextHole(rpt);
end

close(rpt);