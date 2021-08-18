import subprocess
import sys


def _get_cmd_return_code(cmd):
    _print(cmd)
    sys.stdout.flush()
    sys.stderr.flush()
    return_code = subprocess.Popen(cmd, stdout=sys.stdout, stderr=sys.stderr, shell=True).wait()
    return return_code


def _get_cmd_output(cmd):
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
    output_lines = []
    while process.poll() is None:
        line = process.stdout.readline()
        line = line.strip()
        if line:
            output_lines.append(line)
    return_code = process.returncode
    return output_lines, return_code


def do_with_output(cmd):
    return subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).communicate()[0].decode('utf8')

def _print(content, is_green: bool=True):
    if is_green:
        print('\033[1;32m{}\033[0m'.format(content))
    else:
        print('\033[1;31m{}\033[0m'.format(content))

