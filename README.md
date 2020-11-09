**Project Description**

A collection of python apps and shell scripts to email an xlsx spreadsheet of new vulnerabilities in the NIST CVE database and their associated products on a daily schedule. The spreadsheet can then be manually interpreted for risk to your specific organization.
* Based off of an opensource product on github originally by Antonios Atlasis
* Syncs the NIST database for CVEs and CPEs locally and  provides basic query capabilities
* Creates xlsx reports from the data and Emails those reports

**File: cve_manager.py**  
A python script originally authored by Antonios Atlasis - aatlasis@secfu.net  
https://github.com/aatlasis/cve_manager  
* create postgresql databases and views  
* downloads the latest NIST CVE, CPE, and CWE raw data files  
* unzips and loads the NIST raw data files into the database  
* automates custom queries, searches and reports of the NIST data  
* creates csv export reports of the data  
  
*Changes from original:*   
Added import of data manipulation library pandas  
	*sudo pip3 install pandas openpyxl*  
Added database view that joins cve and cpe data  
Modified default cpe queries and reports to include cvssv3 vector string instead of cvssv2 score  
Modified default cpe queries and reports to sort by published date ASC, CVSS DESC, and CPE ASC  
Modified cpe output to csv function to automatically save a copy in xlsx format for every csv saved  
  
**File: email_xlsx_attach.py**    
New python script, authored by Shane Lawrence  
sends the xlsx reports as email attachments through a local smtp relay  
  
**File: daily.sh**  
a bash shell script, authored by Shane Lawrence  
Puts it all together in something that cron can run daily  
Automates the following uses of cve_manager.py:  
* truncates the old database, deletes old datafiles  
* downloads new raw datafiles for CVE data - the vulnerabilities 
* downloads new raw data file for CPE - the vulnerable products 
* downloads new top 1000 CWE - the code problems that cause vulnerabilities 
* jams all of the above into a postgres database  
* runs the searches relevant to you  
* creates csv reports of the relevant searches, formatted and sorted for your preferences  
* reads in the csv reports and outputs to xlsx  
* deletes the csvs  
Automates the usage of email_xlsx_attach.py  
  
--------------------------------------------------  
  
New server setup:  
Read the original pdf at:  
https://github.com/aatlasis/cve_manager/blob/master/CVE%20Manager.pdf  
  
1. Setup python:  
Requires python 3  
Do yourself a favor and install pip3 also  
    *pip3 install psycopg2, openpyxl, pandas*  
Required includes:  
psycopg2 - data science libs  
pandas - data manipulation libs (dependency on openpyxl)  
sys, argparse, os, zipfile, json, requests, re, io, csv, smtplib, base64, email, datetime  
  
1. Setup postgres:  
Install the latest postgreql database for your distribution.  
as root, systemctl enable postgresql  
systemctl start postgresql  
then set a password for postgresql user by:  
    *sudo -u postgres psql*  
    *\l lists databases*  
    *\du lists users*  
    *CREATE USER username WITH PASSWORD 'password';*  
  
1. Use cve_manager to create the database:  
The user must have create privlileges   
*./cve_manager.py -u postgres -ps $PASSWORD -server localhost -db $DB -ow $USER -cd*  
  
1. Use cve_manager.py to create the schema  
The user must have create privileges  
*./cve_manager.py -u postgres -ps $PASSWORD -server localhost -db $DB -ct*  
  
1. Use cve_manager to download the CVE and CPE data  
*./cve_manager.py -u $user -ps $pass -host $host -db $db -d -p -csv*  
  
1. Manually download and unzip the CWE data  
*wget https://cwe.mitre.org/data/csv/1000.csv.zip*  
*unzip 1000.csv.zip*  
  
1. Use cve_manager to import the NIST CVE and CPE data into the database  
*./cve_manager.py -u $user -ps $pass -host $host -db $db -idb -p*  
  
1. Use cve_manager to import the CWE data into the database  
*./cve_manager.py -u $user -ps $pass -host $host -db $db -icwe 1000.csv*  
  
1. Run an example report.  
This example creates a csv and xlsx of the vulnerabilities and products they affect,   
only rated severity 7.0 or greater, created or updated since 01 July 2020  
*./cve_manager.py -u $user -ps $password -host $host -db $db -sc 7.0 -dt 2020-07-01 -cpe cpe -csv -o $reports*  
  
1. Email the xlsx reports  
Modify email_xlsx_attach.py for your smtp relay, sender, recipients, and reports directory.  
  
-------------  
  
**TODO:**  
Next iteration is to figure out how to incorperate a list of a critical product inventory,  
and only create reports that apply to the CPEs on product inventory.  
  
-------------  

*Shane Lawrence*  
*Sr Advisor, Cloud Platform Security*  

