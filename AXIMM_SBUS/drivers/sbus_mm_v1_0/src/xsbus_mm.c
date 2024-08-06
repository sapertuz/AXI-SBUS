// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xsbus_mm.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XSbus_mm_CfgInitialize(XSbus_mm *InstancePtr, XSbus_mm_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XSbus_mm_Start(XSbus_mm *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_AP_CTRL) & 0x80;
    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XSbus_mm_IsDone(XSbus_mm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XSbus_mm_IsIdle(XSbus_mm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XSbus_mm_IsReady(XSbus_mm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XSbus_mm_EnableAutoRestart(XSbus_mm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XSbus_mm_DisableAutoRestart(XSbus_mm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_AP_CTRL, 0);
}

void XSbus_mm_Set_data(XSbus_mm *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_DATA_DATA, (u32)(Data));
    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_DATA_DATA + 4, (u32)(Data >> 32));
}

u64 XSbus_mm_Get_data(XSbus_mm *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_DATA_DATA);
    Data += (u64)XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_DATA_DATA + 4) << 32;
    return Data;
}

void XSbus_mm_InterruptGlobalEnable(XSbus_mm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_GIE, 1);
}

void XSbus_mm_InterruptGlobalDisable(XSbus_mm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_GIE, 0);
}

void XSbus_mm_InterruptEnable(XSbus_mm *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_IER);
    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_IER, Register | Mask);
}

void XSbus_mm_InterruptDisable(XSbus_mm *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_IER);
    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_IER, Register & (~Mask));
}

void XSbus_mm_InterruptClear(XSbus_mm *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSbus_mm_WriteReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_ISR, Mask);
}

u32 XSbus_mm_InterruptGetEnabled(XSbus_mm *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_IER);
}

u32 XSbus_mm_InterruptGetStatus(XSbus_mm *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSbus_mm_ReadReg(InstancePtr->Control_BaseAddress, XSBUS_MM_CONTROL_ADDR_ISR);
}

