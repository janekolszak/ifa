# -*- encoding: utf-8 -*-
import os
import sys

from distutils.core import setup
from distutils.extension import Extension

try:
    from Cython.Distutils import build_ext
except ImportError:
    # No Cython
    source_extension = ".cpp"
    cmdclass = {}
else:
    # There's Cython
    source_extension = ".pyx"
    cmdclass = {'build_ext': build_ext}


flags = ["-O3",
         "-std=c++11",
         "-Wall",
         "-fomit-frame-pointer",
         "-flto",
         "-march=native",
         "-ffast-math",
         "-funroll-loops",
         "-Wno-cpp",
         "-Wno-unused-function",
         "-Wno-maybe-uninitialized"]


# TODO: Delete before release
# flags = ["-O0", "-std=c++11"]

version = '0.0.3'

setup(
    name='ifa',
    packages=['ifa'],
    version=version,
    cmdclass=cmdclass,
    license="MIT License",
    author="Jan Olszak",
    author_email="janekolszak@gmail.com",
    description="A library for information flow analysis",
    keywords="information flow analysis entropy distribution",
    url="http://github.com/janekolszak/ifa",
    download_url="https://github.com/janekolszak/ifa/archive/ifa-" + version + ".tar.gz",
    ext_modules=[Extension("ifa.utils",
                           sources=[
                               'ifa/utils' + source_extension,
                               'ifa/utils_impl.cpp'
                           ],
                           language="c++",
                           extra_compile_args=flags),

                 Extension("ifa.distribution",
                           sources=[
                               'ifa/distribution' + source_extension,
                               'ifa/distribution_impl.cpp'
                           ],
                           language="c++",
                           extra_compile_args=flags),

                 Extension("ifa.divergence",
                           sources=[
                               'ifa/divergence' + source_extension,
                               'ifa/divergence_impl.cpp',
                               'ifa/distribution_impl.cpp'
                           ],
                           language="c++",
                           extra_compile_args=flags),

                 Extension("ifa.connections",
                           sources=[
                               'ifa/connections' + source_extension,
                               'ifa/divergence_impl.cpp',
                               'ifa/utils_impl.cpp',
                               'ifa/distribution_impl.cpp'
                           ],
                           language="c++",
                           extra_compile_args=flags + ["-fopenmp"],
                           extra_link_args=['-fopenmp']),
                 ],
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
