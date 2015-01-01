#ifndef IFA_H
#define IFA_H

#include <vector>
#include <map>
#include <string>


typedef std::map<std::string, double> Distribution;
typedef std::string DistributionID;

void c_logd(int x);

double c_entropy(const std::vector<double> &probabilities);

double c_entropy_of_distribution(const Distribution &distribution);

double c_jsd(const std::vector<Distribution> &distributions,
             const std::vector<double> &weights);

Distribution c_common(const Distribution &p,
                      const Distribution &q);

int c_direction(const Distribution &p,
                const Distribution &q);

double c_index_d(const Distribution &p,
                 const Distribution &q,
                 const double p_weight,
                 const double q_weight);
#endif
