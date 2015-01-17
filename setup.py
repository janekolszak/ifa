# -*- encoding: utf-8 -*-
import os
import sys

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

flags = ["-Ofast",
         "-std=c++11",
         "-Wall",
         "-fomit-frame-pointer",
         "-flto",
         "-march=native"]

# TODO: Delete before release
# flags = ["-O0", "-std=c++11"]

version = '0.0.3'

setup(
    name='ifa',
    packages=['ifa'],
    version=version,
    cmdclass={'build_ext': build_ext},
    license="MIT License",
    author="Jan Olszak",
    author_email="janekolszak@gmail.com",
    description="A library for information flow analysis",
    keywords="information flow analysis entropy distribution",
    url="http://github.com/janekolszak/ifa",
    download_url="https://github.com/janekolszak/ifa/archive/ifa-" + version + ".tar.gz",
    ext_modules=cythonize([Extension("ifa.utils",
                                     sources=[
                                         'ifa/utils.pyx',
                                         'ifa/utils_impl.cpp'
                                     ],
                                     language="c++",
                                     extra_compile_args=flags),

                           Extension("ifa.distribution",
                                     sources=[
                                         'ifa/distribution.pyx',
                                         'ifa/distribution_impl.cpp'
                                     ],
                                     language="c++",
                                     extra_compile_args=flags),

                           Extension("ifa.divergence",
                                     sources=[
                                         'ifa/divergence.pyx',
                                         'ifa/divergence_impl.cpp',
                                         'ifa/distribution_impl.cpp'
                                     ],
                                     language="c++",
                                     extra_compile_args=flags),

                           Extension("ifa.connections",
                                     sources=[
                                         'ifa/connections.pyx',
                                         'ifa/divergence_impl.cpp',
                                         'ifa/utils_impl.cpp',
                                         'ifa/distribution_impl.cpp'
                                     ],
                                     language="c++",
                                     extra_compile_args=flags + ["-fopenmp"],
                                     extra_link_args=['-fopenmp']),
                           ]),
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
