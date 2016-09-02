/*
 Implementation of Julian Parker’s digital model of a Ring
 Modulator. 

 http://kunstmusik.com/2013/09/07/julian-parker-ring-modulator/

 UDO version by Steven Yi
 Original: 2013.09.07
 Revised: 2015.04.07

*/
	opcode ringmod,a,aa

ain, acarrier xin

itab chnget "ringmod.table"

; TABLE INIT

if(itab == 0) then
; generate table according to formula 2 in document
itablen = 2^16
itab ftgen 0, 0, itablen, -2, 0
i_vb = 0.2
i_vl = 0.4
i_h = .1
i_vl_vb_denom = ((2 * i_vl) - (2 * i_vb))
i_vl_add =  i_h * ( ((i_vl - i_vb)^2) / i_vl_vb_denom)
i_h_vl = i_h * i_vl

indx = 0

chnset itab, "ringmod.table"

ihalf = itablen / 2

until (indx >= itablen) do
  iv = (indx - ihalf) / ihalf
  iv = abs(iv)


  if(iv <= i_vb) then
      tableiw 0, indx, itab, 0, 0, 2
  elseif(iv <= i_vl) then
      ival = i_h * ( ((iv - i_vb)^2) / i_vl_vb_denom)
      tableiw ival, indx, itab, 0, 0, 2
  else
      ival = (i_h * iv) - i_h_vl + i_vl_add
      tableiw ival, indx, itab, 0, 0, 2
  endif
  indx += 1
od

endif

; END TABLE INIT
ain1 = (ain * .5)
acar2 = acarrier + ain1
ain2 = acarrier - ain1

asig1 table3 acar2, itab, 1, 0.5
asig2 table3 -acar2, itab, 1, 0.5
asig3 table3 ain2, itab, 1, 0.5
asig4 table3 -ain2, itab, 1, 0.5

asiginv = -(asig3 + asig4)

aout sum asig1, asig2, asiginv

xout aout

endop

