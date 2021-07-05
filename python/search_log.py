# coding=utf-8
import os
import re
import sys
import json
import getopt
from multiprocessing import Process


def query_single_file(query_regex, message, file_name, isFile=False):
        with open(file_name, "r") as f:
            lines = f.readlines()
            for line in lines:
                loginfo = json.loads(line)
                container_queryPattern = re.compile(query_regex, re.I)
                message_queryPattern = re.compile(message, re.I)
                log_data = loginfo["log"]["file"]["path"] if isFile else loginfo["container"]["name"]
                if re.search(container_queryPattern, log_data) and re.search(message_queryPattern, loginfo["message"]):
                    print("{},message={}".format(log_data, loginfo["message"]))


def query(query_regex, message, isFile=False):
    processs = []
    log_path = "../logs/fileRecord.log" if isFile else "../logs/containerRecord.log"
    for i in range(0, 5):
        file_name = os.path.join(os.path.split(__file__)[0], log_path + ("" if i==0 else "."+str(i)))
        if os.path.exists(file_name):
            p = Process(target=query_single_file, args=(query_regex, message, file_name, isFile))
            p.start()
            processs.append(p)
    for p in processs:
        p.join()


def main(argv):
    def print_help():
        print('usage:\n\t{} -c <container> -m <message>\n\tsuport regex'.format(os.path.split(argv[0])[1]))
        print('usage:\n\t{} -f <file> -m <message>\n\tsuport regex'.format(os.path.split(argv[0])[1]))

    container = ''
    file = ''
    message = '.*'
    try:
        opts, args = getopt.getopt(argv[1:], "hc:f:m:", ["help", "container=", "file=", "message="])
    except getopt.GetoptError:
        print_help()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print_help()
            sys.exit()
        elif opt in ("-c", "--container"):
            container = arg
        elif opt in ("-f", "--file"):
            file = arg
        elif opt in ("-m", "--message"):
            message = arg
    if container:
        query(container, message, False)
    elif file:
        query(file, message, True)
    else:
        query('.*', message, False)


if __name__ == "__main__":
   main(sys.argv)

