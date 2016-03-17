'''
Created on Mar 15, 2016

@author: schackma
'''

from numpy.random import choice
from copy import copy

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
        
    def travel(self):
        
        
        if self.needToVist == []:
            for neighbor in self.city.neighbors:
                if neighbor[0] == self.finalCity:
                    self.path.append(self.finalCity)
                    self.city = self.finalCity
                    self.length+=neighbor[1].dist
                    self.complete = True
                    return True
            return False
                    
        
        choices = []
        probabilities = []
        total = 0
        for neighborTuple in self.city.neighbors:
            [neighbor, path] = neighborTuple
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
        
        for neighborTuple in self.city.neighbors:
            [neighbor, path] = neighborTuple
            dist = path.dist
            pher = path.pher
            if nextCity == neighbor:
                self.length+=dist
                break
        
        self.needToVist.remove(nextCity)
        self.path.append(nextCity)
        self.city = nextCity
        
                
        return True
    
    def isComplete(self):
        return self.complete
    

