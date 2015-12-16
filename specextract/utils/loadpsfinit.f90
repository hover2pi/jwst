subroutine loadPSFinit(ntrace,sol,ncutpsf,nline,dtrace,line)
use precision
implicit none
integer :: ntrace,i,ncutpsf,ncutd2,di,nfit,nline,xm,xp,k,j
real(double) :: Sintsolt,triplegaussian,Sintsol
real(double), allocatable, dimension(:) :: solt !solution template
real(double), dimension(:) :: sol,line
real(double), dimension(:,:) :: dtrace

!constants
nfit=10 !number of variables for a triple-Gaussian

!precomputed values
ncutd2=ncutpsf/2

!allocate arrays
allocate(solt(nfit))

!initial model template based on fit to noiseless PSF trace at line 800.
solt(1)=0.0d0 !background
!first Gaussian
solt(2)=1.5406681  !amplitude
solt(3)=-7.442  !position
solt(4)=1.60659  !width
!Second Gaussian
solt(5)=1.5942485  !amplitude
solt(6)=8.372  !position
solt(7)=1.77816  !width
!Third  Gaussian
solt(8)=1.0  !amplitude
solt(9)=0.0  !position
solt(10)=7.97951 !width

Sintsolt=0.0d0  !sum up the flux from the PSF - we will scale relative
do i=-ncutd2+1,ncutd2
   di=dble(i)
   Sintsolt=Sintsolt+triplegaussian(nfit,solt,di)
enddo
!write(0,*) "Sintsolt: ",Sintsolt

sol(1)=solt(1)  !to be replace with SKY value

do k=1,ntrace
   i=dtrace(nline,k)
   xm=max(1,i-ncutd2+1)      !we will now fit the PSF to the line
   xp=min(size(line),i+ncutd2)
   Sintsol=Sum(line(xm:xp)) !Sum of line elements over width of ncutpsf
!   write(0,*) k,Sintsol
   sol(2+9*(k-1))=solt(2)*Sintsol/Sintsolt
   sol(3+9*(k-1))=solt(3)+dble(i)
   sol(4+9*(k-1))=solt(4)
   sol(5+9*(k-1))=solt(5)*Sintsol/Sintsolt
   sol(6+9*(k-1))=solt(6)+dble(i)
   sol(7+9*(k-1))=solt(7)
   sol(8+9*(k-1))=solt(8)*Sintsol/Sintsolt
   sol(9+9*(k-1))=solt(9)+dble(i)
   sol(10+9*(k-1))=solt(10)
enddo

!do i=1,size(sol)
!   write(0,*) "sol:",i,sol(i)
!enddo

!read(5,*)

return
end subroutine loadPSFinit
