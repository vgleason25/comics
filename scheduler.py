import pytz
import requests
import subprocess
from apscheduler.schedulers.twisted import TwistedScheduler
from twisted.internet import reactor


def send_request():
   requests.post("https://<HEROKU_APP_NAME>.herokuapp.com/schedule.json", data={
       "project": "comics",
       "spider": "spiderman"
   })


if __name__ == "__main__":
   subprocess.run("scrapyd-deploy", shell=True, universal_newlines=True)
   scheduler = TwistedScheduler(timezone=pytz.timezone('Asia/Kolkata'))
   # cron trigger that schedules job every every 20 minutues on weekdays
   scheduler.add_job(send_request, 'cron', day_of_week='*', hour='4')
   # start the scheduler
   scheduler.start()
   reactor.run()