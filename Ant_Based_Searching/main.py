'''
Created on Mar 15, 2016

@author: schackma
'''
import mapMaker
from AS_Ant import AS_Ant
from copy import copy


def updatePaths(ants,paths,Q):
    [path.decay() for path in paths]
    for ant in ants:
        for i in range(0, len(ant.path)-2):
            city1 = ant.path[i]
            city2 = ant.path[i+1]
            for [city, path] in city1.neighbors:
                if city == city2:
                    path.pher += Q/ant.length
        
    
    return

if __name__ == '__main__':
    alpha = 1
    beta = 5
    numAnts = 200
    Q = 100
    rho = .5
    numIterations = 100
    [cities,paths] = mapMaker.readMap('maps/twelve.txt',rho)
    start_city = cities[0]
    cities.remove(start_city)
    
    bestLength = 99999999999
    bestPath = []
    
    
    for i in range(0,numIterations):
        ants = [AS_Ant(cities, start_city,alpha,beta) for i in range (1, numAnts)]

        while [ant for ant in ants if ant.isComplete()] ==[]:
            ants = [ant for ant in  ants if ant.travel()]
        
        ants = sorted(ants, key=lambda path:path.length)
        if ants[0].length < bestLength:
            bestLength = ants[0].length
            bestPath = copy(ants[0].path)
    
    
    
        print([city.name for city in bestPath])
        print(bestLength)
        updatePaths(ants,paths,Q)
    
    
    
    pass




