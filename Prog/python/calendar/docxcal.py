#-*- coding: utf-8 -*-

# https://python-docx.readthedocs.io/en/latest/

import calendar
from docx import Document
from docx.shared import Cm

from docx.oxml.ns import nsdecls
from docx.oxml import parse_xml

document = Document()

daystyle = "Normal"

border_elm_1_str = '''<w:tcBorders {}>
<w:top w:val="single" w:color="5C5C5C" w:space="0" w:sz="6"/>
<w:left w:val="single" w:color="5C5C5C" w:space="0" w:sz="6"/>
<w:bottom w:val="single" w:color="5C5C5C" w:space="0" w:sz="6"/>
<w:right w:val="single" w:color="5C5C5C" w:space="0" w:sz="6"/>
</w:tcBorders>'''.format(nsdecls('w'))

border_elm_2_str = '''<w:tcBorders {}>
<w:top w:val="single" w:color="BBBBBB" w:space="0" w:sz="6"/>
<w:left w:val="single" w:color="BBBBBB" w:space="0" w:sz="6"/>
<w:bottom w:val="single" w:color="BBBBBB" w:space="0" w:sz="6"/>
<w:right w:val="single" w:color="BBBBBB" w:space="0" w:sz="6"/>
</w:tcBorders>'''.format(nsdecls('w'))

cell_spacing_1_str = '''
<w:tblCellSpacing {} w:w="15" w:type="dxa"/>
'''.format(nsdecls('w'))

year = 2019
for month in range(1, 13):
    
    table = document.add_table(rows=12, cols=7)
    # print(table._tbl)
    cell_spacing_1 = parse_xml(cell_spacing_1_str)
    table._tbl.tblPr.append(cell_spacing_1)

    # header
    hdr_cells = table.rows[0].cells
    hdr_cells[0].merge(hdr_cells[6])
    hdr_cells[0].text = '%d-%d'%(year, month)

    # Monday to Sunday
    week_cells = table.rows[1].cells
    for i, m in enumerate(['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日']):
        week_cells[i].text = m.decode('utf-8')

    # Others
    for i in range(5):
        rowid_week = 2 + i*2
        rowid_todo = 2 + i*2+1
        week_row = table.rows[rowid_week]
        # week_row.height = Cm(1.)
        week_cells = week_row.cells
        for m, day in enumerate(week_cells):
            border_elm_1 = parse_xml(border_elm_1_str)
            week_cells[m]._tc.get_or_add_tcPr().append(border_elm_1)
 
        
        todo_row = table.rows[rowid_todo]
        todo_row.height = Cm(2.9)
        todo_cells = todo_row.cells
        for m, day in enumerate(todo_cells):
            border_elm_1 = parse_xml(border_elm_1_str)
            todo_cells[m]._tc.get_or_add_tcPr().append(border_elm_1)

    # Days
    cal_all = calendar.month(year, month).splitlines()
    # skip the first (Oct 2019)
    # skip the second (Mon ... Sun)
    cal_only = cal_all[2:]
    for (i, week_str) in enumerate(cal_only):
        week_only = week_str.split()
        # if the first week, it is padding to right

        rowid = 2+i%5*2
        week_cells = table.rows[rowid].cells
        
        if (i==0):
            for (m, day) in enumerate(reversed(week_only)):
                week_cells[6-m].text = day
                
                border_elm_2 = parse_xml(border_elm_2_str)
                shading_elm_1 = parse_xml(r'<w:shd {} w:fill="EFEFEF"/>'.format(nsdecls('w')))

                week_cells[6-m]._tc.get_or_add_tcPr().append(border_elm_2)
                week_cells[6-m]._tc.get_or_add_tcPr().append(shading_elm_1)
        else:
            for (m, day) in enumerate(week_only):
                week_cells[m].text = day

                border_elm_2 = parse_xml(border_elm_2_str)
                shading_elm_1 = parse_xml(r'<w:shd {} w:fill="EFEFEF"/>'.format(nsdecls('w')))
                
                week_cells[m]._tc.get_or_add_tcPr().append(border_elm_2)
                week_cells[m]._tc.get_or_add_tcPr().append(shading_elm_1)

    # Add a new page
    document.add_page_break()


document.save('demo.docx')
