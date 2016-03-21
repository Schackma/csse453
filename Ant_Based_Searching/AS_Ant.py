'''
Created on Mar 15, 2016

@author: schackma
'''

from numpy.random import choice
from copy import copy
from _overlapped import NULL

class AS_Ant(object):
    '''
    classdocs
    '''


    def __init__(self, cities, start_city, alpha, beta):
        '''
        Constructor
        '''
        self.city = start_city
        self.needToVist = copy(cities)
        self.finalCity = start_city
        self.path = [start_city]
        self.length = 0
        self.alpha = alpha
        self.beta = beta
        self.complete = False
        self.needToVist.remove(start_city);
        
    def travel(self):
        
        
        if self.needToVist == []:
            for [neighbor, path] in self.city.neighbors:
                if neighbor == self.finalCity:
                    self.path.append(self.finalCity)
                    self.city = self.finalCity
                    self.length+=path.dist
                    self.complete = True
                    return True
            return False
                    
        
        choices = []
        probabilities = []
        total = 0
        for [neighbor, path] in self.city.neighbors:
            dist = path.dist
            pher = path.pher
            if neighbor in self.needToVist:
                choices.append(neighbor)
                probabilities.append(pher ** self.alpha * (1 / dist) ** self.beta)
                total += pher ** self.alpha * (1 / dist) ** self.beta
        if total == 0:
            return False
        
        p = [prob / total for prob in probabilities]
        nextCity = choice(choices, p=p)
        
        for [neighbor, path] in self.city.neighbors:
            dist = path.dist
            if nextCity == neighbor:
                self.length+=dist
                break
        
        self.needToVist.remove(nextCity)
        self.path.append(nextCity)
        self.city = nextCity
        
                
        return True
    
    def isComplete(self):
        return self.complete
    
    
def updatePaths(ants,paths,Q,bestLength,bestPath,e):
    [path.decay() for path in paths]
    for ant in ants:
        for i in range(0, len(ant.path)-1):
            city1 = ant.path[i]
            city2 = ant.path[i+1]
            for [city, path] in city1.neighbors:
                if city == city2:
                    path.pher += Q/ant.length
    lastCity= NULL;
    for city in bestPath:
        if(lastCity!=NULL):
            for [tempCity, path] in city.neighbors:
                if tempCity == lastCity:
                    path.pher += e*Q/bestLength
        lastCity = city
    return
    

