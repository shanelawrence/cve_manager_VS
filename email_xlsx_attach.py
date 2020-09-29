#!/usr/bin/env python3

import smtplib
import base64
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
import datetime
import os

now = datetime.date.today()
today=now.strftime("%Y-%m-%d")
msg = MIMEMultipart()
sender='cveproject@gmail.com'
recipients='cveproject@gmail.com'
server=smtplib.SMTP('yoursmtpserver')
reports="./reports/"+ today+"/"

files = []
for (path, dirnames, filenames) in os.walk(reports):
    files.extend(os.path.join(name) for name in filenames)

try:
    msg['Subject']='Daily CVE Summaries - '+today
    msg['From']=sender
    msg['To']=recipients
    msg.attach(MIMEText("Here are the xlsx files created from the NIST CVE database for today. Inspect these daily to check for CPEs that are on your critical product inventory, and notify accordingly."))
    for x in files:
        filename = x
        attachment = open(reports+x, 'rb')
        xlsx = MIMEBase('application','vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        xlsx.set_payload(attachment.read())
        encoders.encode_base64(xlsx)
        xlsx.add_header('Content-Disposition', 'attachment', filename=filename)
        msg.attach(xlsx)
        print ("Attached: ", filename)
    server.sendmail(sender, recipients, msg.as_string())
    server.quit()
    attachment.close()
    print ("Email sucessfully sent" )

except Exception:
   print ("Error: unable to send email")





