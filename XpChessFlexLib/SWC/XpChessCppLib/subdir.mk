################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
/home/sigma/projects/xpchess/XpChessCppLib/src/chessgame.cpp 

OBJS += \
./XpChessCppLib/chessgame.o 

CPP_DEPS += \
./XpChessCppLib/chessgame.d 


# Each subdirectory must supply rules for building sources it contributes
XpChessCppLib/chessgame.o: /home/sigma/projects/xpchess/XpChessCppLib/src/chessgame.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -I/home/sigma/projects/xpchess/XpChessCppLib/src -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


