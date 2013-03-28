import sys
import time
start = time.time()

sys.path.insert(0, "../net.cjlucas.alfred.tower")
import alp
import tower_alfred as ta


items = ta.get_items("")
alp.feedback(items)

end = time.time()

print("Time elapsed: {0} seconds".format(end-start))
