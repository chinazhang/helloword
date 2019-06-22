#encoding:utf-8
import socket
import paramiko
import requests
import xlsxwriter
class restart(object):
    def __init__(self):
       pass
    def ssh_enable(self):
           with  open(u'./sitelist.txt','r') as f:
               lines=f.read().splitlines()
               abnormalsite=[]
               workbook = xlsxwriter.Workbook('swconfig06221732.xlsx')
               sheet = workbook.add_worksheet('swconfig_file')
               bold = workbook.add_format({'bold': True})
               sheet.write('A1', u'swinformation', bold)
               row = 2
               for hostip in lines:
                   try:
                       sshconn = paramiko.SSHClient()
                       sshconn.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                       sshconn.connect(hostip, port=22, username='toor4nsn', password='oZPS0POrRieRtu', timeout=10)
                       stdin, stdout, stderr = sshconn.exec_command('ls -l /ffs/run/ | grep \'swconfig\'')
#                       print stdout.read()
                       sheet.write('A%d' % row, stdout.read() + "_" + hostip)
                       print hostip + "  write success"
                       row += 1
                   except:
                       print hostip + "  restart fail"
                       abnormalsite.append(hostip)
                       continue
               with open(u'./AbnormalSiteList.txt', 'w') as fd1:
                    for abnormal in abnormalsite:
                        fd1.write(abnormal+"\n")
               workbook.close()
if __name__=="__main__":
    try:
        print "=============================================================="
        print "Your operation will restart site in sitelist.txt              "
        print "Before you start,please double confirm your operation,thanks!!"
        print "=============================================================="
        usr=raw_input("Please input your username: \n")
        pwd=raw_input("please input your password: \n")
        if usr=="nokia" and pwd=="nokia":
            requests.packages.urllib3.disable_warnings()
            p=restart()
            p.ssh_enable()
        else:
            raise KeyError
    except:
            print "====================================================="
            print "===You have no permission to operate this script!!==="
            print "====================================================="
