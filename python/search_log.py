# coding=utf-8
import os
import sys
import getopt


def main(argv):
    def print_help():
        print('usage:\n\t{} -c <container> -m <message>\n\tsuport regex'.format(os.path.split(argv[0])[1]))
        print('usage:\n\t{} -f <file> -m <message>\n\tsuport regex'.format(os.path.split(argv[0])[1]))

    try:
        opts, args = getopt.getopt(argv[1:], "hc:f:m:", ["help", "container=", "file=", "message="])
    except getopt.GetoptError:
        print_help()
        exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print_help()
            exit(0)
        elif opt in ("-c", "--container"):
            print('container', arg)
        elif opt in ("-f", "--file"):
            print('file', arg)
        elif opt in ("-m", "--message"):
            print('message', arg)


if __name__ == "__main__":
   main(sys.argv)

