# coding: utf-8
import os
from pathlib import Path
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from distutils.command import clean
from Cython.Build import cythonize

SRC_DIR = "extractor"
IGNORE_FILES = ["__init__.py"]
all_files = [str(i) for i in Path(SRC_DIR).rglob('*.py') if i.name not in IGNORE_FILES]
extensions = [Extension(i.replace(os.path.sep, '.').rstrip('.py'), [i], include_dirs=['.']) for i in all_files]


class CustomBuildExt(build_ext):
    def clean_build(self, distribution):
        clean_command = clean.clean(distribution)
        clean_command.all = True
        clean_command.finalize_options()
        clean_command.run()

    def run(self):
        build_ext.run(self)
        build_path = os.path.join(self.build_lib, SRC_DIR)
        all_so = Path(build_path).rglob('*.so')
        for i in all_so:
            os.system(f'cp {str(i)} {str(i).replace(build_path, SRC_DIR)}')
        self.clean_build(self.distribution)
        for i in Path(SRC_DIR).rglob('*'):
            if i.name.rsplit('.', 1)[-1] in ['py', 'pyc', 'c'] and i.name not in IGNORE_FILES:
                os.remove(str(i))


setup(
    name=SRC_DIR,
    script_args=['build_ext'],
    packages=[i.rsplit('/', 1)[0].replace('/', '.') for i in all_files],
    ext_modules=cythonize(extensions, compiler_directives={'always_allow_keywords': True, 'language_level': 3}),
    cmdclass={'build_ext': CustomBuildExt},
    requires=['numpy', 'pandas', 'scikit_image', 'matplotlib', 'opencv_python', 'pillow', 'python_docx']
)
