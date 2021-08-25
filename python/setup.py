from setuptools import setup, find_packages

setup(
    name='libx',
    version='0.3.1',
    description='my super python lib',
    classifiers=[
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python',
        'Intended Audience :: Developers',
        'Operating System :: OS Independent',
    ],
    author='super',
    url='https://github.com/yangyueguang/study',
    author_email='2829969299@qq.com',
    license='MIT',
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    keywords=["pdf", "extractor", "parser"],
    long_description="extract pdf include edit or not",
    platforms=["ANY"],
    python_requires='>=3.7',
    install_requires=['numpy', 'pandas', 'scikit-image', 'matplotlib', 'opencv-python', 'pillow', 'python-docx']
)
