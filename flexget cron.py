import subprocess
import time
while 1:
	output = subprocess.Popen(['flexget','--cron','execute'])
	time.sleep(10)