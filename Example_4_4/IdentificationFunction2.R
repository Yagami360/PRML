library( MASS )     # MASS package�i�s�}�E�C���f�B�A��Pima �̃f�[�^���g�p�j

# set options
options( digits=5 ) # �\������

# Pima data expand on memory
data( Pima.tr )
data( Pima.te )

# copy data from Pima data
lstPimaTrain <- list(
  numNoDiabetes = 0,       # ���A�a�����ǐl���i0�ŏ������j
  numDiabetes = 0,         # ���A�a���ǐl���i0�ŏ������j
  glu = Pima.tr$glu, 
  bmi = Pima.tr$bmi, 
  bResult = rep(FALSE, length(Pima.tr$glu)) # ���A�a���ۂ��H�iFALSE:���A�a�łȂ��ATRUE:���A�a�j
)

# Pima.tr$type �̃f�[�^�iYes,No�j�𕄍���[encoding]�i���ȒP�̂���for���[�v�g�p�j
for ( i in 1:length(Pima.tr$type) ) 
{
  if(Pima.tr$type[i] == "Yes" )
  {
    lstPimaTrain$numDiabetes <- (lstPimaTrain$numDiabetes + 1)
    lstPimaTrain$bResult[i] <- TRUE
  }
  else if( Pima.tr$type[i] == "No" )
  {
    lstPimaTrain$numNoDiabetes <- (lstPimaTrain$numNoDiabetes + 1)
    lstPimaTrain$bResult[i] <- FALSE
  }
  else{
    # Do Nothing
  }
}

# sort Pima data
lstPimaTrain$glu <- lstPimaTrain$glu[ order(lstPimaTrain$bResult) ]
lstPimaTrain$bmi <- lstPimaTrain$bmi[ order(lstPimaTrain$bResult) ]
lstPimaTrain$bResult <- lstPimaTrain$bResult[ order(lstPimaTrain$bResult) ]

# split data to class C1 and C2
dfPimaTrain_C1 <- data.frame(
  glu = lstPimaTrain$glu[1:lstPimaTrain$numNoDiabetes], 
  bmi = lstPimaTrain$bmi[1:lstPimaTrain$numNoDiabetes],
  bResult = FALSE             # ���A�a���ۂ��H�iFALSE:���A�a�łȂ��ATRUE:���A�a�j
)
dfPimaTrain_C2 <- data.frame(
  glu = lstPimaTrain$glu[(lstPimaTrain$numNoDiabetes+1):(lstPimaTrain$numNoDiabetes+lstPimaTrain$numDiabetes)], 
  bmi = lstPimaTrain$bmi[(lstPimaTrain$numNoDiabetes+1):(lstPimaTrain$numNoDiabetes+lstPimaTrain$numDiabetes)],
  bResult = TRUE             # ���A�a���ۂ��H�iFALSE:���A�a�łȂ��ATRUE:���A�a�j
)

# sort class C1,C2 data
dfPimaTrain_C1$glu <- dfPimaTrain_C1$glu[ order(dfPimaTrain_C1$glu) ]
dfPimaTrain_C1$bmi <- dfPimaTrain_C1$bmi[ order(dfPimaTrain_C1$glu) ]
dfPimaTrain_C2$glu <- dfPimaTrain_C2$glu[ order(dfPimaTrain_C2$glu) ]
dfPimaTrain_C2$bmi <- dfPimaTrain_C2$bmi[ order(dfPimaTrain_C2$glu) ]

# release memory
rm(Pima.tr) 
rm(Pima.te)

#-------------------
# set class C1 data
#-------------------
datU1_C1 <- mean( dfPimaTrain_C1$glu ) # �N���X�P�i���A�a���ǂȂ��j�̕ϐ��P�iglu�j�̕��ϒl
datU2_C1 <- mean( dfPimaTrain_C1$bmi ) # �N���X�P�i���A�a���ǗL��j�̕ϐ��Q�iBMI�j�̕��ϒl
datU_C1 <- matrix( c(datU1_C1,datU2_C1), nrow = 2, ncol = 1)      # �N���X�P�i���A�a���ǂȂ��j�̕��σx�N�g��

matS_C1 <- matrix( c(0,0,0,0), nrow = 2, ncol = 2 ) # �N���X�P�i���A�a���ǂȂ��j�̋����U�s��
matS_C1[1,1] <- sqrt( var( dfPimaTrain_C1$glu, dfPimaTrain_C1$glu ) )
matS_C1[1,2] <- sqrt( var( dfPimaTrain_C1$glu, dfPimaTrain_C1$bmi ) )
matS_C1[2,1] <- sqrt( var( dfPimaTrain_C1$bmi, dfPimaTrain_C1$glu ) )
matS_C1[2,2] <- sqrt( var( dfPimaTrain_C1$bmi, dfPimaTrain_C1$bmi ) )

