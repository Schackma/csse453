classdef BOT < handle
    %BOT a robot that can map
    
    properties
        motherPos; currentPos;
        rows; cols;
        goalPos;
        targetPos;
        map;
        com_range = 5;
        
        wall = 1;
        unexplored = 0;
        visitedPoint = -1;
        
        broadcastMessage;
        newFinds=[];
        
        mode;
        EXPLORE = 1;
        INFORM = 2;
        RETURN = 3;
        
        path;
        
        LEFT = 1;
        RIGHT = 2;
        UP = 3;
        DOWN = 4;
    end
    
    methods
        function obj = BOT(pos,motherPos,toss_map)
            [obj.rows,obj.cols] = size(toss_map);
            obj.map = zeros(obj.rows,obj.cols);
            obj.mode = obj.EXPLORE;

            obj.motherPos =motherPos;
            obj.currentPos = [pos(2), pos(1)];
            
            obj.checkSurroundings(toss_map,[]);
       end
        
        function obj = move(obj,globalMap,botList,targetList)
            switch obj.mode
                case obj.EXPLORE
                    obj.broadcastMessage = 'SEARCHING';
                    if isempty(obj.path)
                        obj.findPath();
                    end
                    [row,col] = size(obj.path);
                    stepDir = obj.path(1);
                    obj.path = obj.path(2:end);
                case obj.INFORM
                    if isempty(obj.path)
                        if sum(obj.currentPos==obj.motherPos)==2
                            fprintf('found a target and told mom\n');
                            obj.mode = obj.EXPLORE;
                        else
                            obj.findPathHome;
                        end
                        return
                    else
                        stepDir = obj.path(1);
                        obj.path = obj.path(2:end);
                    end
                    obj.broadcastMessage = 'FOUND_VICTIM';
                case obj.RETURN
                    if isempty(obj.path)
                        if sum(obj.currentPos==obj.motherPos)==2
                            fprintf('made it home\n');
                        else
                            obj.findPathHome;
                        end
                        return
                    else
                        stepDir = obj.path(1);
                        obj.path = obj.path(2:end);
                    end
                    obj.broadcastMessage = 'MAP_COMPLETE';
            end
            obj.moveWay(stepDir,botList,globalMap);
            obj.checkSurroundings(globalMap,targetList);
            obj.broadcast(botList);
        end
        
        function broadcast(obj,botList)
            for i = 1:size(botList,2)
                if(botList(i) ~=obj && obj.dist(botList(i).currentPos))
                new_map = obj.map+botList(i).map;
                new_map(new_map > 0) = 1;
                new_map(new_map < 0) = -1;
                [rowIs colIs] = find(abs(obj.map)-abs(new_map) ~= 0);
                obj.newFinds = [obj.newFinds, [rowIs' ; colIs']];
                obj.map = new_map;
                [rowIs colIs] = find(abs(botList(i).map)-abs(new_map) ~= 0);
                botList(i).newFinds = [botList(i).newFinds, [rowIs' ; colIs']];
                botList(i).map = new_map;
                end
            end
        end
        
        function output = dist(obj,otherPos)
            output = obj.com_range > sqrt(sum((obj.currentPos-otherPos).^2));
        end

        function findPath(obj)
            tempMap = obj.map; tempMap(obj.currentPos(1),obj.currentPos(2)) = obj.wall;
            
            startNode = {}; startNode.pos = [obj.currentPos(1),obj.currentPos(2)]; startNode.dirs = []; startNode.finished = 0;
            nodes = startNode;
                        
            while ~nodes(1).finished
              r = nodes(1).pos(1); c = nodes(1).pos(2); tempMap(r,c) = obj.wall; %set iteration vars
              [nodes,tempMap] = obj.addPointsToQueue([r,c],nodes,tempMap);
              nodes = nodes(2:size(nodes,2)); %shrink nodes by 1
              if(size(nodes,2) == 0)
                  obj.mode = obj.RETURN;
                  obj.findPathHome;
                  return; %there's nothing left for you here, adventurer
              end
            end
            obj.path = nodes(1).dirs(1:end-1);
        end
        
       function findPathHome(obj)
            tempMap = obj.map; tempMap(obj.currentPos(1),obj.currentPos(2)) = obj.wall;
            
            startNode = {}; startNode.pos = [obj.currentPos(1),obj.currentPos(2)]; startNode.dirs = []; startNode.finished = 0;
            nodes = startNode;
                        
            while sum(nodes(1).pos ==obj.motherPos)~=2
              r = nodes(1).pos(1); c = nodes(1).pos(2); tempMap(r,c) = obj.wall; %set iteration vars
              [nodes,tempMap] = obj.addPointsToQueue([r,c],nodes,tempMap);
              nodes = nodes(2:size(nodes,2)); %shrink nodes by 1
              if(size(nodes,2) == 0)
                  return; %oh god you messed up, I dont know how you messed up this bad but you did
              end
            end
            obj.path = nodes(1).dirs;
        end
        
        
        function [nodes,tempMap] = addPointsToQueue(obj,pos,nodes,tempMap)
            r = pos(1); c = pos(2);
            bounds = obj.checkBoundaries(r,c);
            pointsToCheck = [r,c-1; r,c+1; r-1,c; r+1,c;];
            
            for i = 1:4
               if bounds(i)
                    if tempMap(pointsToCheck(i,1),pointsToCheck(i,2)) ~= obj.wall
                        toAdd = {};
                        if tempMap(pointsToCheck(i,1),pointsToCheck(i,2)) == obj.unexplored
                            toAdd.finished = 1;
                        else
                            toAdd.finished = 0;
                        end
                        tempMap(pointsToCheck(i,1),pointsToCheck(i,2)) = obj.wall;

                        toAdd.pos = pointsToCheck(i,:);
                        toAdd.dirs = [nodes(1).dirs, i];
                        nodes = [nodes,toAdd];
                    end
               end
            end
        end
        
        function bounds = checkBoundaries(obj,r,c)
            bounds = [0, 0, 0, 0];
            if(c-1 > 0)
                bounds(1) = 1; %left
            end
            if(c+1 <= obj.cols)
                bounds(2) = 1; %right
            end
            if(r-1 > 0)
                bounds(3) = 1; %up
            end
            if(r+1 <= obj.rows)
                bounds(4) = 1; %down
            end
        end
        
        
        
        function moveWay(obj,dir,botList,globalMap)
            dr = 0; dc = 0;
            switch dir
                case obj.LEFT
                    dc = -1;
                case obj.RIGHT
                    dc = 1;
                case obj.UP
                    dr = -1;
                case obj.DOWN
                    dr = 1;
            end
            for i=1:size(botList,2)
                if(sum(botList(i).currentPos == [obj.currentPos(1)+dr,obj.currentPos(2)+dc]) == 2)
                    obj.path = [];
                    return %space is currently occupied by another bot
                end
            end
            if globalMap(obj.currentPos(1)+dr,obj.currentPos(2)+dc) == obj.wall
                fprintf('I just tried to move through a wall')
                obj.path = [];
                return
            end
            obj.currentPos = [obj.currentPos(1)+dr,obj.currentPos(2)+dc];
        end
        
        function obj = checkSurroundings(obj,globalMap,targetList)
            r = obj.currentPos(1); c = obj.currentPos(2);
            bounds = obj.checkBoundaries(r,c);
            pointsToCheck = [r,c-1; r,c+1; r-1,c; r+1,c;];
            
            for i = 1:4
               if bounds(i)
                   if globalMap(pointsToCheck(i,1),pointsToCheck(i,2)) == obj.wall
                       obj.map(pointsToCheck(i,1),pointsToCheck(i,2)) = obj.wall;
                   elseif(obj.map(pointsToCheck(i,1),pointsToCheck(i,2))) == obj.unexplored
                       obj.map(pointsToCheck(i,1),pointsToCheck(i,2)) = obj.visitedPoint;
                       obj.newFinds = [obj.newFinds, pointsToCheck(i,:)'];
                   end
                   if ~isempty(targetList)
                       for j =1:size(targetList,1)
                           if targetList(j,:)==pointsToCheck(i,:)
                               obj.mode = obj.INFORM;
                               obj.targetPos = targetList(j,:);
                               findPathHome;
                           end
                       end
                   end
               end
            end
        end
    end
end