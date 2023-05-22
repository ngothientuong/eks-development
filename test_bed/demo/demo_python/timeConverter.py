import datetime
import time
import os
from time import mktime
#import zulu
#from datetime import datetime

class timeConverter():
    def epochToDatetime(self,epochtime):
      self.mytimestamp = int(epochtime) / 1000
      self.mytimestamp = datetime.datetime.fromtimestamp(self.mytimestamp).strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
      #print(self.mytimestamp)
      return self.mytimestamp

    