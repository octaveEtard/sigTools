function varargout = convertToSamplesAt(inFs,outFs,operation,varargin)
%
% convert indices in sample at inFs to samples at outFs

nVar = length(varargin);

for iVar = 1:nVar
    varargin{iVar} = operation( (varargin{iVar}-1)/inFs*outFs ) + 1;
end
varargout = varargin;
end
%
%