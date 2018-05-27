import pickle
import sys
import time 

def tic():
  return time.time()
def toc(tstart, nm=""):
  print('%s took: %s sec.\n' % (nm,(time.time() - tstart)))

def read_data(fname):
  d = []
  with open(fname, 'rb') as f:
    if sys.version_info[0] < 3:
      d = pickle.load(f)
    else:
      d = pickle.load(f, encoding='latin1')  # need for python 3
  return d

dataset="12" 
cfile = "testset/cam/cam" + dataset + ".p"
ifile = "testset/imu/imuRaw" + dataset + ".p"

ts = tic()
camd = read_data(cfile)
imud = read_data(ifile)
toc(ts,"Data import")

#camd['cam'][:,:,:,i] is the 240x320x3 image at timestep i
