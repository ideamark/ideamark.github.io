/***************************************************************************
标题：51频率计
说明：通过对信号在1s内的脉冲计数值求得频率，并通过数码管显示结果
工作于：LY5A-L2A开发板
作者：YangTing
日期：2012年4月9日
备注：使用12M晶振，频率量程<10000Hz
******************************************************************************/

TIMER_H EQU 46H ;定时器高位字节单元
TIMER_L EQU 47H ;定时器低位字节单元
TIMCOUNT EQU 48H ;时间中断数

INT_H EQU 45H ;T1计数缓冲单元高地址
INT_L EQU 44H ;T1计数缓冲单元低地址

;脚功能定义
SMG_q EQU P1.0 ;定义数码管阳级控制脚，千位
SMG_b EQU P1.1 ;定义数码管阳级控制脚，百位
SMG_s EQU P1.2 ;定义数码管阳级控制脚，十位
SMG_g EQU P1.3 ;定义数码管阳级控制脚，个位

;数据存放
ORG 0100H
TABLE: DB 0C0h,0F9H,0A4H,0b0H,99H,92H,82H,0F8H,80H,90H
;表：共阳数码管 0-9 

ORG 0000H
LJMP START

ORG 000BH
JMP T0_interrupt 

ORG 0200H
;-------------------------------------------------------------
;主程序
;-------------------------------------------------------------
START: LCALL PRO_init 
LCALL TIM_set

LOOP: 
MOV R0,INT_H
MOV R1,INT_L
LCALL HEX2BCD 
MOV A,R4
MOV B,#16
DIV AB ;除以16，目的是分离出高、低四位
MOV R1,A ;存放十位
MOV R0,B ;存放个位
MOV A,R2
MOV A,R3
MOV B,#16
DIV AB
MOV R3,A ;存放千位
MOV R2,B ;存放百位

LCALL DISPLAY 
JMP LOOP

;---------------------------------------------------------
;初始化程序
;---------------------------------------------------------
PRO_init:
MOV A,#00H
MOV B,#00H
MOV P0,#0FFH
MOV P1,#0FFH
MOV P2,#0FFH
MOV INT_H,#00H
MOV INT_L,#00H
MOV TIMCOUNT,#00H
MOV TIMER_H,#3CH ;定时 50 MS
MOV TIMER_L,#0B0H 
SETB P3.5 ;P3.5端口（T1）置输入状态
RET

;--------------------------------------------------------
;定时/计数器设置
;T0,T1均工作于方式1，T0用于定时，T1用于脉冲计数
;--------------------------------------------------------
TIM_set: 
MOV TMOD,#0D1H ;T0,T1模式设置
MOV TH0,TIMER_H ;设置定时初值高位 
MOV TL0,TIMER_L ;设置定时初值低位
MOV TH1,#00H ;清T1计数器
MOV TL1,#00H
MOV IE,#82H ;开总中断，开T0中断
SETB TR1 ;计数器T1开始工作
SETB TR0 ;定时器T0开始工作
RET

;-------------------------------------------------------
;十六进制数转十进制
;-------------------------------------------------------
HEX2BCD:
CLR A
MOV R2,A ;先清零
MOV R3,A 
MOV R4,A 
MOV R5,#16 ;共转换十六位数
ELOOP:
CLR C
MOV A,R1 ;从待转换数的高端移出一位到Cy
RLC A
MOV R1,A
MOV A,R0
RLC A
MOV R0,A
MOV A,R4 ;送到BCD码的低端
ADDC A,R4 ;带进位加。自身相加，相当于左移一位
DA A ;十进制调整，变成BCD码
MOV R4,A
MOV A,R3
ADDC A,R3
DA A
MOV R3,A
MOV A,R2
ADDC A,R2
MOV R2,A
DJNZ R5,ELOOP ;共转换十六位数
RET

;-------------------------------------------------------
;定时器0中断服务程序
;-------------------------------------------------------
T0_interrupt:
CLR TR0 ;关闭T0
MOV TL0,TIMER_L ;重新赋初值
MOV TH0,TIMER_H 

INC TIMCOUNT ;定时1S，时间单位
MOV A,TIMCOUNT ;查看数量值
CJNE A,#20,T_END ;如果没有到1S返回

CLR TR1 ;关闭T1
MOV TIMCOUNT,#00H ;到1S则清零
MOV INT_L,TL1 ;取出计数值
MOV INT_H,TH1 

MOV TH1,#00H ;清空T1数据
MOV TL1,#00H
SETB TR1 ;重启T1
T_END: 
SETB TR0 ;重启T0
RETI

;-------------------------------------------------------
;数码管显示子程序
;-------------------------------------------------------
DISPLAY: 
MOV DPTR,#TABLE
MOV A,R3
CLR SMG_q ;千位数码管
MOVC A,@A+DPTR
MOV P0,A
LCALL DELAY
MOV P0,#0FFH
SETB SMG_q

MOV A,R2
CLR SMG_b ;百位数码管
MOVC A,@A+DPTR
MOV P0,A
LCALL DELAY
MOV P0,#0FFH
SETB SMG_b

MOV A,R1
CLR SMG_s ;十位数码管
MOVC A,@A+DPTR
MOV P0,A
LCALL DELAY
MOV P0,#0FFH
SETB SMG_s

MOV A,R0
CLR SMG_g ;个位数码管
MOVC A,@A+DPTR
MOV P0,A
LCALL DELAY
MOV P0,#0FFH
SETB SMG_g
RET

;-------------------------------------------------------
;延时子程序
;-------------------------------------------------------
DELAY: MOV R7,#10
DJNZ R7,$
RET
END
