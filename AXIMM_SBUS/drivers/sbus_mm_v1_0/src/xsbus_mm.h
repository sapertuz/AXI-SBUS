// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XSBUS_MM_H
#define XSBUS_MM_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xsbus_mm_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
} XSbus_mm_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XSbus_mm;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XSbus_mm_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XSbus_mm_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XSbus_mm_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XSbus_mm_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XSbus_mm_Initialize(XSbus_mm *InstancePtr, UINTPTR BaseAddress);
XSbus_mm_Config* XSbus_mm_LookupConfig(UINTPTR BaseAddress);
#else
int XSbus_mm_Initialize(XSbus_mm *InstancePtr, u16 DeviceId);
XSbus_mm_Config* XSbus_mm_LookupConfig(u16 DeviceId);
#endif
int XSbus_mm_CfgInitialize(XSbus_mm *InstancePtr, XSbus_mm_Config *ConfigPtr);
#else
int XSbus_mm_Initialize(XSbus_mm *InstancePtr, const char* InstanceName);
int XSbus_mm_Release(XSbus_mm *InstancePtr);
#endif

void XSbus_mm_Start(XSbus_mm *InstancePtr);
u32 XSbus_mm_IsDone(XSbus_mm *InstancePtr);
u32 XSbus_mm_IsIdle(XSbus_mm *InstancePtr);
u32 XSbus_mm_IsReady(XSbus_mm *InstancePtr);
void XSbus_mm_EnableAutoRestart(XSbus_mm *InstancePtr);
void XSbus_mm_DisableAutoRestart(XSbus_mm *InstancePtr);

void XSbus_mm_Set_data(XSbus_mm *InstancePtr, u64 Data);
u64 XSbus_mm_Get_data(XSbus_mm *InstancePtr);

void XSbus_mm_InterruptGlobalEnable(XSbus_mm *InstancePtr);
void XSbus_mm_InterruptGlobalDisable(XSbus_mm *InstancePtr);
void XSbus_mm_InterruptEnable(XSbus_mm *InstancePtr, u32 Mask);
void XSbus_mm_InterruptDisable(XSbus_mm *InstancePtr, u32 Mask);
void XSbus_mm_InterruptClear(XSbus_mm *InstancePtr, u32 Mask);
u32 XSbus_mm_InterruptGetEnabled(XSbus_mm *InstancePtr);
u32 XSbus_mm_InterruptGetStatus(XSbus_mm *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
