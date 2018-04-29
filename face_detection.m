%  ??????        
      faceDetector = vision.CascadeObjectDetector; % ??????? 
      I = imread('visionteam.jpg');
      bboxes = step(faceDetector, I); % ????
% ????????
      IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');   
      figure, imshow(IFaces), title('Detected faces'); 
 imread('visionteam.jpg');

 
 
 