#-------------------
# set class C2 data
#-------------------
datU1_C2 <- mean( dfPimaTrain_C2$glu ) # �N���X�Q�i���A�a���ǂȂ��j�̕ϐ��P�iglu�j�̕��ϒl
datU2_C2 <- mean( dfPimaTrain_C2$bmi ) # �N���X�Q�i���A�a���ǗL��j�̕ϐ��Q�iBMI�j�̕��ϒl
datU_C2 <- matrix( c(datU1_C2,datU2_C2), nrow = 2, ncol = 1)      # �N���X�P�i���A�a���ǂȂ��j�̕��σx�N�g��

matS_C2 <- matrix( c(0,0,0,0), nrow = 2, ncol = 2 ) # �N���X�Q�i���A�a���ǂȂ��j�̋����U�s��
matS_C2[1,1] <- sqrt( var( dfPimaTrain_C2$glu, dfPimaTrain_C2$glu ) )
matS_C2[1,2] <- sqrt( var( dfPimaTrain_C2$glu, dfPimaTrain_C2$bmi ) )
matS_C2[2,1] <- sqrt( var( dfPimaTrain_C2$bmi, dfPimaTrain_C2$glu ) )
matS_C2[2,2] <- sqrt( var( dfPimaTrain_C2$bmi, dfPimaTrain_C2$bmi ) )

##################################
# secondary idification function
##################################
Dim2IdificationFunc <- function( x1, x2, u_C1, u_C2, matS1, matS2, P_C1=0.5, P_C2=0.5 )
{
  datX <- matrix( 0, nrow = 2, ncol = 1  )
  datX[1,] <- x1
  datX[2,] <- x2
  matW <- matrix( c(0,0,0,0), nrow = 2, ncol = 2 )
  matW <- ( solve(matS1) - solve(matS2) )
  vct <- ( t(u_C2)%*%solve(matS2) - t(u_C1)%*%solve(matS1) )
  r <- ( t(u_C1)%*%solve(matS1)%*%u_C1 - t(u_C2)%*%solve(matS2)%*%u_C2 + log( det(matS1)/det(matS2) ) - 2*log(P_C1/P_C2) )
  
  z0 <- ( t(datX)%*%matW%*%datX )
  z1 <- ( 2*vct%*%datX )
  z <- ( z0 + z1 + r )
  return(z)
}

###############################
# liner idification function
###############################
Dim1IdificationFunc <- function( x1, x2, u_C1, u_C2, matS1, matS2, P_C1=0.5, P_C2=0.5 )
{
  datX <- matrix( 0, nrow = 2, ncol = 1  )
  datX[1,] <- x1
  datX[2,] <- x2
  
  matSp <- matrix( c(0,0,0,0), nrow = 2, ncol = 2 )
  matSp <- P_C1*matS1 + P_C2*matS2
  vct <- ( t(u_C2)%*%solve(matSp) - t(u_C1)%*%solve(matSp) )
  r <- ( t(u_C1)%*%solve(matSp)%*%u_C1 - t(u_C2)%*%solve(matSp)%*%u_C2 + log( det(matSp)/det(matSp) ) - 2*log(P_C1/P_C2) )
  
  z <- ( 2*vct%*%datX + r )
  return(z)
}

############################
# ROC Curve                #
############################
#----------------------------------------------------------------------
# �U�z����[false positive rate]�Ɛ^�z����[true positive rate]�̎Z�o
#----------------------------------------------------------------------
datBorder <- seq( from = -200, to = 200, by = 5 )

# secondary idification function
dfROC2 <- data.frame(
  sigma2 = matrix( 0, nrow = length(datBorder), ncol = 1 ),
  sigma1 = matrix( 0, nrow = length(datBorder), ncol = 1 )
)

matZResult2 <- matrix( 0,     nrow = (lstPimaTrain$numNoDiabetes+lstPimaTrain$numDiabetes), ncol = length(datBorder) )
matResult2  <- matrix( FALSE, nrow = (lstPimaTrain$numNoDiabetes+lstPimaTrain$numDiabetes), ncol = length(datBorder) )

