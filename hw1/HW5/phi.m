function phi= phi(j,x,h)

phi=(1/h*x+(1-j)).*(x<=(j*h) & x>=((j-1)*h))+(-1/h*x+(1+j)).*(x>(j*h) & x<=((j+1)*h));

end