
import sys
import os
from distutils.extension import Extension
from distutils.core import setup
from Cython.Build import cythonize
import numpy

# we'd better have Cython installed, or it's a no-go
try:
    from Cython.Distutils import build_ext
except:
    print("You don't seem to have Cython installed. Please get a")
    print("copy from www.cython.org and install it")
    sys.exit(1)

SRC_DIR = "idcard_extraction"
print(os.path.abspath(SRC_DIR))
MODULE_NAME = "idcard_extraction"
IGNORE_FILES = ["__init__.py"]


def scandir(dir, files=[]):
    for file in os.listdir(dir):
        if file in IGNORE_FILES:
            continue
        path = os.path.join(dir, file)
        if os.path.isfile(path):
            if path.endswith(".py") or path.endswith(".pyx"):
                files.append(path)
        elif os.path.isdir(path):
            scandir(path, files)
    return files


def make_extension(extPath):
    if extPath.endswith('.py'):
        extName = extPath[:-3].replace(os.path.sep, '.')
    else:
        extName = extPath[:-4].replace(os.path.sep, '.')
        return Extension(extName, [extPath], include_dirs=[numpy.get_include()])
    return Extension(extName, [extPath], include_dirs=["."])


def get_packages(folder, packages=[]):
    for file in os.listdir(folder):
        if file in IGNORE_FILES:
            continue
        path = os.path.join(folder, file)
        if os.path.isdir(path) and os.path.exists('{}/__init__.py'.format(path)):
            packages.append(path)
            get_packages(path, packages)
    packages.append(folder)
    return [p.replace('/', '.') for p in packages]


def clean(target_dir):
    for file in os.listdir(target_dir):
        path = os.path.join(target_dir, file)
        if os.path.isfile(path) and file not in IGNORE_FILES and \
                (file.endswith('py') or file.endswith('pyx') or
                 file.endswith('.c') or file.endswith('hpp') or file.endswith('cpp') or file.endswith('conf')):
            os.system("rm {}".format(path))
        elif os.path.isdir(path):
            clean(path)


def copy_so(target_dir, build_base_dir, target_base_dir):
    for file in os.listdir(target_dir):
        path = os.path.join(target_dir, file)
        if os.path.isfile(path) and path.endswith(".so"):
            new_path = path.replace(build_base_dir, target_base_dir)
            os.system("cp {} {}".format(path, new_path))
        elif os.path.isdir(path):
            copy_so(path, build_base_dir, target_base_dir)


def get_build_base_dir(src_dir):
    for file in os.listdir('build'):
        if file[:3] == 'lib':
            return 'build/{}/{}'.format(file, src_dir)


if __name__ == '__main__':
    ext_paths = scandir(SRC_DIR)
    extensions = [make_extension(ext_path) for ext_path in ext_paths]
    packages = get_packages(SRC_DIR)
    print(packages)
    setup(
        name=MODULE_NAME,
        packages=packages,
        ext_modules=cythonize(extensions, compiler_directives={'always_allow_keywords': True}),
        cmdclass={'build_ext': build_ext}
    )
    clean(SRC_DIR)
    build_base_dir = get_build_base_dir(SRC_DIR)
    copy_so(build_base_dir, build_base_dir, SRC_DIR)
    print(build_base_dir)
    os.system("rm -rf build")
