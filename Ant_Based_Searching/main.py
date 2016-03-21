'''
Created on Mar 15, 2016

@author: schackma
'''
import mapMaker
import AS_Ant
from copy import copy




if __name__ == '__main__':
    alpha = 1
    beta = 5
    numAnts = 200
    Q = 275
    rho = .5
    numIterations = 100
    t0 = 10**-6
    
    [cities,paths] = mapMaker.readMap('maps/twelve.txt',rho,t0)
    start_city = cities[0]
    cities.remove(start_city)
    
    bestLength = 99999999999
    bestPath = []
    
    
    for i in range(0,numIterations):
        ants = [AS_Ant.AS_Ant(cities, start_city,alpha,beta) for i in range (1, numAnts)]

        while [ant for ant in ants if ant.isComplete()] ==[]:
            ants = [ant for ant in  ants if ant.travel()]
        
        ants = sorted(ants, key=lambda path:path.length)
        if ants[0].length < bestLength:
            bestLength = ants[0].length
            bestPath = copy(ants[0].path)
    
    
    
        print([city.name for city in bestPath])
        print(bestLength)
        AS_Ant.updatePaths(ants,paths,Q)
    
    
    
    pass




