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

root = Tk()
root.geometry('600x350')

content=''

# This function will be used to open file
def open_file():
    global content
    global entry
    file = askopenfile(mode ='r', filetypes =[('Python Files', '*.py'),('XML Files','*.xml'),('TXT Files','*.txt *.log')])
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
    txt = open(file_txt, 'r')
    data = txt.readlines()

	# 定义关键字
    BCFwords='BCF'
    BTSwords='BTS'
    SBTSwords='SBTS'


    # 创建一个excel文件，并添加一个sheet，命名为BSCdata
    workbook = xlsxwriter.Workbook(file_excel)
    sheet = workbook.add_worksheet('BSCdata')

    # 设置粗体
    bold = workbook.add_format({'bold': True})

    # 先在第一行写标题，用粗体
    sheet.write('C1', u'BCFnum', bold)
    sheet.write('D1', u'BCFID', bold)
    sheet.write('E1', u'SBTS', bold)
    sheet.write('F1', u'BTSnum', bold)
    sheet.write('G1', u'LAC', bold)
    sheet.write('H1', u'CI', bold)
    sheet.write('I1', u'BTS', bold)
    sheet.write('J1', u'BTSNAME', bold)
    sheet.write('A1', u'BSCTYPE', bold)
    sheet.write('B1', u'BSCNUM', bold)
    sheet.write('K1', u'TRX', bold)
    sheet.write('L1', u'TRX_STATE', bold)
    sheet.write('M1', u'TRX_STATE', bold)
    sheet.write('N1', u'FREQ', bold)
    sheet.write('O1', u'ET-PCM', bold)
    sheet.write('P1', u'OMUSTATE', bold)
    sheet.write('Q1', u'BCFSTATE', bold)




    # 行号，具体信息从第二行开始
    row = 2
    # 将data中的数据按txt的每行的顺序依次赋值给x
    for x in data:
        # 根据条件筛选出需要的信息，获取BSC型号及BSC号，并赋值给word_BSC
        if 'BSC' in x and 'NETWORK' not in x and 'XHJDBSC' not in x:
            word_BSC = x.split()
        # 将x根据空格分裂成list并赋值给words
        words = x.split()
        # 将words中的数据按顺序赋值给text
        for text in words:
            # 根据筛选条件，以站（BCF）为单位获取信息
            isSBTS=SBTSwords not in text
            if BCFwords in text and 'FLEXI' in x:
                word_BCF=words[0]
                word_SBTS=words[5]
                BCF_STATES=words[4]
                sheet.write('C%d' % row, '1')
                if SBTSwords not in x:
                    sheet.write('P%d' % row, words[7])   #  如果BCF行没有SBTS号，则第8位信息为OMU信令的信息
            elif SBTSwords in text:
                sheet.write('P%d' % row, words[8])   #  如果BCF行有SBTS号，则第9位信息为OMU信令的信息
            # 根据筛选条件，以小区（BTS）为单位获取信息
            elif BTSwords in text and isSBTS and 'NOKBTS' not in text and 'BTSPLUS' not in text and 'BTSNAME' not in text and 'BL-BTS' not in text:
                word_BTSNAME = data[data.index(x)+1].split()    # 获取下一行数据
                word_BTS1=words[0]
                word_BTS2=words[1]
                word_BTS3=words[2]
                word_BTS4=word_BTSNAME[0]
                sheet.write('F%d' % row, '1')
            #根据筛选调，以载频（TRX）为单位获取信息
            elif 'TRX' in text and 'BL-TRX' not in text:
                sheet.write('K%d' % row, words[0])
                sheet.write('L%d' % row, words[1])
                sheet.write('M%d' % row, words[2])
                sheet.write('N%d' % row, words[3])
                sheet.write('O%d' % row, words[5])
                sheet.write('A%d' % row, word_BSC[0])
                sheet.write('B%d' % row, word_BSC[1])
                sheet.write('D%d' % row, word_BCF)
                sheet.write('E%d' % row, word_SBTS)
                sheet.write('G%d' % row, word_BTS1)
                sheet.write('H%d' % row, word_BTS2)
                sheet.write('I%d' % row, word_BTS3)
                sheet.write('J%d' % row, word_BTS4)
                sheet.write('Q%d' % row, BCF_STATES)
                row += 1


    # 关闭文件
    txt.close()
    workbook.close()
    msg = Label(root, text='Done!')
    msg.grid(row=1,column=0)

btn = Button(root, text ='txt_to_excel', command = lambda:txtToExcel(content,str(entry.get())+'.xlsx'))
btn.grid(row=1,column=1)


mainloop()
