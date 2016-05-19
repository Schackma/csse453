classdef simulation < handle
    %BOT a robot that can map
    
    properties
        bot_list;
        target_list = [];
        true_occupancy_grid;
        background;
        mothership_loc;
        frameDisp;
        stepSize;
        numBots;
        display_axes;
        
        bot_color = [160,32,240];
        mothership_color = [65,105,225];
        target_color = [255,255,0];
    end
    
    methods
        function obj = simulation(handles)       
            obj.mothership_loc = str2num(get(handles.start_loc_edit,'string'));
            obj.stepSize = str2num(get(handles.step_edit,'string'));
            obj.frameDisp = str2num(get(handles.sleep_edit,'string'));
            obj.numBots = str2num(get(handles.num_bots_edit,'string'));
            obj.display_axes = handles.display_axes;
            
            img = imread(get(handles.map_path_edit,'string'));
            img = rgb2gray(img);
            obj.true_occupancy_grid = ones(size(img));
            obj.true_occupancy_grid(find(img > 0)) = 0;
            
            obj.background = zeros(size(obj.true_occupancy_grid));
            
            obj.bot_list = [];
            for i = 1:obj.numBots
                bot = BOT(obj.mothership_loc,obj.mothership_loc,obj.true_occupancy_grid,obj.target_list);
                obj.bot_list = [obj.bot_list, bot];
            end
            
            obj.updateBotparams(str2num(get(handles.perception_edit,'string')),str2num(get(handles.communication_edit,'string')));
            obj.draw();
        end
        
        function obj = addBot(obj,newBots,handles)
            newBots = obj.findValidPoints(newBots);
            obj.numBots=obj.numBots+size(newBots,1);
            for i = 1:size(newBots,1)
               bot = BOT(newBots(i,:),obj.mothership_loc,obj.true_occupancy_grid,obj.target_list);
               obj.bot_list = [obj.bot_list,bot];
            end
            
            obj.updateBotparams(str2num(get(handles.perception_edit,'string')),str2num(get(handles.communication_edit,'string')));
            obj.draw();
        end
        
        function obj = addTarget(obj,newTargets) 
           newTargets = obj.findValidPoints(newTargets);
           obj.target_list = [obj.target_list;newTargets];
           obj.draw();
        end
        
        function validPoints = findValidPoints(obj,inArr)
            validPoints = [];
            for i=1:size(inArr,1)
                if obj.withinBounds(inArr(i,:)) && obj.true_occupancy_grid(inArr(i,1),inArr(i,2)) == 0
                    validPoints = [validPoints;inArr(i,:)];
                end
            end
        end
        
        function output = withinBounds(obj,inArr)
           output = 1;
           r = inArr(1); c= inArr(2);
           [rows,cols] = size(obj.true_occupancy_grid);
           if(c-1 <= 0 ||c+1 > cols || r-1 < 0 || r+1 > rows)
                output = 0;
           end
        end
        
        
        function [] = updateBackground(obj)
          newFinds = [];
           for i = 1:obj.numBots
               newFinds = [newFinds,obj.bot_list(i).newFinds];
               obj.bot_list(i).newFinds = [];
           end
           for i = 1:size(newFinds,2);
              obj.background(newFinds(1,i),newFinds(2,i)) = obj.background(newFinds(1,i),newFinds(2,i)) + 1;
           end 
        end
        
        function [] = draw(obj)
           obj.updateBackground();
           blackIndicies = find(obj.true_occupancy_grid == 1);          
           r = floor(255*(obj.numBots - obj.background)/obj.numBots);  r(blackIndicies) = 0;
           g = 255 - r(:,:,1); g(blackIndicies) = 0;
           img(:,:,1) = uint8(r); img(:,:,2) = uint8(g); img(:,:,3) = uint8(0);           
           
           for i = 1:obj.numBots %displaying robots
                cp = obj.bot_list(i).currentPos;
                img(cp(1),cp(2),:) = obj.bot_color;
           end
           img(obj.mothership_loc(1),obj.mothership_loc(2),:) = obj.mothership_color; %displaying home
           
           
           for i = 1:size(obj.target_list,1);
               cp = obj.target_list(i,:);
               img(cp(1),cp(2),:) = obj.target_color;
           end
           
           imshow(img, 'parent',obj.display_axes);
           set(obj.display_axes,'Visible','on');          
        end
        
        function [] = step(obj)
            for i = 1:obj.stepSize
                for j = 1:obj.numBots
                    obj.target_list =obj.bot_list(j).move(obj.true_occupancy_grid,obj.bot_list,obj.target_list);
                end % bot looping
                
                %frameDisp
                skip = obj.frameDisp == -1;
                if(~skip && mod(i,obj.frameDisp)==0)
                    obj.draw(); drawnow;
                end
            end % step looping 
            obj.draw(); drawnow;
        end % step function
        
        function [] = updateBotparams(obj,perceptionDist,communicationDist)
           for i = 1:obj.numBots
               obj.bot_list(i).com_range = communicationDist;
               obj.bot_list(i).vision_range = perceptionDist;
           end
        end %update bot params function
    end % method definitions
end % function definition

