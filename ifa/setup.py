# -*- encoding: utf-8 -*-

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

sourcefiles = ['interface.pyx']
ext_modules = [Extension("ifa",
                         sourcefiles,
                         language="c++",
                         extra_link_args=['-fopenmp'],
                         extra_compile_args=["-Ofast",
                                             "-std=c++11",
                                             "-Wall",
                                             "-fomit-frame-pointer",
                                             "-flto",
                                             "-march=native",
                                             "-fopenmp"])]


setup(
    name='ifa',
    version='0.0.1',
    cmdclass={'build_ext': build_ext},
    license="MIT License",
    ext_modules=ext_modules,
    author="Jan Olszak",
    author_email="janekolszak@gmail.com",
    description="Information Flow Analysis Library",
    keywords="information flow analysis entropy distribution",
    url="http://github.com/janekolszak/ifa",
    classifiers=[
        "Programming Language :: Cython",
        "Programming Language :: C++",
        "Programming Language :: Python",
        "Environment :: Other Environment",
        "Intended Audience :: Developers",
        "Intended Audience :: Information Technology",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Scientific/Engineering :: Information Analysis"
    ],
)
