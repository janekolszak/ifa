Information Flow Analysis
=========================

IFA is a simple library for information flow analysis. 
It's in Pre-alpha stage.

Installation
============
````bash
sudo make install
````

Usage
=====
Computing Jensen–Shannon divergence:
````python
import ifa 

p = {"A": 0.4, "B": 0.6}
q = {"A": 0.3, "B": 0.3, "C": 0.3}
weights = [0.2, 0.8] #sum to 1.0
print ifa.jsd([p, q], w)
````
