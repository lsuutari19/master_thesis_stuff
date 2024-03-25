# https://www.youtube.com/watch?v=yrmPRYSEdg0

import dpkt
from scapy.all import *


def tcp():
    cases = 0
    start = time.time()
    print("Start fuzzing DNS")
    while True:
        # generate tcp packet with scapy.fuzz
        p = raw(fuzz(TCP()))

        # fuzz dpkt
        try:
            dpkt.tcp.TCP(p)
            cases += 1

            # get stats
            if cases % 50000 == 0:
                TCP(p).show()
                print(str(cases) + " | " + str(int(cases/(time.time() - start))) + " per second")

        # catch exception
        # no exception should occurs since scapy.fuzz
        # create only valid tcp packets
        except Exception as e:
            print("Exception : " + str(e))
            print(str(cases) + " | " + str(int(cases/(time.time() - start))) + " per second")
            TCP(p).show()
            raise e

tcp()
