function [] = dispImg(img,handles)
imshow(img, 'parent',handles.display_axes);
set(handles.display_axes,'Visible','on');
end