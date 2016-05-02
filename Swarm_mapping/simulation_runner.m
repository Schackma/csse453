function varargout = simulation_runner(varargin)
% SIMULATION_runner MATLAB code for simulation_runner.fig
%      SIMULATION_RUNNER, by itself, creates a new SIMULATION_runner or raises the existing
%      singleton*.
%
%      H = SIMULATION_RUNNER returns the handle to a new SIMULATION_runner or the handle to
%      the existing singleton*.
%
%      SIMULATION_RUNNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATION_runner.M with the given input arguments.
%
%      SIMULATION_RUNNER('Property','Value',...) creates a new SIMULATION_runner or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simulation_runner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simulation_runner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simulation_runner

% Last Modified by GUIDE v2.5 17-Apr-2016 23:11:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulation_runner_OpeningFcn, ...
                   'gui_OutputFcn',  @simulation_runner_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before simulation_runner is made visible.
function simulation_runner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simulation_runner (see VARARGIN)

% Choose default command line output for simulation_runner
handles.output = hObject;
handles.user.simulation = simulation(handles); %dummy variable for typing
dispImg(handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simulation_runner wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simulation_runner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function num_bots_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_bots_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function map_path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to map_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of map_path_edit as text
%        str2double(get(hObject,'String')) returns contents of map_path_edit as a double
dispImg(handles);

% --- Executes during object creation, after setting all properties.
function map_path_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to map_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in map_path_pushbutton.
function map_path_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to map_path_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
[fn, pn] = uigetfile({'*.jpg;*.tif;*.png;*.gif'},'select image file');
if isequal(fn,0) || isequal(pn,0)
    return;
end
completePath = strcat(pn,fn);
set(handles.map_path_edit,'string',completePath);
dispImg(handles);
guidata(hObject, handles);

function start_loc_edit_Callback(hObject, eventdata, handles)
% hObject    handle to start_loc_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_loc_edit as text
%        str2double(get(hObject,'String')) returns contents of start_loc_edit as a double
dispImg(handles);

% --- Executes during object creation, after setting all properties.
function start_loc_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_loc_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    hnandle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with hadles and user data (see GUIDATA)

set(handles.start_button, 'enable', 'off');
set(handles.num_bots_edit, 'enable', 'off');
set(handles.map_path_edit, 'enable', 'off');
set(handles.start_loc_edit, 'enable', 'off');
set(handles.map_path_pushbutton, 'enable', 'off');

set(handles.step_pushbutton, 'enable', 'on');
set(handles.step_edit, 'enable', 'on');
set(handles.sleep_edit, 'enable', 'on');

handles.user.simulation = simulation(handles);
guidata(hObject, handles);

function step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_edit as text
%        str2double(get(hObject,'String')) returns contents of step_edit as a double
handles.user.simulation.stepSize = str2num(get(hObject,'string'));

% --- Executes during object creation, after setting all properties.
function step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in step_pushbutton.
function step_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to step_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.user.simulation.step();

function sleep_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sleep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sleep_edit as text
%        str2double(get(hObject,'String')) returns contents of sleep_edit as a double
handles.user.simulation.stepDelay = str2num(get(hObject,'string'));

% --- Executes during object creation, after setting all properties.
function sleep_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sleep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function num_bots_edit_Callback(hObject, eventdata, handles)
return;
