classdef BOT < handle
    %BOT a robot that can map
    
    properties
        map;
        currentPos;
        sizex; sizey;
        goalPos;
        

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
        UP = 1;
        DOWN = 2;
        LEFT = 3;
        RIGHT = 4;
    end
    
    methods
        function obj = BOT(pos,motherPos,toss_map)
            [obj.sizey,obj.sizex] = size(toss_map);
            obj.map = zeros(obj.sizex,obj.sizey);
            obj.map(motherPos(2),motherPos(1)) = -1;
            obj.mode = obj.EXPLORE;
            obj.currentPos = pos;
            obj.checkSurroundings(toss_map);
       end
        
        function obj = move(obj,globalMap)
            switch obj.mode
                case obj.EXPLORE
                    obj.broadcastMessage = 'SEARCHING';
                    if isempty(obj.path)
                        deltaPos = obj.findPath();
                        obj.path = obj.path(2:end,:);
                    else
                        deltaPos = obj.path(1,:);
                        obj.path = obj.path(2:end,:);
                    end
                case obj.INFORM
                    if isempty(obj.path)
                        deltaPos = obj.findPathHome();
                        obj.path = obj.path(2:end,:);
                    else
                        deltaPos = obj.path(1,:);
                        obj.path = obj.path(2:end,:);
                    end
                    obj.broadcastMessage = 'FOUND_VICTIM';
                case obj.RETURN
                    size(obj.path)
                    if isempty(obj.path)
                        deltaPos = obj.findPathHome();
                    else
                        deltaPos = obj.path(1,:);
                        obj.path = obj.path(2:end,:);
                    end
                    obj.broadcastMessage = 'MAP_COMPLETE';
            end
            obj.currentPos =obj.currentPos+deltaPos;
            obj.checkSurroundings(globalMap);
        end
        
