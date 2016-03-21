'''
Created on Mar 15, 2016

@author: schackma
'''
import City
import random


def readMap(fileName,rho,t0):
    cityMap = []
    paths = []
    cityNames = []
    
    mapFile = open(fileName)
    line = mapFile.readline()
    
    while line != "":
        [city1, city2, dist] = line.split()
        city1 = int(city1)
        city2 = int(city2)
        dist = int(dist)
        newPath = City.path(dist,t0,rho)
        paths.append(newPath)
        
        # add the cities to the map if they were not visited before
        if city1 not in cityNames:
            cityNames.append(city1)
            cityMap.append(City.city(city1))
        
        if city2 not in cityNames:
            cityNames.append(city2)
            cityMap.append(City.city(city2))
        
        
        # find the cities in the map and add in the neighbors
        for tempCity1 in cityMap:
            if tempCity1.name == city1:
                break
        
        for tempCity2 in cityMap:
            if tempCity2.name == city2:
                break
        
        tempCity1.addNeighbor(tempCity2, newPath)
        tempCity2.addNeighbor(tempCity1, newPath)
        
        line = mapFile.readline()
        
    mapFile.close()
    return [cityMap,paths]



def makeMap(numCities,rho,t0):
    cities = [City.city(i) for i in range(0,numCities)]
    paths = []
    random.seed(1)
    for i in range(0,numCities):
        for j in range(i+1,numCities):
            city1 = cities[i]
            city2 = cities[j]
            newPath = City.path(random.randint(1,100),t0,rho)
            paths.append(newPath)
            city1.addNeighbor(city2,newPath)
            city2.addNeighbor(city1,newPath)
            
    return [cities,paths]
