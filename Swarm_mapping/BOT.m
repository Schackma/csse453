classdef BOT < handle
    %BOT a robot that can map
    
    properties
        map;
        mode;
        currentPos;
        broadcastMessage;
        wayHome;
        globalPos; %BOT's actual position not known by the BOT but used for simulation
        globalMap; %map not know by the BOT
    end
    
    methods
        function obj = BOT(pos,glmap)
            obj.map = -1;
            obj.mode = EXPLORE;
            obj.currentPos = [1,1];
            obj.globalPos = pos;
            obj.globalMap = glmap;
        end
        
        function obj = move(obj)
            switch obj.mode
                case EXPLORE
                    deltaPos = obj.findClosestPoint();
                    obj.broadcastMessage = SEARCHING;
                case INFORM
                    if size(obj.wayHome)==0
                        deltaPos = obj.findPathHome();
                    else
                        deltaPos = obj.wayHome(1,:);
                        obj.wayHome = obj.wayHome(2:end,:);
                    end
                    obj.broadcastMessage = FOUND_VICTIM;
                case RETURN
                    if size(obj.wayHome)==0
                        deltaPos = obj.findPathHome();
                    else
                        deltaPos = obj.wayHome(1,:);
                        obj.wayHome = obj.wayHome(2:end,:);
                    end
                    obj.broadcastMessage = MAP_COMPLETE;
            end
            obj.currentPos =obj.currentPos+deltaPos;
            obj.globalPos = obj.globalPos+deltaPos;
            obj.checkSurroundings()
        end
        
        function [dx,dy] = findClosestPoint(obj)
            [x,y] = obj.currentPos;
            possPoints=[0;0];
            currentPoint = obj.map(y,x);
            [dx,dy]=obj.checkBorders(x,y);
            x =x+dx;
            y = y+dy;
            dx =0;
            dy = 0;
            possPoints = [possPoints,[obj.map(y+1,x),obj.map(y-1,x),obj.map(y,x+1),obj.map(y,x-1);DOWN,UP,RIGHT,LEFT]];
            while currentPoint ~=0
               if obj.map(y+1,x)~=99
                   possPoints = [possPoints(:,1),[obj.map(y+1,x);currentDirection],possPoints(:,2:end)];
               end
               if obj.map(y-1,x)~=99
                   possPoints = [possPoints(:,1),[obj.map(y-1,x);currentDirection],possPoints(:,2:end)];
               end
               if obj.map(y,x+1)~=99
                   possPoints = [possPoints(:,1),[obj.map(y,x+1);currentDirection],possPoints(:,2:end)];
               end
               if obj.map(y,x-1)~=99
                   possPoints = [possPoints(:,1),[obj.map(y,x-1);currentDirection],possPoints(:,2:end)];
               end
                newData = possPoints(:,end);
                currentPoint = newData(1);
                currentDirection = newData(2);
                possPoints = possPoints(1:end-1);
            end
            switch currentDirection
                case UP
                    dx = 0;
                    dy = -1;
                case DOWN
                    dx = 0;
                    dy = 1;
                case LEFT
                    dx = -1;
                    dy = 0;
                case RIGHT
                    dx = 1;
                    dy = 0;
                otherwise
                    obj.mode= RETURN;
            end
        end
        
        function obj = findWayHome(obj)
            obj.recursivelyFindWayHome(obj.currentPos(1),obj.currentPos(2));
        end
        
        function found = recursivelyFindWayHome(obj,x,y)
            [sizeY,sizeX] = size(obj.map);
            if sizeY <y || sizeX <x || x<0|| y<0|| obj.map(y,x)==99
                found = false;
                return
            end
            
                
        end
        
        
        function [dx,dy] = checkBorders(obj,x,y)
            [sizeY,sizeX] = size(obj.map);
            dx = 0;
            dy =0;
            if x==sizeX
                obj.map = [obj.map,zero(sizeY,1)];
            elseif x==0
                obj.map = [zero(sizeY,1),obj.map];
                dx = 1;
            end
                
            if y==sizeY
                obj.map = [obj.map;zero(sizeY,1)]; 
            elseif y==0
                obj.map = [zero(sizeY,1);obj.map];
                dy = 1;
            end
            obj.currentPos = obj.currentPos+[dx,dy];
        end
        
        function obj = checkSurroundings(obj)
            [glx,gly] = obj.globalPos;
            [x,y] = obj.currentPos;
            if obj.globalMap(gly+1,glx)==1
                obj.currentPos(y+1,x) = 99;
            elseif obj.currentPos(y+1,x) ~=-1
                obj.currentPos(y+1,x) = 1;
            end
            
            if obj.globalMap(gly-1,glx)==1
                obj.currentPos(y-1,x) = 99;
            elseif obj.currentPos(y-1,x) ~=-1
                obj.currentPos(y-1,x) = 1;
            end
            
            if obj.globalMap(gly,glx+1)==1
                obj.currentPos(y,x+1) = 99;
            elseif obj.currentPos(y,x+1) ~=-1
                obj.currentPos(y,x+1) = 1;
            end
            
            if obj.globalMap(gly,glx-1)==1
                obj.currentPos(y,x-1) = 99;
            elseif obj.currentPos(y,x-1) ~=-1
                obj.currentPos(y,x-1) = 1;
            end
        end
    end
end

