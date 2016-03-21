'''
Created on Mar 15, 2016

@author: schackma
'''
import mapMaker
import AS_Ant
import random
import time
from copy import copy

alpha = 1
beta = 2
numAnts = 50
Q = 300
rho = .5
numIterations = 50
t0 = 10**-6
e = 4



def performTSP(numCities):
#     [cities,paths] = mapMaker.makeMap(numCities,rho,t0)
    [cities,paths] = mapMaker.readMap("./maps/thirtySparse.txt",rho,t0)
    
    bestLength = 99999999999
    bestPath = []
    iteration = -1
    sameResult = 0;
    
    startTime = time.time()
    
    for i in range(0,numIterations):
        ants = [AS_Ant.AS_Ant(cities, random.choice(cities),alpha,beta) for i in range (1, numAnts)]

        while [ant for ant in ants if ant.isComplete()] ==[] and ants != []:
            ants = [ant for ant in  ants if ant.travel()]
        
        if(ants ==[]):
            continue
        minAnt = min(ants, key=lambda path:path.length)
        

        
        if abs(minAnt.length - bestLength)<5:
            sameResult+=1
        elif minAnt.length < bestLength:
            bestLength = minAnt.length
            bestPath = copy(minAnt.path)
            iteration = i
            sameResult = 0
        
        if sameResult == 5:
            break;   
    
     
#         print([city.name for city in ants[0].path])
#         print(ants[0].length)
        AS_Ant.updatePaths(ants,paths,Q,bestLength,bestPath,e)
    print("number of cities: ",len())
    print("time: ",time.time()-startTime)
    print("best item found on iteration: ",iteration)
    print("City path is:")
    print([city.name for city in bestPath])
    print("Length of path: ",bestLength)



if __name__ == '__main__':
    performTSP(80)
    pass

