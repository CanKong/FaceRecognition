function varargout = FaceRecognition(varargin)
% FACERECOGNITION MATLAB code for FaceRecognition.fig
%      FACERECOGNITION, by itself, creates a new FACERECOGNITION or raises the existing
%      singleton*.
%
%      H = FACERECOGNITION returns the handle to a new FACERECOGNITION or the handle to
%      the existing singleton*.
%
%      FACERECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACERECOGNITION.M with the given input arguments.
%
%      FACERECOGNITION('Property','Value',...) creates a new FACERECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FaceRecognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FaceRecognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FaceRecognition

% Last Modified by GUIDE v2.5 19-Apr-2018 20:26:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FaceRecognition_OpeningFcn, ...
                   'gui_OutputFcn',  @FaceRecognition_OutputFcn, ...
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


% --- Executes just before FaceRecognition is made visible.
function FaceRecognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FaceRecognition (see VARARGIN)

% Choose default command line output for FaceRecognition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FaceRecognition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FaceRecognition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function kuaizhao_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kuaizhao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in kuaizhao.
function kuaizhao_Callback(hObject, eventdata, handles)
% hObject    handle to kuaizhao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Snap_folder = 0;
%??
answer1 = BoxMenu ('Menu', 'Do you want new snaps?');  
    if answer1 == 1
        choice = questdlg('If in the ?', ...
        'New Snap Pool','yes','no', 'fix'); 
            switch choice
                case 'yes'
                    M=1;
                case 'no'    
                    M=2;
            end
            %????????
            rmdir('PCATest/train','s');
            mkdir('PCATest/train');
            Snap_folder = 'PCATest/train';
            
            if M== 1
                %?????
                [~, IFaces, bboxes] = Snapshot(1);
                %????????
                I = HOGFeatures(IFaces,bboxes);
                I=ReSize(I);
                imwrite(I,['Foto_', num2str(M),'.bmp']);
                movefile(strcat('Foto_', num2str(M),'.bmp'),Snap_folder);
            end
          
            
    end
    



% --- Executes on button press in face_show.
function face_show_Callback(hObject, eventdata, handles)
% hObject    handle to face_show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global im;
    im = imread('D:\file\bysj\PCATest\train\Foto_1.bmp');
    axes( handles.axes1);
    imshow(im);


% --- Executes on button press in face_text.
function face_text_Callback(hObject, eventdata, handles)
% hObject    handle to face_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global reference
global W
global imgmean
global col_of_data
global pathname
global img_path_list

% 批量读取指定文件夹下的图片128*128
pathname = uigetdir;
img_path_list = dir(strcat(pathname,'\*.bmp'));
img_num = length(img_path_list);
imagedata = [];
if img_num >0
    for j = 1:img_num
        img_name = img_path_list(j).name;
        temp = imread(strcat(pathname, '/', img_name));
        temp = double(temp(:));
        imagedata = [imagedata, temp];
    end
end
% lie shu
col_of_data = size(imagedata,2);

% ge hang jun zhi
imgmean = mean(imagedata,2);
for i = 1:col_of_data
% i lie   dui ying de suo you hang de zhi zu cheng yi ge xiang liang
    imagedata(:,i) = imagedata(:,i) - imgmean;
end
% zhuan zhi
covMat = imagedata'*imagedata;
% zhuchengfen tezhengzhi percent
[COEFF, latent, explained] = pcacov(covMat);

% 选择构成95%能量的特征值
i = 1;
proportion = 0;
while(proportion < 95)
    proportion = proportion + explained(i);
    i = i+1;
end
p = i - 1;

% te zheng lian
W = imagedata*COEFF;    % N*M阶
W = W(:,1:p);           % N*p阶

% xunlian yangben zaixinzuobiaoji juzhen  p*M
reference = W'*imagedata;


% --- Executes on button press in face_rec.
function face_rec_Callback(hObject, eventdata, handles)
% hObject    handle to face_rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
global reference
global W
global imgmean
global col_of_data
global pathname
global img_path_list

% 预处理新数据
% im daishibie renlian  w tezheng lian
im = double(im(:));
objectone = W'*(im - imgmean);
distance = 100000000;
H = 0;
% 最小距离法，寻找和待识别图片最为接近的训练图片
for k = 1:col_of_data
    temp = norm(objectone - reference(:,k));
    if(distance>temp)
        aimone = k;
        distance = temp;
        aimpath = strcat(pathname, '/', img_path_list(aimone).name);
        axes( handles.axes2 )
        imshow(aimpath)
        H = 1; 
    end

end
    if(H==0)
        warndlg('Unrecognized','warning')
    end


% --- Executes on button press in face_ceshi.
function face_ceshi_Callback(hObject, eventdata, handles)
% hObject    handle to face_ceshi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
[filename, pathname] = uigetfile({'*.bmp'},'choose photo');
str = [pathname, filename];
im = imread(str);
axes( handles.axes1);
imshow(im);
