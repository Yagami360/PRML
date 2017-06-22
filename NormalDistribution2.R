#options( repos="http://cran.ism.ac.jp" )
#install.packages( 'mvtnorm' )
#install.packages( 'scatterplot3d' )

library(mvtnorm)                             # ���ϗʐ��K���z������
library(scatterplot3d)                       # scatterplot3d�֐����g�p

dfAxis <- data.frame(                        # ���Ɋւ��Ẵf�[�^
  xMin = -5.0, xMax = 5.0,                   # x���̍ŏ��l�A�ő�l
  yMin = -5.0, yMax = 5.0                    # y���̍ŏ��l�A�ő�l
)

datX1 <- seq( from=-3.0, to=5.0, by=0.20 )   # x1���̒l�x�N�g��
datX2 <- seq( from=-3.0, to=5.0, by=0.20 )   # x2���̒l�x�N�g��
datU <- c( 2.0, 1.0 )                        # ���ϒl�x�N�g��
matS <- matrix(                              # �����U���U�s��
  data = c( 0.7, 0.5, 0.5, 2.0 ),
  nrow = 2, ncol = 2 
)

############################
# set desitiny functions   #
############################
funcNormDim2 <- function( x1, x2 ) 
{ 
  dmvnorm(
    matrix( c(x1,x2), ncol=2 ), 
    mean=datU, sigma=matS
  ) 
}

dfNorm <- data.frame( x1=datX1, x2=datX2, z=0 )         # �f�[�^�t���[���ɂ܂Ƃ߂�
dfNorm$z <- outer(dfNorm$x1, dfNorm$x2, funcNormDim2)   # x1��x2�̊O�ςŏc�����������߂�

numRam <- 1000                                         # �����̐�
datRNorm <- rmvnorm( n=numRam, mean=datU, sigma=matS )  # 2�����̐��K���z�Ɋ�Â���������
dfRNorm <- data.frame(
  x1 = datRNorm[,1],
  x2 = datRNorm[,2],
  z =  dmvnorm( x = datRNorm, mean = datU, sigma = matS)
)

############################
# set graphics parameters  #
############################
par( mfrow=c(1,1) )

title <- "���K���z�֐��i�Q�ϐ��j"
xlim <- range( c(dfAxis$xMin, dfAxis$xMax) )
ylim <- range( c(dfAxis$yMin, dfAxis$yMax) )
xlab <- "x1"
ylab <- "x2"
zlab <- "probability"

############################
# Draw in dim3 figure      #
############################
#win.graph() # �ʂ̂̃O���t�B�b�N�E�C���h�E�ɍ�}
persp(
  x = dfNorm$x1, y = dfNorm$x2, z = dfNorm$z, 
  theta = 20, phi = 20, expand = 0.5,
  main = title,
  xlab = xlab, ylab = ylab, zlab = zlab,
  ticktype = "detailed",
  col = "lightblue"
)

#win.graph() # �ʂ̂̃O���t�B�b�N�E�C���h�E�ɍ�}
scatterplot3d(
  x = dfRNorm$x1, y = dfRNorm$x2, z = dfRNorm$z,
  main = title,
  xlab = xlab, ylab = ylab, zlab = zlab,
  highlight = TRUE
)


############################
# Draw in dim2 figure      #
############################
# ������plot
#plot( 
#  dfRNorm,
#  main = title,
#  xlab = xlab, ylab = ylab,
#  xlim = xlim, ylim = ylim,
#  type = "p"      
#)
#grid()

# �������i���ϒl�j�̒����ǉ�
#abline( v = datU[1], h = datU[2], lty = "dotdash" )

# ��������plot�ǉ�
#par(new=T)
#plot(
#  dfNorm$x1[500:1000], dfNorm$x2[500:1000],
#  main = title,
#  xlab = xlab, ylab = ylab,
#  xlim = xlim, ylim = ylim,
#  pch = 3,
#  type = "p"      
#)
#contour(
#  x = dfNorm$x1,
#  y = dfNorm$x2,
#  z = z,  # �s��ɕϊ�
#  nlevels = 1
#)