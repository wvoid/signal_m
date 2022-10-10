function v=read_complex_binary(filename,count)
m=nargchk(1,2,nargin);
if (m)
    error(m);
end
if (nargin<2)
    count=Inf;
end
f=fopen(filename,'rb');
if(f<0)
    v=0;
else
    n=ceil(count/100e6);
    t=fread(f,[2,count],'float');
    fclose(f);
    v=t(1,:)+t(2,:)*i;
    [r,c]=size(v);
    v=reshape(v,c,r);
end