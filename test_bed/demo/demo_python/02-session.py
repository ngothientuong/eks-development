import os
from timeConverter import timeConverter
import re
import time
import sys

#from multiprocessing import Pool
#import multiprocessing as mul
#################


#del TD_TuongSession  
if __name__ == '__main__':
    # Define timeObj    
    timeObj = timeConverter()
    print(timeObj.epochToDatetime(sys.argv[1]))