for( m in 1:length(datBorder) )
{
  for( k in 1:(lstPimaTrain$numNoDiabetes+lstPimaTrain$numDiabetes) )
  {
    matZResult2[k,m] <- Dim2IdificationFunc(
      x1 = lstPimaTrain$glu[k], x2 = lstPimaTrain$bmi[k],
      u_C1 = datU_C1, u_C2 = datU_C2, matS1 = matS_C1, matS2 = matS_C2
    )
    
    if( matZResult2[k,m] >= datBorder[m] )
    {
      matResult2[k,m] <- TRUE
    }
    else
    {
      matResult2[k,m] <- FALSE
    }
    
    tblRes <- table( lstPimaTrain$bResult, matResult2[,m] )
    dfROC2$sigma2[m] <- tblRes[2,1]/(lstPimaTrain$numDiabetes)
    dfROC2$sigma1[m] <- tblRes[1,1]/(lstPimaTrain$numNoDiabetes)      
  }
}

# liner idification function
dfROC1 <- data.frame(
  sigma2 = matrix( 0, nrow = length(datBorder), ncol = 1 ),
  sigma1 = matrix( 0, nrow = length(datBorder), ncol = 1 )
)
matZResult1 <- matrix( 0,     nrow = (lstPimaTrain$numNoDiabetes+lstPimaTrain$numDiabetes), ncol = length(datBorder) )
matResult1  <- matrix( FALSE, nrow = (lstPimaTrain$numNoDiabetes+lstPimaTrain$numDiabetes), ncol = length(datBorder) )

for( m in 1:length(datBorder) )
{
  for( k in 1:(lstPimaTrain$numNoDiabetes+lstPimaTrain$numDiabetes) )
  {
    matZResult1[k,m] <- Dim2IdificationFunc(
      x1 = lstPimaTrain$glu[k], x2 = lstPimaTrain$bmi[k],
      u_C1 = datU_C1, u_C2 = datU_C2, matS1 = matS_C1, matS2 = matS_C2,
      P_C1 = lstPimaTrain$numNoDiabetes/(lstPimaTrain$numNoDiabetes+lstPimaTrain$numDiabetes),
      P_C2 = lstPimaTrain$numNoDiabetes/(lstPimaTrain$numDiabetes+lstPimaTrain$numDiabetes)
    )
    
    if( matZResult1[k,m] >= datBorder[m] )
    {
      matResult1[k,m] <- TRUE
    }
    else
    {
      matResult1[k,m] <- FALSE
    }
    
    tblRes <- table( lstPimaTrain$bResult, matResult2[,m] )
    dfROC1$sigma2[m] <- tblRes[2,1]/(lstPimaTrain$numDiabetes)
    dfROC1$sigma1[m] <- tblRes[1,1]/(lstPimaTrain$numNoDiabetes)      
  }
}

############################
# ����������[loss line]    #
############################
dfLossLine1 <- data.frame( # ����������L12
  dat1 = c( -0.01, 0.10 ),
  dat2 = c( -0.01, 0.98 ) 
)
dfLossLine2 <- data.frame( # ����������L21
  dat1 = c( -0.01, 0.17 ),
  dat2 = c( 0.00, 0.98 ) 
)


############################
# set graphics parameters  #
############################
# ���Ɋւ��Ẵf�[�^���X�g
lstAxis <- list(                        
  xMin = 0.0, xMax = 1.0,  # x���̍ŏ��l�A�ő�l
  yMin = 0.0, yMax = 1.0,  # y���̍ŏ��l�A�ő�l
  zMin = 0.0, zMax = 1.0,  # z���̍ŏ��l�A�ő�l
  xlim = range( c(0.0, 1.0) ), 
  ylim = range( c(0.0, 1.0) ), 
  zlim = range( c(0.0, 1.0) ),
  mainTitle1 = "ROC�Ȑ��i�Q�������K���z�j\n�Q�����ʊ֐�[secondary idification function]", # �}�̃��C���^�C�g���i�}�̏�j
  mainTitle2 = "ROC�Ȑ��i�Q�������K���z�j\n���`���ʊ֐�[liner idification function]",     # �}�̃��C���^�C�g���i�}�̏�j
  mainTitle3 = "ROC�Ȑ��i�Q�������K���z�j\n�Q�����ʊ֐�+���`���ʊ֐�",     # �}�̃��C���^�C�g���i�}�̏�j
  subTitle1  = "�Q�����ʊ֐�[dim2 idification function]",    # �}�̃T�u�^�C�g���i�}�̉��j
  subTitle2  = "���`���ʊ֐�[liner idification function]",    # �}�̃T�u�^�C�g���i�}�̉��j
  subTitle3  = "�Q�����ʊ֐�+���`���ʊ֐�",    # �}�̃T�u�^�C�g���i�}�̉��j
  xlab      = "�U�z���� [false positive rate]",        # x���̖��O
  ylab      = "�^�z���� [true positive rate]",         # y���̖��O
  zlab      = "z"            # z���̖��O
)
lstAxis$xlim = range( c(lstAxis$xMin, lstAxis$xMax) )
lstAxis$ylim = range( c(lstAxis$yMin, lstAxis$yMax) )
lstAxis$zlim = range( c(lstAxis$zMin, lstAxis$zMax) )

