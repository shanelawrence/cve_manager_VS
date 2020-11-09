#  A version of daily.sh that syncs the database, and creates the reports but does not mail them.

## vars
user=<user>		#-- Postgres database user
pass=<pass>		#-- Postgres database pass
host=<host>		#-- Postgres database host
db=<db>		#-- Postgres database name
csv=./nvd		#-- where to download the scap data to
today=$(date +%F)				#-- Todays date formattted
yesterday=$(date -d "$today -1 days" +%F)	#-- Yesterdays date formatted
weekend=$(date -d "$today -3 days" +%F)		#-- 3 days ago formatted
lastweek=$(date -d "$today -7 days" +%F)	#-- 7 days ago formatted
reports="</home/reports/dir/>"$today"/"
home="</home/dir/>"
#--

#-- Drop the old database
cd $home
echo "Dropping yesterdays old data"
./cve_manager.py -u $user -ps $pass -host $host -db $db -tr

#-- Delete the old files
echo "Removing the old scap data"
rm -rf $csv

#-- Retrieve new NVD files
echo "Get new data files from NIST"
./cve_manager.py -u $user -ps $pass -host $host -db $db -d -p -csv

#-- Retieve new CWE file
cd $csv
wget https://cwe.mitre.org/data/csv/1000.csv.zip
unzip 1000.csv.zip
cd $home

#-- Import new NVD to database
echo "Importing new data into the local database"
./cve_manager.py -u $user -ps $pass -host $host -db $db -idb -p

#-- Import new CWE to database
./cve_manager.py -u $user -ps $pass -host $host -db $db -icwe $csv/1000.csv

#--create daily csv and xlsx

#echo "List of new all CVEs created or updated since Yesterday, $yesterday :"
#./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 0.1 -dt $yesterday -csv -o $reports
#echo "-------------------------------------------------"

#echo "List of new all CVEs created or updated since Yesterday, $yesterday with CPE:"
#./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 0.1 -dt $yesterday -cpe cpe -csv -o $reports
#echo "-------------------------------------------------"

#echo "List of sev 10 CVEs created or updated since Yesterday, $yesterday with CPE "
#./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 10.0 -dt $yesterday -cpe cpe -csv -o $reports
#echo "-------------------------------------------------"

echo "List of sev 9.8 CVEs created or updated since last week, $lastweek with CPE "
./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 9.8 -dt $lastweek -cpe cpe -csv -o $reports
echo "-------------------------------------------------"

echo "List of sev 7 or greater CVEs created or updated since Yesterday, $yesterday with CPE "
./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 7.0 -dt $yesterday -cpe cpe -csv -o $reports
echo "-------------------------------------------------"

#echo "List of new all CVEs created or updated since last week, $lastweek :"
#./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 0.1 -dt $lastweek -csv -o $reports
#echo "-------------------------------------------------"

echo "List of new all CVEs created or updated since last week, $lastweek with CPE:"
./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 0.1 -dt $lastweek -cpe cpe -csv -o $reports
echo "-------------------------------------------------"

#echo "List of sev 7 or greater CVEs created or updated since last week, $lastweek with CPE "
#./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 7.0 -dt $lastweek -cpe cpe -csv -o $reports
#echo "-------------------------------------------------"

#echo "List of sev 7 or greater CVEs created or updated in the last three days, $weekend"
#./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 7.0 -dt $weekend -csv -o $reports
#echo "-------------------------------------------------"

#echo "List of new all CVEs created or updated in the last three days, $weekend with CPE:"
#./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 0.1 -dt $weekend -cpe cpe -csv -o $reports
#echo "-------------------------------------------------"

echo "List of sev 7 or greater CVEs created or updated in the last three days, $weekend with CPE "
./cve_manager.py -u $user -ps $pass -host $host -db $db -sc 7.0 -dt $weekend -cpe cpe -csv -o $reports
echo "-------------------------------------------------"

#-----------------
# delete the CVEs so just the xlsx get emailed
rm <home/reports/dir>/$today/*.csv
#-----------------

#echo "Emailing the reports "
#./email_xlsx_attach.py
#echo "-------------------------------------------------"

