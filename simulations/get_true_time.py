#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      tuk32868
#
# Created:     13/10/2023
# Copyright:   (c) tuk32868 2023
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import pandas as pd
import numpy as np
import sys

def main(name):
    muts = pd.read_csv(name + '.mutations', sep ="\t")
    sites = pd.read_csv(name + ".sites", sep = "\t")
    nodes = pd.read_csv(name + ".nodes", sep ="\t")
    edges = pd.read_csv(name + ".edges", sep = "\t")

    o = open(name + '_true.txt', 'w')
    o.write('site\tposition\tmutationTime\tparentNodeTime\tnodeTime\n')
    #o.write('site\tposition\tmutationTime\n')
    for siteID in muts['site']:
        #print(siteID)
        mut = muts[muts['site'] == siteID]
        time = float(list(mut['time'])[0])
        pos = list(sites.iloc[[siteID]]['position'])[0]
        #o.write('{}\t{}\t{}\n'.format(str(siteID), str(pos), str(time)))
        node = list(mut['node'])[0]
        nodeTime = list(nodes[nodes['id'] == node]['time'])[0]

        potentialParents = edges[edges['child'] == node]
        lefts, rights = list(potentialParents['left']), list(potentialParents['right'])
        for i in range(len(lefts)):
            if (pos > lefts[i]) & (pos < rights[i]):
                parent = list(potentialParents[potentialParents['left'] == lefts[i]]['parent'])[0]
        parentTime = list(nodes[nodes['id'] == parent]['time'])[0]

        o.write('{}\t{}\t{}\t{}\t{}\n'.format(str(siteID), str(pos), str(time), str(parentTime), str(nodeTime)))




if __name__ == '__main__':
    main(sys.argv[1])
