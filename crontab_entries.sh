# crontab edits to make it run daily or give different reports on mondays vs tues-fri
# m h  dom mon dow   command
#0 4 * * * cd <home/dir/>; ./daily.sh  #If you want the same reports every day
#0 4 * * Mon cd </home/dir/>; ./monday.sh  #To customize reports for Mondays
#0 4 * * Tue,Wed,Thu,Fri cd </home/dir/>; ./weekday.sh #To customize reports for weekdays Tues-Fri

