import sys
import time

sys.path.insert(0, "../net.cjlucas.alfred.tower")
import alp
import tower_alfred as ta

start = time.time()

items = ta.get_items("")
alp.feedback(items)

end = time.time()

print("Time elapsed: {0} seconds".format(end-start))
