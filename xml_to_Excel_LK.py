#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# importing tkinter and tkinter.ttk
# and all their functions and classes
from tkinter import *
from tkinter.ttk import *

# importing askopenfile function
# from class filedialog
from tkinter.filedialog import askopenfile

import xlsxwriter
import os
import bs4
import xml.dom.minidom

root = Tk()
root.geometry('600x350')

content=''

# This function will be used to open file
def open_file():
    global content
    global entry
    file = askopenfile(mode ='r', filetypes =[('TXT Files','*.txt *.log'),('Python Files', '*.py'),('XML Files','*.xml')])
    if file is not None:
        content = file.name
    entry.delete(0,END)
    entry.insert(INSERT,content)

btn = Button(root, text ='Open', command = lambda:open_file())
btn.grid(row=0,column=0)

entry =Entry(root,width=50)
entry.grid(row=0,column=1)
entry.insert(INSERT,'')


def txtToExcel(file_txt, file_excel):
    # 打开txt文件，并以行为单位读取数据

	# 定义关键字
    BCFwords='Parameter'
    BTSwords='Measurement'
    SBTSwords='Measurements'


    # 创建一个excel文件，并添加一个sheet，命名为BSCdata
    workbook = xlsxwriter.Workbook(file_excel)
    sheet = workbook.add_worksheet('BSCdata')

    # 设置粗体
    bold = workbook.add_format({'bold': True})

    # 先在第一行写标题，用粗体
    sheet.write('A1', u'filename', bold)
    sheet.write('B1', u'licenceCode', bold)
    sheet.write('C1', u'licenceName', bold)
    sheet.write('D1', u'maxValue', bold)
    sheet.write('E1', u'featureName', bold)
    sheet.write('F1', u'targetId', bold)
    sheet.write('G1', u'SO', bold)


    # 行号，具体信息从第二行开始
    row = 2
    current_dir = os.path.abspath(os.path.dirname(file_txt))
    file_name = open(file_txt, 'r')
    file_list = file_name.readlines()
    for filename in file_list:
        filename = filename.rstrip("\n")
        txt = open(current_dir+"\\"+filename, 'r', encoding='UTF-8')
        doc = bs4.BeautifulSoup(txt, 'xml')

        licencename = doc.find('licenceInfo')
        Capacity = doc.find('objectLimit')
        featureInfo = doc.find('featureInfo')
        targetNe = doc.find('targetNe')
        order = doc.find('order')
    # 将data中的数据按txt的每行的顺序依次赋值给x
        sheet.write('A%d' % row, filename)
        sheet.write('B%d' % row, licencename.get('licenceCode'))
        sheet.write('C%d' % row, licencename.get('licenceName'))
        sheet.write('D%d' % row, Capacity.get('maxValue'))
        sheet.write('E%d' % row, featureInfo.get('featureName'))
        sheet.write('F%d' % row, targetNe.get('targetId'))
        sheet.write('G%d' % row, order.get('orderId'))
        row += 1


        # 关闭文件
        txt.close()
    workbook.close()
    msg = Label(root, text='Done!')
    msg.grid(row=1,column=0)

btn = Button(root, text ='txt_to_excel', command = lambda:txtToExcel(content,str(entry.get())+'.xlsx'))
btn.grid(row=1,column=1)


mainloop()
