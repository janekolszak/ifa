# The MIT License (MIT)
#
# Copyright (c) 2014 Jan Olszak (j.olszak@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import cython
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.pair cimport pair
from libcpp cimport bool

cdef extern from "distribution_impl.hpp" namespace "ifa":
    cdef cppclass Distribution:
        Distribution() except +
        int size()
        bool isEmpty()
        bool contains(string)
        double get(string) except +
        void set(string, double) except +
        void erase(string)
        void insert(string, double)
        void startIteration()
        pair[string, double] next() except +
        double entropy()
        void normalize()

    void common(Distribution *p, Distribution *q, Distribution *result) nogil
    int direction(Distribution *p, Distribution *q) nogil


cdef extern from "divergence_impl.hpp" namespace "ifa":
    # double jsd(vector[Distribution] distributions, vector[double] weights) nogil
    double jsd(Distribution *p, double p_weight, Distribution *q, double q_weight) nogil
    double indexD(Distribution *p, double p_weight, Distribution *q, double q_weight) nogil

cdef extern from "utils_impl.hpp" namespace "ifa":
    double entropy(double *probabilities, int size) nogil
    void logger(double x) nogil
    int transformIdx(int n, int i, int j) nogil
