function createReport(Stats, Graphs, PayloadPrefixes, PayloadColors)
import mlreportgen.report.* 
import mlreportgen.dom.* 

rpt = Report('magic','html');
tp = TitlePage; 
tp.Title = 'HELEN Flight Report'; 
tp.Subtitle = sprintf('Generated: %s', datestr(now, 'mmmm dd, yyyy  HH:MM:SS.FFF')); 
tp.Author = 'HELEN Team'; 
add(rpt,tp);

s1 = Section; 
s1.Title = 'Data Table'; 
tbl = Table(struct2table(structfun(@transpose,Stats,'UniformOutput', 0))); 
tbl.Style = {... 
    RowSep('solid','black','1px'),... 
    ColSep('solid','black','1px'),}; 
tbl.Border = 'double'; 
tbl.TableEntriesStyle = {HAlign('center')}; 
add(s1,tbl)
add(rpt,s1)

s2 = Section; 
s2.Title = 'Figures'; 
add(rpt,s2)

close(rpt)
rptview(rpt)

end

