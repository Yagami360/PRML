library(MASS)                             # ���ϐ����K�����̑g���݊֐����܂ރ��C�u����
library(class)                            # knn�@���܂ރ��C�u����

set.seed(8888)                            # ���񓯂������𔭐�������B

# �e�N���X�̒l�̍\��
mean_train1 <- c(2,2)                                  # �N���X�P�̒����l
sigma_train1 <- matrix( c(2,0,0,2),2,2 )               # �N���X�P�̋����U�s��𐶐�
dat_train1 <- mvrnorm( 100,mean_train1,sigma_train1 )  # ���ϐ��̐��K���z�Ɋ�Â���������f�[�^�擾�i�������_���T���v�����O�j
mean_train2 <- c(-2,0)                                 # �N���X�Q�̒����l
sigma_train2 <- matrix( c(2,0,0,2),2,2 )               # �N���X�Q�̋����U�s��𐶐�
dat_train2 <- mvrnorm( 100,mean_train2,sigma_train2 )  # ���ϐ��̐��K���z�Ɋ�Â���������f�[�^�擾�i�������_���T���v�����O�j
mean_train3 <- c(2,-2)                                 # �N���X�R�̒����l
sigma_train3 <- matrix( c(2,0,0,2),2,2 )               # �N���X�R�̋����U�s��𐶐�
dat_train3 <- mvrnorm( 100,mean_train3,sigma_train3 )  # ���ϐ��̐��K���z�Ɋ�Â���������f�[�^�擾�i�������_���T���v�����O�j

# �w�K�f�[�^�A���t�f�[�^���쐬 
train <- rbind( dat_train1,dat_train2,dat_train3 )               # �w�K�f�[�^
teach <- factor( c(rep("C1",100),rep("C2",100),rep("C3",100)) )  # ���t�f�[�^


# �e�e�X�g�f�[�^�̒l�̍\��
mean_test1 <- c(2,2)                                   # �e�X�g�f�[�^�P�̒����l
sigma_test1 <- matrix( c(2,0,0,2),2,2 )                # �e�X�g�f�[�^�̋����U�s��𐶐�
dat_test1 <- mvrnorm( 100,mean_test1,sigma_test1 )     # ���ϐ��̐��K���z�Ɋ�Â���������f�[�^�擾�i�������_���T���v�����O�j
mean_test2 <- c(-2,0)                                  # �e�X�g�f�[�^�Q�̒����l
sigma_test2 <- matrix( c(2,0,0,2),2,2 )                # �e�X�g�f�[�^�Q�̋����U�s��𐶐�
dat_test2 <- mvrnorm( 100,mean_test2,sigma_test2 )     # ���ϐ��̐��K���z�Ɋ�Â���������f�[�^�擾�i�������_���T���v�����O�j
mean_test3 <- c(2,-2)                                  # �e�X�g�f�[�^�R�̒����l
sigma_test3 <- matrix( c(2,0,0,2),2,2 )                # �e�X�g�f�[�^�R�̋����U�s��𐶐�
dat_test3 <- mvrnorm( 100,mean_test3,sigma_test3 )     # ���ϐ��̐��K���z�Ɋ�Â���������f�[�^�擾�i�������_���T���v�����O�j

# �e�X�g�f�[�^���쐬
test <- rbind( dat_test1,dat_test2,dat_test3 )  


# knn�@
k <- 1
result <- knn( train,test,teach,k,prob=TRUE )
table( teach,result )

# ��}
# �S�w�K�f�[�^�ƃe�X�g�f�[�^���N���X���ɐF�������ăv���b�g
plot( dat_train1[,1],dat_train1[,2], col="red",  pch=1, xlim=c(-4,4),ylim=c(-4,4), xlab="x",ylab="y" )
par(new=T)
plot( dat_train2[,1],dat_train2[,2], col="blue", pch=2, xlim=c(-4,4),ylim=c(-4,4), xlab="x",ylab="y" )
par(new=T)
plot( dat_train3[,1],dat_train3[,2], col="green",pch=0, xlim=c(-4,4),ylim=c(-4,4), xlab="x",ylab="y" )
par(new=T)
plot( dat_test1[,1],dat_test1[,2], col="black",pch=1, xlim=c(-4,4),ylim=c(-4,4), xlab="x",ylab="y" )
par(new=T)
plot( dat_test2[,1],dat_test2[,2], col="black",pch=2, xlim=c(-4,4),ylim=c(-4,4), xlab="x",ylab="y" )
par(new=T)
plot( dat_test3[,1],dat_test3[,2], col="black",pch=0, xlim=c(-4,4),ylim=c(-4,4), xlab="x",ylab="y" )
par(new=T)