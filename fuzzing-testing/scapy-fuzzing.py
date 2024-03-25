# https://www.youtube.com/watch?v=yrmPRYSEdg0
import dpkt
from scapy.all import *


def dns():
    cases = 0
    start = time.time()
    print("Start fuzzing DNS")
    while True:
        # generate dns packet with scapy.fuzz
        p = raw(fuzz(DNS()))

        # fuzz the target
        try:
            dpkt.dns.DNS(p)
            cases += 1

            # get stats
            if cases % 50000 == 0:
                print(str(cases) + " | " + str(int(cases/(time.time() - start))) + " per second")

        # catch exception
        # no exception should occurs since scapy.fuzz
        # create only valid dns packets
        except Exception as e:
            print("Exception : " + str(e))
            print(str(cases) + " | " + str(int(cases/(time.time() - start))) + " per second")
            dns = DNS(p)
            dns.show()
            raise e
dns()
        