#########################
# Draw figure           #
#########################
#------------------------------------------------
# plot ROC Curve (secondary idification function)
#------------------------------------------------
plot(
  dfROC2$sigma2, dfROC2$sigma1,
  main = lstAxis$mainTitle1,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "red",
  pch = 1,     # pch=0(��), pch=1(��), pch=2(��), pch=3(+)
  type = "p"   # �_�Ɛ�      
)
grid()  # �}�ɃO���b�h����ǉ�

# add plot loss line �i�����������j
par(new=T)
plot( 
  dfLossLine1$dat1, dfLossLine1$dat2,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "green",
  type = "l"
)

par(new=T)
plot( 
  dfLossLine2$dat1, dfLossLine2$dat2,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "6",
  type = "l" 
)

# �}��̒ǉ�
legend(
  x = 0.4, y = 0.5,
  legend = "�Q�����ʊ֐�",
  col = "red",
  pch = 1,
  text.width = 0.3
)
legend(
  x = 0.4, y = 0.3,
  legend = c("���������P", "���������Q"),
  col = c("green","6"),
  lty = 1,
  text.width = 0.3
)

#------------------------------------------------
# plot ROC Curve (liner idification function)
#------------------------------------------------
plot(
  dfROC1$sigma2, dfROC1$sigma1,
  main = lstAxis$mainTitle2,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "blue",
  pch = 3,     # pch=0(��), pch=1(��), pch=2(��), pch=3(+)
  type = "p"   # �_�Ɛ�      
)
grid()  # �}�ɃO���b�h����ǉ�

# add plot loss line �i�����������j
par(new=T)
plot( 
  dfLossLine1$dat1, dfLossLine1$dat2,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "green",
  type = "l"
)

par(new=T)
plot( 
  dfLossLine2$dat1, dfLossLine2$dat2,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "6",
  type = "l"
)

# �}��̒ǉ�
legend(
  x = 0.4, y = 0.5,
  legend = "���`���ʊ֐�",
  col = "blue",
  pch = 3,
  text.width = 0.3
)
legend(
  x = 0.4, y = 0.3,
  legend = c("���������P", "���������Q"),
  col = c("green","6"),
  lty = 1,
  text.width = 0.3
)

#-------------------------------------------------------------------------------
# plot ROC Curve (secondary idification function + liner idification function)
#-------------------------------------------------------------------------------
plot(
  dfROC2$sigma2, dfROC2$sigma1,
  main = lstAxis$mainTitle3,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "red",
  pch = 1,     # pch=0(��), pch=1(��), pch=2(��), pch=3(+)
  type = "p"   # �_�Ɛ�      
)
grid()  # �}�ɃO���b�h����ǉ�
par(new=T)
plot(
  dfROC1$sigma2, dfROC1$sigma1,
  main = lstAxis$mainTitle3,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "blue",
  pch = 3,     # pch=0(��), pch=1(��), pch=2(��), pch=3(+)
  type = "p"   # �_�Ɛ�      
)

# add plot loss line �i�����������j
par(new=T)
plot( 
  dfLossLine1$dat1, dfLossLine1$dat2,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "green",
  type = "l"
)

par(new=T)
plot( 
  dfLossLine2$dat1, dfLossLine2$dat2,
  xlab = lstAxis$xlab, ylab = lstAxis$ylab,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  col = "6",
  type = "l" 
)

# �}��̒ǉ�
legend(
  x = 0.4, y = 0.6,
  legend = c("�Q�����ʊ֐�", "���`���ʊ֐�"),
  col = c("red","blue"),
  pch = c(1,3),
  text.width = 0.3
)
legend(
  x = 0.4, y = 0.3,
  legend = c("���������P", "���������Q"),
  col = c("green","6"),
  lty = 1,
  text.width = 0.3
)