%         function output = findClosestPoint(obj)
%             x = obj.currentPos(1);
%             y = obj.currentPos(2);
%             possPoints=[0;0;0];
%             tempMap = obj.map;
%             tempMap(y,x) = -1;
%             initial = true;
%             dx = 0;
%             dy = 0;
%             currentPoint = obj.map(y,x);
%             i=0;
%             while currentPoint ~=0
%                 bounds = obj.checkBoundaries(x,y);
%                 if bounds(4) && obj.map(y+1,x)~=obj.wall && tempMap(y+1,x) ~=-1
%                     if initial
%                         possPoints = [possPoints(:,1),[y+1;x;obj.DOWN],possPoints(:,2:end)];
%                     else
%                         possPoints = [possPoints(:,1),[y+1;x;currentDirection],possPoints(:,2:end)];
%                     end
%                 end
%                 if bounds(3) && obj.map(y-1,x)~=obj.wall && tempMap(y-1,x) ~=-1
%                     if initial
%                         possPoints = [possPoints(:,1),[y-1;x;obj.UP],possPoints(:,2:end)];
%                     else
%                         possPoints = [possPoints(:,1),[y-1;x;currentDirection],possPoints(:,2:end)];
%                     end
%                    
%                 end
%                 if bounds(2) && obj.map(y,x+1)~=obj.wall&& tempMap(y,x+1) ~=-1
%                     if initial
%                         possPoints = [possPoints(:,1),[y;x+1;obj.RIGHT],possPoints(:,2:end)];
%                     else
%                         possPoints = [possPoints(:,1),[y;x+1;currentDirection],possPoints(:,2:end)];
%                     end
%                 end
%                 if bounds(1) && obj.map(y,x-1)~=obj.wall&& tempMap(y,x-1) ~=-1
%                     if initial
%                         possPoints = [possPoints(:,1),[y;x-1;obj.LEFT],possPoints(:,2:end)];
%                     else
%                         possPoints = [possPoints(:,1),[y;x-1;currentDirection],possPoints(:,2:end)];
%                     end
%                 end
%                 initial = false;
%                 tempMap(y,x) =-1;
%                 newData = possPoints(:,end);
%                 y = newData(1);
%                 x = newData(2);
%                 currentDirection = newData(3);
%                 if(x==0 && y==0)
%                     break
%                 end
%                 currentPoint = obj.map(y,x);
%                 possPoints = possPoints(:,1:end-1);
%                 i=i+1;
%             end
%             
%             switch currentDirection
%                 case obj.UP
%                     dx = 0;
%                     dy = -1;
%                 case obj.DOWN
%                     dx = 0;
%                     dy = 1;
%                 case obj.LEFT
%                     dx = -1;
%                     dy = 0;
%                 case obj.RIGHT
%                     dx = 1;
%                     dy = 0;
%                 otherwise
%                     obj.mode= obj.RETURN;
%             end
%             output = [dx,dy];
%         end

        function output = findPath(obj)
            currx = obj.currentPos(1);
            curry = obj.currentPos(2);
            possPoints=[0;0;0];
            currentPoint = obj.map(curry,currx);
            x = currx;
            y = curry;
            currentDirection =0;
            visited = [0;0;0];
            tempMap = obj.map;
            tempMap(y,x)=obj.wall;
            i=1;
            while currentPoint ~=obj.unexplored
               bounds = obj.checkBoundaries(x,y);
               if bounds(4) && tempMap(y+1,x)~=obj.wall
                   possPoints = [possPoints(:,1),[y+1;x;obj.DOWN],possPoints(:,2:end)];
               end
               if bounds(3) && tempMap(y-1,x)~=obj.wall
                   possPoints = [possPoints(:,1),[y-1;x;obj.UP],possPoints(:,2:end)];
               end
               if bounds(2) && tempMap(y,x+1)~=obj.wall
                   possPoints = [possPoints(:,1),[y;x+1;obj.RIGHT],possPoints(:,2:end)];
               end
               if bounds(1) && tempMap(y,x-1)~=obj.wall
                   possPoints = [possPoints(:,1),[y;x-1;obj.LEFT],possPoints(:,2:end)];
               end
               if tempMap(x,y) ~=obj.wall
                    visited = [visited,[y;x;currentDirection]];
               end
                newData = possPoints(:,end);
                y = newData(1);
                x = newData(2);
                currentDirection = newData(3);
                currentPoint = obj.map(y,x);
                tempMap(y,x)=obj.wall;
                possPoints = possPoints(:,1:end-1);
                i=i+1;
            end
            obj.goalPos(1) = x;
            obj.goalPos(2) = y;
            [vizX,vizY] = size(visited);
            while x~=currx || y~=curry
                [dx,dy] = obj.moveWay(currentDirection);
                x = x+dx;
                y = y+dy;
                check = [ones(1,vizY).*y;ones(1,vizY).*x];
                find((sum((visited(1:2,:) == check)) == 2) == 1);
                currentDirection = visited(3,find((sum((visited(1:2,:) == check)) == 2) == 1));
                currentDirection = currentDirection(1);
                obj.path = [dx,dy;obj.path];
            end
            obj.path =obj.path *-1;
            obj.path = obj.path(2:end,:);
            output = [-dx,-dy];
        end
        
        
        function output = findPathHome(obj)
            currx = obj.currentPos(1);
            curry = obj.currentPos(2);
            possPoints=[0;0;0];
            currentPoint = obj.map(curry,currx);
            x = currx;
            y = curry;
            currentDirection =0;
            visited = [0;0;0];
            tempMap = obj.map;
            tempMap(y,x)=-1;
            while currentPoint ~=-1
                bounds = obj.checkBoundaries(x,y);
               if bounds(4) && obj.map(y+1,x)~=obj.wall && tempMap(y+1,x) ~=2
                   possPoints = [possPoints(:,1),[y+1;x;obj.DOWN],possPoints(:,2:end)];
               end
               if bounds(3) && obj.map(y-1,x)~=obj.wall && tempMap(y-1,x) ~=2
                   possPoints = [possPoints(:,1),[y-1;x;obj.UP],possPoints(:,2:end)];
               end
               if bounds(2) &&obj.map(y,x+1)~=obj.wall && tempMap(y,x+1) ~=2
                   possPoints = [possPoints(:,1),[y;x+1;obj.RIGHT],possPoints(:,2:end)];
               end
               if bounds(1) && obj.map(y,x-1)~=obj.wall&& tempMap(y,x-1) ~=2
                   possPoints = [possPoints(:,1),[y;x-1;obj.LEFT],possPoints(:,2:end)];
               end
               if tempMap(x,y) ~=1
                    visited = [visited,[y;x;currentDirection]];
               end
                newData = possPoints(:,end);
                y = newData(1);
                x = newData(2);
                currentDirection = newData(3);
                currentPoint = obj.map(y,x);
                tempMap(y,x)=2;
                possPoints = possPoints(:,1:end-1);
            end
            [vizX,vizY] = size(visited);
            while x~=currx || y~=curry
                [dx,dy] = obj.moveWay(currentDirection);
                x = x+dx;
                y = y+dy;
                check = [ones(1,vizY).*y;ones(1,vizY).*x];
                find((sum((visited(1:2,:) == check)) == 2) == 1)
                currentDirection = visited(3,find((sum((visited(1:2,:) == check)) == 2) == 1));
                obj.path = [dx,dy;obj.path];
            end
            obj.path =obj.path *-1;
            obj.path = obj.path(2:end,:);
            output = [-dx,-dy];
        end
        
        function [x,y] = moveWay(obj,dir)
            switch dir
                case obj.DOWN
                    x = 0;
                    y = -1;
                case obj.UP
                    x = 0;
                    y = 1;
                case obj.RIGHT
                    x = -1;
                    y = 0;
                case obj.LEFT
                    x = 1;
                    y = 0;
            end
            
        end
        
        function obj = checkSurroundings(obj,globalMap)
            x = obj.currentPos(1);
            y = obj.currentPos(2);
            bounds = obj.checkBoundaries(x,y);
            if(bounds(1))
                if globalMap(y,x-1)==1
                    obj.map(y,x-1) = obj.wall;
                elseif obj.map(y,x-1)~=obj.visitedPoint
                    obj.map(y,x-1) = obj.visitedPoint;
                    obj.newFinds = [obj.newFinds,[y;x-1]];
                end
            end
            
            if(bounds(2))
                if globalMap(y,x+1)==1
                    obj.map(y,x+1) = obj.wall;
                elseif obj.map(y,x+1)~=obj.visitedPoint
                    obj.map(y,x+1) = obj.visitedPoint;
                    obj.newFinds = [obj.newFinds,[y;x+1]];
                end                
            end
            
            if(bounds(3))
                if globalMap(y-1,x)==1
                    obj.map(y-1,x) = obj.wall;
                elseif obj.map(y-1,x)~=obj.visitedPoint
                    obj.map(y-1,x) = obj.visitedPoint;
                    obj.newFinds = [obj.newFinds,[y-1;x]];
                end
            end
            
            if(bounds(4)) 
                if globalMap(y+1,x)==1
                    obj.map(y+1,x) = obj.wall;
                elseif obj.map(y+1,x)~=obj.visitedPoint
                    obj.map(y+1,x) = obj.visitedPoint;
                    obj.newFinds = [obj.newFinds,[y+1;x]];
                end
            end     
        end
        
        function bounds = checkBoundaries(obj,x,y)
            bounds = [0, 0, 0, 0];
            if(x-1 >0)
                bounds(1) = 1;
            end
            if(x+1 < obj.sizex)
                bounds(2) = 1;
            end
            if(y-1 > 0)
                bounds(3) = 1;
            end
            if(y+1 < obj.sizey)
                bounds(4) = 1;
            end
            
        end
        
    end
end

% intersect(bot1,bot2)
% new_map = bot1.map+bot2.map;
% new_map(find(new_map > 0)) = 1;
% new_map(find(new_map < 0)) = -1;
% 
% [rowIs colIs] = find(abs(bot1.map)-abs(new_map) ~= 0));
% bot1.newFinds = [bot1.newFinds, [rowIs' ; colIs']];
% bot1.map = new_map;
% 
% [rowIs colIs] = find(abs(bot2.map)-abs(new_map) ~= 0));
% bot2.newFinds = [bot2.newFinds, [rowIs' ; colIs']];
% bot2.map = new_map;
% end
% 
% communicate(botIndex)
% for i = 1:size(numBots,2)
%     if(botDist(botIndex,i))
%         intersect(bot1,bot2);
%     end
% end
% 
% botDist(i1,i2)
%     return com_range > sqrt(sum((i1.currentPos-i2.currentPos).^2));
% end