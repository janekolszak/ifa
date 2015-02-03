#cython: boundscheck=False, wraparound=False, overflowcheck=True, embedsignature=True

# The MIT License (MIT)
#
# Copyright (c) 2015 Jan Olszak (j.olszak@gmail.com)
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
import ctypes
import numpy as np
cimport numpy as np
from libcpp.vector cimport vector

from c_declarations cimport jsd as c_jsd
from c_declarations cimport kld as c_kld
from c_declarations cimport indexD as c_indexD
from distribution cimport Distribution

cpdef jsd(p, double p_weight, q, double q_weight):
    return c_jsd((<Distribution?>p).thisptr, p_weight,
                 (<Distribution?>q).thisptr, q_weight)

cpdef indexD(p, double p_weight, q, double q_weight):
    return c_indexD((<Distribution?>p).thisptr, p_weight,
                    (<Distribution?>q).thisptr, q_weight)

cpdef kld(p, q):
    # http://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence
    return c_kld((<Distribution?>p).thisptr, (<Distribution?>q).thisptr)
